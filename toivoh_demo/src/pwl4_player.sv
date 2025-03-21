/*
 * Copyright (c) 2024-2025 Toivo Henningsson
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

`include "pwl4_synth.vh"
`include "common.vh"

module mc_buffer #(parameter BITS) (
		input wire clk,
		input wire [BITS-1:0] in,
		output wire [BITS-1:0] out
	);
`ifdef MC_BUF_CELLS
	genvar i;
	generate
		for (i = 0; i < BITS; i++) begin : bits
			//(* keep *) sky130_fd_sc_hd__buf_1 mc_buf(.A(in[i]), .X(out[i]));
			(* keep *) (* dont_touch *) buf mc_buf(out[i], in[i]);
		end
	endgenerate
`elsif MC_CHANGE
	reg [BITS-1:0] prev;
	always @(posedge clk) prev <= in;
	wire changed = (in != prev);
	`ifdef MC_CHANGE_ZERO
	assign out = changed ? '0 : in;
	`else
	assign out = changed ? 'X : in;
	`endif
`else
	assign out = in;
`endif
endmodule

module pwl4_player #(
//		parameter CYCLES_PER_SAMPLE=400, CHANNEL0=0, NUM_CHANNELS=-1, CHAN_TIMER_BITS=6, OCT_BITS=3, ACC_BITS=11, OSC_BITS=23, ALT_OSC_BITS=9, OUT_ACC_BITS=10, OUT_BITS=10, DOUBLE_OSC_RATE=0
//		parameter CYCLES_PER_SAMPLE=516, CHANNEL0=0, NUM_CHANNELS=-1, CHAN_TIMER_BITS=6, OCT_BITS=3, ACC_BITS=11, OSC_BITS=23, ALT_OSC_BITS=9, OUT_ACC_BITS=10, OUT_BITS=10, DOUBLE_OSC_RATE=0
		parameter CYCLES_PER_SAMPLE=800, CHANNEL0=0, NUM_CHANNELS=-1, CHAN_TIMER_BITS=6, OCT_BITS=3, ACC_BITS=11, OSC_BITS=23, ALT_OSC_BITS=9, OUT_ACC_BITS=10, OUT_BITS=10, DOUBLE_OSC_RATE=0
	) (
		input wire clk, reset, en,
		input wire [1:0] advance,

		output wire [$clog2(CYCLES_PER_SAMPLE >> CHAN_TIMER_BITS)-1:0] channel_out,
		input wire [$clog2(CYCLES_PER_SAMPLE >> CHAN_TIMER_BITS)-1:0] alt_channel, // use if use_alt_osc is high

		input wire use_alt_osc,
		input wire [ALT_OSC_BITS-1:0] alt_osc,
		input wire [`SYNTH_N_SAR_BITS-1:0] alt_n_sar,
		output wire channel_output_valid,

		output wire next_sample,
		output wire pwm_out,

		output wire [OUT_BITS-1:0] pw_out, // for debug only
		output wire [$clog2(CYCLES_PER_SAMPLE)-1:0] subsample_timer_out, // for debug only
		output wire chan_en_out,
		output wire [ACC_BITS-1:0] acc,
		output wire [OSC_BITS-1:0] rosc_out
	);

//	localparam CHANNEL0_B = CHANNEL0;
	localparam CHANNEL0_B = CHANNEL0 >> 1;

	localparam TOTAL_CHANNELS = CYCLES_PER_SAMPLE >> CHAN_TIMER_BITS; // excluding the new sample channel
	localparam FINISH_CHANNEL_CYCLES = CYCLES_PER_SAMPLE - (TOTAL_CHANNELS << CHAN_TIMER_BITS);

	localparam NOTE_BITS = OCT_BITS + 4;
	localparam T_BITS = 4;

`ifdef USE_SEMITONE_CODING
	localparam note_C  =  4'd0;
	localparam note_Db =  4'd1;
	localparam note_D  =  4'd2;
	localparam note_Eb =  4'd3;
	localparam note_E  =  4'd4;
	localparam note_F  =  4'd5;
	localparam note_Fs =  4'd6;
	localparam note_G  =  4'd7;
	localparam note_Ab =  4'd8;
	localparam note_A  =  4'd9;
	localparam note_Bb = 4'd10;
	localparam note_B  = 4'd11;
`else
	localparam note_C  =  4'd0;
	localparam note_Db =  4'd1;
	localparam note_D  =  4'd2;
	localparam note_Eb =  4'd4;
	localparam note_E  =  4'd5;
	localparam note_F  =  4'd6;
	localparam note_Fs =  4'd7;
	localparam note_G  =  4'd8;
	localparam note_Ab =  4'd10;
	localparam note_A  =  4'd11;
	localparam note_Bb = 4'd12;
	localparam note_B  = 4'd13;
`endif

	// POS_BITS + SUBPOS_BITS must be <= OSC_BITS
	localparam POS_BITS = `POS_BITS;
	localparam SUBPOS_BITS = 13;

	localparam SUBSAMPLE_BITS = $clog2(CYCLES_PER_SAMPLE);
	localparam CHAN_BITS = $clog2(CYCLES_PER_SAMPLE>>CHAN_TIMER_BITS);

	localparam AMP_EXT_BITS = ACC_BITS - 1;
	localparam SLANT_EXT_BITS = ACC_BITS - 2;
	localparam SLANT_BITS = `SYNTH_N_SLANT_BITS + SLANT_EXT_BITS;

	localparam OUT_ACC_INITIAL = (CYCLES_PER_SAMPLE & ~63) / 2;
	localparam FULL_T_BITS = T_BITS+SUBPOS_BITS;

	localparam LOG2_NOISE_SAMPLES = 12;


	//reg [SUBSAMPLE_BITS-1:0] subsample_timer;


	reg [CHAN_TIMER_BITS-1:0] chan_timer; // chan_timer is one sample behind channel_sc
	reg [CHAN_BITS-1:0] channel_sc;
	wire [CHAN_BITS-1:0] channel_mc;

	//assign {channel_sc, chan_timer} = subsample_timer;
	//wire new_sample = (subsample_timer >> `LOG2_NEW_SAMPLE_CYCLES) == (CYCLES_PER_SAMPLE-1) >> `LOG2_NEW_SAMPLE_CYCLES;
	// High for at least 2**`LOG2_NEW_SAMPLE_CYCLES-1 cycles
	wire new_sample = (channel_sc == TOTAL_CHANNELS) && ((chan_timer >> `LOG2_NEW_SAMPLE_CYCLES) == (FINISH_CHANNEL_CYCLES >> `LOG2_NEW_SAMPLE_CYCLES) - 1);

	//assign next_sample = subsample_timer == CYCLES_PER_SAMPLE-1;
	assign next_sample = (channel_sc == TOTAL_CHANNELS) && (chan_timer == FINISH_CHANNEL_CYCLES-2);

	wire signed [ACC_BITS-1:0] ext0, ext1, ext2, ext3;
//	wire [OCT_BITS-1:0] oct;
	wire [`SYNTH_N_SLANT_BITS-1:0] n_slant;
//	wire [`SYNTH_N_SAR_BITS-1:0] n_sar;

	wire [OSC_BITS-1:0] osc0, rosc_sc, rosc_mc;
	assign rosc_sc = ~osc0; // Invert osc since it counts backwards


	mc_buffer #(.BITS(OSC_BITS))  mc_buffer_osc(    .clk(clk), .in(rosc_sc),    .out(rosc_mc));
	//mc_buffer #(.BITS(OSC_BITS-5))  mc_buffer_osc(    .clk(clk), .in(rosc_sc[OSC_BITS:5]),    .out(rosc_mc[OSC_BITS:5]));
	//assign rosc_mc[4:0] = '0;

	wire [CHAN_BITS-1:0] channel_eff_sc = use_alt_osc ? alt_channel : channel_sc;
	mc_buffer #(.BITS(CHAN_BITS)) mc_buffer_channel(.clk(clk), .in(channel_eff_sc), .out(channel_mc));


	wire [`DEMO_TIME_BITS-1:0] timer = rosc_mc >> 10;
	wire [`DEMO_CONTROL_BITS-1:0] control;
	demo_control controller(.timer(timer), .control(control));


	wire [POS_BITS-1:0] pos; // = rosc_mc >> SUBPOS_BITS; 
	wire [SUBPOS_BITS-1:0] subpos;
	//assign {pos, subpos} = rosc_mc;
	assign {pos[6:0], subpos} = rosc_mc;
`ifdef POS_BITS_GT1_PATTERN
	assign pos[POS_BITS-1:7] = control[`DEMO_CONTROL_BIT_PATTERN + `PATTERN_BITS - 1 -: `PATTERN_BITS];
`endif


	localparam BASE_OCT = 3'd2;

	wire [FULL_T_BITS-1:0] full_t;

	wire [CHAN_BITS-1:0] channel_mask;
	assign channel_mask[CHAN_BITS-1:1] = '1;
	wire detune_double = control[`DEMO_CONTROL_BIT_DETUNE_DOUBLE];
	assign channel_mask[0] = !detune_double;

	wire [3:0] channel_abs_mc;

	//wire square_en = control[`DEMO_CONTROL_BIT_SQUARE];
	//wire square_en = control[`DEMO_CONTROL_BIT_SQUARE] && (channel_abs_mc[3:1] == 2);
	wire square_en = (control[`DEMO_CONTROL_BIT_SQUARE] && (channel_abs_mc[3:1] == 0)) || control[`DEMO_CONTROL_BIT_ALL_SQUARE];
	//wire square_en = control[`DEMO_CONTROL_BIT_SQUARE] && (channel_abs_mc[3:1] == 1);
	wire pwmod_en = square_en;

	// not registers
	reg chan_en, chan_en1; // TODO: better way to turn off a channel?
	//reg signed [ACC_BITS-1:0] factor;
	reg [NOTE_BITS-1:0] note, note1;
	//reg [OCT_BITS-1:0] oct;
	reg [`SYNTH_WF_BITS-1:0] wf;
	reg [SLANT_BITS-1:0] slant;
	reg [`SYNTH_N_SAR_BITS-1:0] n_sar;
	reg [ACC_BITS-1:0] amp;
	reg [T_BITS-1:0] t, t1;

	//reg [NOTE_BITS-1:0] note0;
	wire [NOTE_BITS-1:0] note0 = note;
	wire [4:0] nt_plus_5 = note0[3:0] + 5;
	wire nt_overflow = nt_plus_5[4] | (nt_plus_5[3:2] == '1);
	wire [3:0] nt_raise = nt_plus_5 - (nt_overflow ? 12 : 0);
	//wire [OCT_BITS-1:0] oct_raise = note0[NOTE_BITS-1:4] + nt_overflow; // raise
	wire [OCT_BITS-1:0] oct_raise = note0[NOTE_BITS-1:4] - !nt_overflow; // lower
	wire [NOTE_BITS-1:0] note_raise = {oct_raise, nt_raise};

	always_comb begin
		chan_en = 0;
		note = 'X;
		t = 'X;

		if (control[`DEMO_CONTROL_BIT_MELODY]) begin
//			case (channel_mc[CHAN_BITS-1:1])
//			case (channel_mc)
			case (channel_mc & channel_mask)
`ifdef SMALL
//`include "track-data-generated.v"
`include "track-data-li-generated.v"
`else
`include "track-data-li-generated.v"
`endif
			endcase
		end
	end

	always_comb begin
		chan_en1 = chan_en;
		t1 = t;

		//factor = 'X; oct = 'X;
		//amp = 2**AMP_EXT_BITS-1;
		//amp = ~rosc_mc >> (OSC_BITS - AMP_EXT_BITS); 

		//wf = 2**`SYNTH_WF_BIT_SAW;
		wf = (!square_en) << `SYNTH_WF_BIT_SAW;

		//slant = '1;
		//slant = 2 << SLANT_EXT_BITS;
		//slant = 0;
		//slant = ~rosc_mc >> (OSC_BITS - (SLANT_BITS - 1));
		n_sar = ACC_BITS - 6;
		//n_sar = ACC_BITS - (SUBSAMPLE_BITS - 1) + 2;
		//n_sar = ACC_BITS - (SUBSAMPLE_BITS - 1) + 1;

		//oct = BASE_OCT;
		slant = 'X;
		amp = 'X;

		note1 = note;
		if (control[`DEMO_CONTROL_BIT_RAISE]) note1 = note_raise;

		if (control[`DEMO_CONTROL_BIT_BASS] && channel_mc[CHAN_BITS-1:1] == 0 - CHANNEL0_B) begin
			t1 = pos & ~1;
			note1 = pos[2] ? {3'd2, note_G} : {3'd2, note_C};
			chan_en1 = pos[1:0] != 3;
			if (pos[6] && pos[4:3] == '1) begin
				note1 = pos[2] ? {3'd2, note_Fs} : {3'd2, note_D};
				chan_en1 = 1;
			end
		end

		amp   = ~full_t >> (FULL_T_BITS - AMP_EXT_BITS);
		slant = ~full_t >> (FULL_T_BITS - (SLANT_BITS - 1));

		if (channel_mc[CHAN_BITS-1:1] == 4 - CHANNEL0_B) begin
			if (channel_mc[0] == 0) begin
				// Hack: add prenoise to channel 8
				wf = 2**`SYNTH_WF_BIT_PRENOISE;
				//wf[`SYNTH_WF_BIT_PRENOISE] = 1; // dominates?
				wf[`SYNTH_WF_BIT_PRENOISE_ALT] = (rosc_mc[`SYNTH_PRENOISE_MSB+2 -: 2] == '1);
				n_sar = ACC_BITS - 6;
				chan_en1 = control[`DEMO_CONTROL_BIT_PRENOISE] | use_alt_osc;
			end else begin
				// Hack; add bass drum to channel 9
				wf = 2**`SYNTH_WF_BIT_BDRUM;
				n_sar = ACC_BITS - 7;
				chan_en1 = control[`DEMO_CONTROL_BIT_BDRUM];
				//oct = pos[1] == 0 ? 5 : 4;
				note1 = {pos[1] == 0 ? 3'd5 : 3'd4, 4'bXXXX};
				//note1 = {pos[1] == 0 ? 3'd6 : 3'd5, 4'bXXXX};
				slant = 0;
				amp = (~full_t >> (`SYNTH_QUAD_X_BITS - AMP_EXT_BITS + 1)) & (2**AMP_EXT_BITS - 1);
			end
		end
		if (channel_mc[CHAN_BITS-1:1] == 5 - CHANNEL0_B) begin
			if (channel_mc[0] == 0) begin
				// Hack: add noise to channel 10
				wf = 2**`SYNTH_WF_BIT_NOISE;
				//note1 = {3'd6, 4'bXXXX};
				note1 = {3'd7, 4'bXXXX};
				n_sar = ACC_BITS - 6;
				amp = (~full_t >> (LOG2_NOISE_SAMPLES - AMP_EXT_BITS + 1)) & (2**AMP_EXT_BITS - 1);
				//chan_en1 = full_t[SUBPOS_BITS-1:LOG2_NOISE_SAMPLES] == 0 && (pos[1:0] == 2);
				chan_en1 = full_t[SUBPOS_BITS-1:LOG2_NOISE_SAMPLES] == 0 && (pos[0] == 0) && control[`DEMO_CONTROL_BIT_NDRUM];

				if (control[`DEMO_CONTROL_BIT_NOISE]) begin
					amp = '1;
					chan_en1 = 1;
				end
			end
		end

/*
		note1 = {BASE_OCT, note_C};
		chan_en1 = 1;
		t1 = 0;
*/


		//if (pos[3:2]=='1) chan_en1 = 0;

		if (NUM_CHANNELS != -1) if (channel_sc >= NUM_CHANNELS) chan_en1 = 0;
		if (use_alt_osc) n_sar = alt_n_sar;
	end

	wire [OCT_BITS-1:0] oct;
	wire [3:0] onote;
	assign {oct, onote} = note1;

	// not a register
	reg [ACC_BITS-1:0] factor;
	always_comb begin
		case (onote)
			note_C:  factor = 255;
`ifdef USE_RAISE
			note_Db: factor = 271;
`endif
			note_D:  factor = 286;
			note_Eb: factor = 303;
			note_E:  factor = 322;
			note_F:  factor = 341;
			note_Fs: factor = 361;
			note_G:  factor = 383;
			note_Ab: factor = 405;
			note_A:  factor = 430;
			note_Bb: factor = 455;
			note_B:  factor = 482;
			default: factor = 'X;
		endcase
	end

	//wire [T_BITS-1:0] t_eff = t1;
	wire [T_BITS-1:0] t_eff = t1 + pos[T_BITS-1:0];

	assign full_t = {t_eff, subpos};

	//wire [ACC_BITS-1:0]   amp   = ~full_t >> (FULL_T_BITS - AMP_EXT_BITS);
	//wire [SLANT_BITS-1:0] slant = ~full_t >> (FULL_T_BITS - (SLANT_BITS - 1));


	// reduce amp a bit?
	wire [AMP_EXT_BITS-1:0] amp_eff;
	assign amp_eff = amp; // 1/1
	//assign amp_eff = (amp[AMP_EXT_BITS-1 -: 3] == 7) ? 7 << (AMP_EXT_BITS - 3) : amp; // 7/8
	//assign amp_eff = (amp[AMP_EXT_BITS-1 -: 2] == 3) ? 3 << (AMP_EXT_BITS - 2) : amp; // 6/8
	//assign amp_eff = (amp[AMP_EXT_BITS-1 -: 3] >= 5) ? 5 << (AMP_EXT_BITS - 3) : amp; // 5/8
	//assign amp_eff = (amp[AMP_EXT_BITS-1 -: 1] == 1) ? 1 << (AMP_EXT_BITS - 1) : amp; // 4/8


	assign channel_abs_mc = channel_mc + CHANNEL0;
	wire arp_chan = (channel_abs_mc[3] == 0);
	wire detune = channel_mc[0] && arp_chan && detune_double;

	assign ext0 = factor;
	assign ext1 = slant[SLANT_EXT_BITS-1:0];
	assign n_slant = slant[SLANT_BITS-1 -: `SYNTH_N_SLANT_BITS];
	assign ext2 = amp_eff;

	assign ext3 = pwmod_en && arp_chan ? rosc_mc >> (15 - ACC_BITS) : '0;

/*
	// Debug
	reg [OUT_BITS-1:0] temp;
	always @(posedge clk) begin
		if (reset) begin
			temp <= 0;
		end else begin
			temp <= temp+new_sample;
		end
	end
	*/

	wire we_out;
	wire [OUT_ACC_BITS-1:0] out_acc;
	reg [OUT_BITS-1:0] out_pw; // = 0;
	reg [OUT_BITS-1:0] out_pw_stable; // for debug only
	wire out_pw_high = out_pw == ((CYCLES_PER_SAMPLE>>1)-1);


	wire [ACC_BITS-1:0] ext0_sched, ext1_sched, ext2_sched, ext3_sched;
	wire [`SYNTH_WF_BITS-1:0] wf_sched;
	wire [OCT_BITS-1:0] oct_sched;
	wire [`SYNTH_N_SLANT_BITS-1:0] n_slant_sched;
	wire [`SYNTH_N_SAR_BITS-1:0] n_sar_sched;
	wire detune_sched;

`ifdef MC_PIPELINE_SCHED_INPUTS
	reg [ACC_BITS-1:0] ext0_delayed, ext1_delayed, ext2_delayed, ext3_delayed;
	reg [`SYNTH_WF_BITS-1:0] wf_delayed;
	reg [OCT_BITS-1:0] oct_delayed;
	reg [`SYNTH_N_SLANT_BITS-1:0] n_slant_delayed;
	reg [`SYNTH_N_SAR_BITS-1:0] n_sar_delayed;
	reg detune_delayed;

	always @(posedge clk) begin
		ext0_delayed <= ext0;
		ext1_delayed <= ext1;
		ext2_delayed <= ext2;
		ext3_delayed <= ext3;
		wf_delayed <= wf;
		oct_delayed <= oct;
		n_slant_delayed <= n_slant;
		n_sar_delayed <= n_sar;
		detune_delayed <= detune;
	end

	assign ext0_sched = ext0_delayed;
	assign ext1_sched = ext1_delayed;
	assign ext2_sched = ext2_delayed;
	assign ext3_sched = ext3_delayed;
	assign wf_sched = wf_delayed;
	assign oct_sched = oct_delayed;
	assign n_slant_sched = n_slant_delayed;
	assign n_sar_sched = n_sar_delayed;
	assign detune_sched = detune_delayed;
`else
	assign ext0_sched = ext0;
	assign ext1_sched = ext1;
	assign ext2_sched = ext2;
	assign ext3_sched = ext3;
	assign wf_sched = wf;
	assign oct_sched = oct;
	assign n_slant_sched = n_slant;
	assign n_sar_sched = n_sar;
	assign detune_sched = detune;
`endif


	pwl4_scheduler #(.TIMER_BITS(CHAN_TIMER_BITS), .OCT_BITS(OCT_BITS), .ACC_BITS(ACC_BITS), .OSC_BITS(OSC_BITS), .ALT_OSC_BITS(ALT_OSC_BITS),
	  .OUT_ACC_BITS(OUT_ACC_BITS), .OUT_ACC_INITIAL(OUT_ACC_INITIAL), .DOUBLE_OSC_RATE(DOUBLE_OSC_RATE)) sched(
		.clk(clk), .reset(reset), .en(en && (chan_en1 || new_sample)), .advance(advance),
		.chan_timer(chan_timer), .new_sample(new_sample),
		.ext0(ext0_sched), .ext1(ext1_sched), .ext2(ext2_sched), .ext3(ext3_sched),
		.wf(wf_sched), .oct(oct_sched), .n_slant(n_slant_sched), .n_sar(n_sar_sched), .detune(detune_sched),
		.use_alt_osc(use_alt_osc), .alt_osc(alt_osc), .channel_output_valid(channel_output_valid),
		.osc(osc0), .acc(acc), .we_out(we_out), .out_acc(out_acc)
	);
	//assign out_pw = temp;

	always_ff @(posedge clk) begin
		/*
		if (reset) begin
			subsample_timer <= 0;
		end else if (en) begin
			if (subsample_timer == CYCLES_PER_SAMPLE-1) subsample_timer <= 0;
			else subsample_timer <= subsample_timer + 1;
		end
		*/
		if (reset || en) begin
			if (reset) begin
				//channel_sc <= 0;
				//chan_timer <= '1; // chan_timer is one cycle behind channel_sc
				// Start in sync with the raster scan
				channel_sc <= 9;
				chan_timer <= 31; // chan_timer is one cycle behind channel_sc
			end else if (/*reset ||*/ next_sample) begin
				channel_sc <= 0;
				chan_timer <= '1; // chan_timer is one cycle behind channel_sc
			end else begin
				channel_sc <= channel_sc + (chan_timer == 2**CHAN_TIMER_BITS - 2);
				chan_timer <= chan_timer + 1;
			end
		end

		if (reset) out_pw <= 0;
		else if (we_out) out_pw <= out_acc;
		else out_pw <= out_pw + !out_pw_high;

		if (we_out) out_pw_stable <= out_acc; // for debug only
	end

	// TODO: higher frequency: scramble som bits in subsample_timer?
	//assign pwm_out = (out_pw >= subsample_timer);

	/*
	// Compensate for that channel is one cycle ahead of chan_timer to create a coherent PWM signal anyway
	wire cmp_low = (chan_timer <= out_pw[CHAN_TIMER_BITS-1:0]) && !(chan_timer == '1);
	wire cmp_high_below = channel_sc < out_pw[OUT_BITS-1:CHAN_TIMER_BITS];
	wire cmp_high_equal = channel_sc == out_pw[OUT_BITS-1:CHAN_TIMER_BITS];
	assign pwm_out = cmp_high_equal ? cmp_low : cmp_high_below;
	*/
	assign pwm_out = out_pw_high;


	//assign pw_out = out_pw;
	assign pw_out = out_pw_stable; // for debug only

	//assign subsample_timer_out = subsample_timer;
	assign subsample_timer_out = {channel_sc, chan_timer + 1'b1};

	assign chan_en_out = chan_en1;
	assign channel_out = channel_sc;
	assign rosc_out = rosc_sc;
endmodule : pwl4_player
