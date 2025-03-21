/*
 * Copyright (c) 2024-2025 Toivo Henningsson
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

`include "pwl4_synth.vh"
`include "common.vh"

module pwl4_synth_ALU #(parameter ACC_BITS=10, OSC_BITS=18, ALT_OSC_BITS=9, OUT_ACC_BITS=10, OUT_ACC_INITIAL=0) (
		input wire clk, reset, en,
		input wire [1:0] advance,

		input wire [`SYNTH_TERM1_BITS-1:0] term1_sel,
		input wire [`SYNTH_TERM2_BITS-1:0] term2_sel,
		input wire [`SYNTH_ALU_FLAG_BITS-1:0] alu_flags,
		input wire [`SYNTH_OSC_BIT_BITS-1:0] osc_cond_bit,
		input wire [`SYNTH_ACC_BIT_BITS-1:0] acc_we_nbits,
		input wire [`SYNTH_WE_BITS-1:0] we,

		input wire signed [ACC_BITS-1:0] ext0, ext1, ext2, ext3,
		input wire detune,

		input wire use_alt_osc,
		input wire [ALT_OSC_BITS-1:0] alt_osc,

		input wire double_osc_step,

		output wire [OSC_BITS-1:0] osc_out,
		output wire [ACC_BITS-1:0] acc_out,
		output wire we_out, // if high, use out_acc value to write to out
		output wire [OUT_ACC_BITS-1:0] out_acc
	);

	genvar i;

	reg [OSC_BITS-1:0] osc;
	reg [ACC_BITS-1:0] acc;// = 0;
	reg signed [OUT_ACC_BITS-1:0] out_acc_reg;// = 0;
	reg p0, p1;

	wire drum = alu_flags[`SYNTH_ALU_FLAG_BIT_DRUM];

	wire [OSC_BITS-1:0] alt_osc_ext = alt_osc;

	//wire osc_cond0 = (osc_cond_bit == '1 ? 1 : osc[osc_cond_bit]);
	//wire osc_cond0 = osc[osc_cond_bit];
	wire osc_cond0a = osc[osc_cond_bit];
	wire osc_cond0b = alt_osc_ext[osc_cond_bit];
	wire osc_cond0 = use_alt_osc ? osc_cond0b : osc_cond0a;

	// not a register
	reg osc_cond;
	always_comb begin
		if (osc_cond_bit == '1) osc_cond = 1;
		else if (!drum) osc_cond = osc_cond0;
		else if (osc_cond_bit == 0) osc_cond = 0;
		else if (osc_cond_bit == `SYNTH_QUAD_X_BITS) osc_cond = 1;
		else if (osc_cond_bit >  `SYNTH_QUAD_X_BITS) osc_cond = 0;
		else if (osc_cond_bit >= ACC_BITS) osc_cond = osc_cond0;
		else osc_cond = p1;
	end

	wire cond_sign_acc = alu_flags[`SYNTH_ALU_FLAG_BIT_P_SIGN_ACC];
	wire cond_p0       = alu_flags[`SYNTH_ALU_FLAG_BIT_P0];
	wire cond_inv_p0   = alu_flags[`SYNTH_ALU_FLAG_BIT_INV_P0];
	wire cond_p1       = alu_flags[`SYNTH_ALU_FLAG_BIT_P1];
	wire cond_inv_p1   = alu_flags[`SYNTH_ALU_FLAG_BIT_INV_P1];
	wire cond = ((cond_sign_acc ? acc[ACC_BITS-1] : 1'b1) & (cond_p0 ? p0 ^ cond_inv_p0 : 1'b1) & (cond_p1 ? p1 ^ cond_inv_p1 : 1'b1)) | reset;

	//wire ignore_sign_acc = alu_flags[`SYNTH_ALU_FLAG_BIT_IGNORE_SIGN_ACC];

	//wire [ACC_BITS-1:0] acc_eff = {acc[ACC_BITS-1] & !ignore_sign_acc, acc[ACC_BITS-2:0]};
	wire [ACC_BITS-1:0] acc_eff = acc;

	// not registers
	reg [`SYNTH_TERM2_BITS-1:0] term2_sel_eff;
	reg signed [ACC_BITS-1:0] term1, term2_src;
	always_comb begin
		case (term1_sel)
			`SYNTH_TERM1_ZERO:       term1 = 0;
			//`SYNTH_TERM1_ONE:        term1 = 1 << (ACC_BITS - 1);
			//`SYNTH_TERM1_ALMOST_ONE: term1 = (1 << (ACC_BITS - 1)) - 1;
			`SYNTH_TERM1_LSB_MINUS_ONE: begin
				term1 = -1;
				if (double_osc_step) term1 = -2;
			end

			//`SYNTH_TERM1_OUT_ACC_INITIAL: term1 = OUT_ACC_INITIAL;

			`SYNTH_TERM1_OUT_ACC:    term1 = out_acc_reg;

			`SYNTH_TERM1_ACC:        term1 = acc_eff;
			`SYNTH_TERM1_ACC_ROR1:   term1 = {acc_eff[0], acc_eff[ACC_BITS-1:1]};
			`SYNTH_TERM1_ACC_SHR1:   term1 = {1'b0,   acc_eff[ACC_BITS-1:1]};
			`SYNTH_TERM1_ACC_SAR1:   term1 = {acc_eff[ACC_BITS-1], acc_eff[ACC_BITS-1:1]};

			`SYNTH_TERM1_ACC_PERM: begin
				term1 = 'X;
				// Created from `make_perm in alu-synth4.jl`.
				// Depends on prenoise code.
				if (ACC_BITS == 11) begin
					/*
					// 11 => ([8, 6, 14, 15, 7, 13, 5, 11, 12, 10, 9], vcat(11:15, 5:10)) # 5-15
					term1[ 0] = acc[ 8];
					term1[ 1] = acc[ 9];
					term1[ 2] = acc[10];
					term1[ 3] = acc[ 1];
					term1[ 4] = acc[ 0];
					term1[ 5] = acc[ 5];
					term1[ 6] = acc[ 2];
					term1[ 7] = acc[ 7];
					term1[ 8] = acc[ 4];
					term1[ 9] = acc[ 3];
					term1[10] = acc[ 6];
					*/
					// 11 => ([8, 6, 14, 15, 7, 13, 5, 4, 12, 1, 11], vcat(11:15, 1, 4:8)) # 1,4-8,11-15
					term1[ 0] = acc[10];
					term1[ 1] = acc[ 0];
					term1[ 2] = acc[ 5];
					term1[ 3] = acc[ 1];
					term1[ 4] = acc[ 6];
					term1[ 5] = acc[ 7];
					term1[ 6] = acc[ 2];
					term1[ 7] = acc[ 9];
					term1[ 8] = acc[ 4];
					term1[ 9] = acc[ 3];
					term1[10] = acc[ 8];
				end
				if (ACC_BITS == 10) begin
					term1[0] = acc[8];
					term1[1] = acc[0];
					term1[2] = acc[2];
					term1[3] = acc[9];
					term1[4] = acc[1];
					term1[5] = acc[3];
					term1[6] = acc[7];
					term1[7] = acc[5];
					term1[8] = acc[4];
					term1[9] = acc[6];
				end
			end
			default: term1 = 'X;
		endcase

		term2_sel_eff = osc_cond ? term2_sel : `SYNTH_TERM2_ZERO;
		case (term2_sel_eff)
			`SYNTH_TERM2_ZERO:       term2_src = 0;
			`SYNTH_TERM2_ALMOST_ONE: term2_src = (1 << (ACC_BITS - 1)) - 1;
			//`SYNTH_TERM2_OSC_LOW:    term2_src = osc[ACC_BITS-1:0];
			`SYNTH_TERM2_OSC_LOW:    term2_src = use_alt_osc ? alt_osc_ext[ACC_BITS-1:0] : osc[ACC_BITS-1:0];
			//`SYNTH_TERM2_OSC_HIGH:   term2_src = osc[OSC_BITS-1:ACC_BITS];
			`SYNTH_TERM2_OSC_HIGH:   begin
				term2_src = osc[OSC_BITS-1:ACC_BITS];
				if (drum) term2_src[ACC_BITS-1:`SYNTH_QUAD_X_BITS - ACC_BITS] = 1;
			end
			//`SYNTH_TERM2_LSB_ONE:    term2_src = 1;
			`SYNTH_TERM2_ACC:        term2_src = acc_eff;

			`SYNTH_TERM2_EXT0:       term2_src = ext0;
			`SYNTH_TERM2_EXT1:       term2_src = ext1;
			`SYNTH_TERM2_EXT2:       term2_src = ext2;
`ifdef USE_EXT3
			`SYNTH_TERM2_EXT3:       term2_src = ext3;
`endif

			default: term2_src = 'X;
		endcase
	end

	wire is_neg = acc[ACC_BITS-1];
	wire flip_if_neg = alu_flags[`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG];
	wire negate_term2_if_neg = alu_flags[`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG];

	wire inv_p_result = alu_flags[`SYNTH_ALU_FLAG_BIT_INV_P_RESULT];

	wire negate_term2 = alu_flags[`SYNTH_ALU_FLAG_BIT_NEG_TERM2] ^ (negate_term2_if_neg & is_neg);
	wire triangle_term2 = alu_flags[`SYNTH_ALU_FLAG_BIT_COMP_POS_TERM2];

	//wire signed [ACC_BITS-1:0] term2 = term2_src ^ (negate_term2 ? '1 : 0);// ^ {flip_sign_bit, {(ACC_BITS-1){1'b0}}};
	wire signed [ACC_BITS-1:0] term2 = term2_src ^ ((negate_term2 | (triangle_term2 & term2_src[ACC_BITS-1])) ? '1 : 0);// ^ {flip_sign_bit, {(ACC_BITS-1){1'b0}}};

	wire carry_in_p1 = alu_flags[`SYNTH_ALU_FLAG_BIT_CARRY_IN_P1];
	wire detunable = alu_flags[`SYNTH_ALU_FLAG_BIT_DETUNABLE];

	//wire carry_in = carry_in_p1 ? p1 : (detunable ? detune & osc_cond : negate_term2); // CONSIDER: can I shorten this logic path?
	// not a register
	reg carry_in;
	always_comb begin
		if (carry_in_p1) carry_in = p1;
		else if (drum) carry_in = osc[ACC_BITS-1] & osc_cond;
		else if (detunable) carry_in = detune & osc_cond;
		else carry_in = negate_term2;

		if (advance[0]) carry_in = 0;
	end

	// Sign/zero extend all terms by one bit
	wire sext = !alu_flags[`SYNTH_ALU_FLAG_BIT_ZEXT];
	wire [ACC_BITS+1-1:0] term1_ext = {sext & term1[ACC_BITS-1], term1};
	wire [ACC_BITS+1-1:0] term2_ext = {sext & term2[ACC_BITS-1], term2};

	//wire [ACC_BITS+1-1:0] sum = term1 + term2 + carry_in;
	wire [ACC_BITS+2-1:0] sum0 = {term1_ext, 1'b1} + {term2_ext, carry_in};
	wire [ACC_BITS+1-1:0] sum = sum0[ACC_BITS+2-1:1];

	wire [ACC_BITS+2**`SYNTH_ACC_BIT_BITS-1:0] acc_we0 = {{ACC_BITS{1'b0}}, {(2**`SYNTH_ACC_BIT_BITS){1'b1}}} << acc_we_nbits;
	wire [ACC_BITS-1:0] acc_we = acc_we0[ACC_BITS+2**`SYNTH_ACC_BIT_BITS-1 -: ACC_BITS];

	wire p_result_ov = alu_flags[`SYNTH_ALU_FLAG_BIT_P_RESULT_OV];
	wire p_result_carry = p_result_ov && !sext;
	wire p_result0 = (p_result_carry ? 0 : sum[ACC_BITS-1]) ^ (p_result_ov ? sum[ACC_BITS] : 0);

	//wire and_p_result_p0 = alu_flags[`SYNTH_ALU_FLAG_BIT_AND_P_RESULT_P0];
	//wire and_p_result_n_acc_sm1 = alu_flags[`SYNTH_ALU_FLAG_BIT_AND_P_RESULT_N_ACC_SM1];
	//wire p_result = p_result0 & (and_p_result_p0 ? p0 : 1'b1) & (and_p_result_n_acc_sm1 ? ~acc[ACC_BITS-2] : 1'b1);

	wire p_result = p_result0 ^ (flip_if_neg & is_neg) ^ inv_p_result;

	wire en_eff = en && cond;

	always @(posedge clk) begin
		if (reset && (advance == 0)) begin // TODO: async reset?
			osc <= ~(`DEMO_TIME_START << 10);
		end else if (en_eff) begin
			if (we[`SYNTH_WE_BIT_OSC_LOW]) osc[ACC_BITS-1:0] <= sum[ACC_BITS-1:0];
			if (OSC_BITS > 2*ACC_BITS) begin
				if (we[`SYNTH_WE_BIT_OSC_HIGH]) osc[ACC_BITS*2-1:ACC_BITS] <= sum[ACC_BITS-1:0];
				if (we[`SYNTH_WE_BIT_OSC2]) osc[OSC_BITS-1:2*ACC_BITS] <= osc[OSC_BITS-1:2*ACC_BITS] - 1 + sum[ACC_BITS]; // Hardcoded update
			end else begin
				if (we[`SYNTH_WE_BIT_OSC_HIGH]) osc[OSC_BITS-1:ACC_BITS] <= sum[OSC_BITS-ACC_BITS-1:0];
			end
		end

		if (reset) begin
			out_acc_reg <= 0;
		end else if (en_eff) begin
			if (we[`SYNTH_WE_BIT_OUT_ACC]) out_acc_reg <= sum[ACC_BITS-1:0];
		end

		if (en_eff) begin
			if (we[`SYNTH_WE_BIT_P0]) p0 <= p_result;
			//if (we[`SYNTH_WE_BIT_P1]) p1 <= p_result;
			if (we[`SYNTH_WE_BIT_ACC] && drum) p1 <= osc_cond0;
			else if (we[`SYNTH_WE_BIT_P1]) p1 <= p_result;
		end
	end

	generate
		for (i = 0; i < ACC_BITS; i++) begin
			always @(posedge clk) begin
				if (reset) begin
					acc[i] <= 0;
				end else if (en_eff) begin
					//if (we[`SYNTH_WE_BIT_ACC] && acc_we[i] && (i < ACC_BITS-1 || !ignore_sign_acc)) acc[i] <= sum[i];
					if (we[`SYNTH_WE_BIT_ACC] && acc_we[i]) acc[i] <= sum[i];
				end
			end
		end
	endgenerate

	assign osc_out = osc;
	assign acc_out = acc;
	assign out_acc = out_acc_reg;
	assign we_out = (en_eff && we[`SYNTH_WE_BIT_OUT]);
endmodule : pwl4_synth_ALU

	
module pwl4_scheduler #(parameter TIMER_BITS=6, OCT_BITS=3, ACC_BITS=10, OSC_BITS=18, ALT_OSC_BITS=9, OUT_ACC_BITS=10, DOUBLE_OSC_RATE=0, OUT_ACC_INITIAL=0) (
		input wire clk, reset, en,
		input wire [1:0] advance,

		input wire [TIMER_BITS-1:0] chan_timer,
		input wire signed [ACC_BITS-1:0] ext0, ext1, ext2, ext3,

		input wire new_sample,
		input wire [`SYNTH_WF_BITS-1:0] wf,
		input wire [OCT_BITS-1:0] oct,
		input wire [`SYNTH_N_SLANT_BITS-1:0] n_slant,
		input wire [`SYNTH_N_SAR_BITS-1:0] n_sar,
		input wire detune,

		input wire use_alt_osc,
		input wire [ALT_OSC_BITS-1:0] alt_osc,
		output wire channel_output_valid,

		output wire [OSC_BITS-1:0] osc,
		output wire [ACC_BITS-1:0] acc,
		output wire we_out,
		output wire [OUT_ACC_BITS-1:0] out_acc
	);

	localparam N_OSC_HIGH = `SYNTH_PRENOISE_MSB - (ACC_BITS-1);

	wire [OCT_BITS-1:0] n_shr = ~oct;

	wire [`SYNTH_ALU_FLAG_BITS-1:0] saw_flags = wf[`SYNTH_WF_BIT_SAW] ? 2**`SYNTH_ALU_FLAG_BIT_P1 : 0;
	wire do_prenoise = wf[`SYNTH_WF_BIT_PRENOISE];
	wire do_noise = wf[`SYNTH_WF_BIT_NOISE];
	wire bdrum = wf[`SYNTH_WF_BIT_BDRUM];

	wire new_sample_eff = new_sample || advance[1];

	// not registers
	reg [`SYNTH_TERM1_BITS-1:0] term1_sel;
	reg [`SYNTH_TERM2_BITS-1:0] term2_sel, factor_sel;
	reg [`SYNTH_ALU_FLAG_BITS-1:0] alu_flags, mul_flags;
	reg [`SYNTH_OSC_BIT_BITS-1:0] osc_cond_bit;
	reg [`SYNTH_ACC_BIT_BITS-1:0] acc_we_nbits;
	reg [`SYNTH_WE_BITS-1:0] we;
	reg double_osc_step;
	always_comb begin
		we = 0; term1_sel = 'X; term2_sel = 'X; alu_flags = 'X; osc_cond_bit = 'X; acc_we_nbits = 'X;
		double_osc_step = 0;

		factor_sel = `SYNTH_TERM2_EXT0;
		mul_flags = 0;
		mul_flags[`SYNTH_ALU_FLAG_BIT_DETUNABLE] = 1;
		if (bdrum) begin
			factor_sel = `SYNTH_TERM2_OSC_HIGH;
			mul_flags[`SYNTH_ALU_FLAG_BIT_DRUM] = 1;
		end

		if (new_sample_eff) begin
			case (reset ? {1'b0, advance[0]} : chan_timer[`LOG2_NEW_SAMPLE_CYCLES-1:0])
				/*
				// update osc_low, output current output_acc
				0: begin; we = 2**`SYNTH_WE_BIT_OSC_LOW | 2**`SYNTH_WE_BIT_OUT;	term1_sel = `SYNTH_TERM1_LSB_MINUS_ONE;	term2_sel = `SYNTH_TERM2_OSC_LOW;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
				// update osc_high. TODO: use carry
				1: begin; we = 2**`SYNTH_WE_BIT_OSC_HIGH;	term1_sel = `SYNTH_TERM1_LSB_MINUS_ONE;	term2_sel = `SYNTH_TERM2_OSC_HIGH;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
				*/
				// osc_low -= 1, save carry in p1
				0: begin; we = 2**`SYNTH_WE_BIT_OSC_LOW | 2**`SYNTH_WE_BIT_P1;	term1_sel = `SYNTH_TERM1_LSB_MINUS_ONE;	term2_sel = `SYNTH_TERM2_OSC_LOW;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_ZEXT | 2**`SYNTH_ALU_FLAG_BIT_P_RESULT_OV;	osc_cond_bit = -1;	acc_we_nbits = -1;
					double_osc_step = DOUBLE_OSC_RATE;
				end
				// osc_high += -1 + carry from p1, save carry in p1
				1: begin; we = 2**`SYNTH_WE_BIT_OSC_HIGH | 2**`SYNTH_WE_BIT_OSC2;	term1_sel = `SYNTH_TERM1_LSB_MINUS_ONE;	term2_sel = `SYNTH_TERM2_OSC_HIGH;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_ZEXT | 2**`SYNTH_ALU_FLAG_BIT_P_RESULT_OV | 2**`SYNTH_ALU_FLAG_BIT_CARRY_IN_P1;	osc_cond_bit = -1;	acc_we_nbits = -1; end
				//// out = out_acc, out_acc = OUT_ACC_INITIAL
				//2: begin; we = 2**`SYNTH_WE_BIT_OUT_ACC | 2**`SYNTH_WE_BIT_OUT;	term1_sel = `SYNTH_TERM1_OUT_ACC_INITIAL;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
				// out = out_acc, out_acc = 0, osc2 += -1 + carry from p1
				2: begin; we = 2**`SYNTH_WE_BIT_OUT_ACC | 2**`SYNTH_WE_BIT_OUT;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
				// 3: Cycle 2**LOG2_NEW_SAMPLE_CYCLES-1 will not be run
				default: begin; we = 0; term1_sel = 'X; term2_sel = 'X; alu_flags = 'X; osc_cond_bit = 'X; acc_we_nbits = 'X; end
			endcase
		end else if (do_prenoise) begin
			case (chan_timer)
				// 0:7 pre-noise
				0:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_OSC_LOW;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
				1, 2:	if (ACC_BITS==11) begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
				3, 4:	if (ACC_BITS==11) begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 0;	osc_cond_bit = -1;
					acc_we_nbits = N_OSC_HIGH+1;
				end
				5:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_ALMOST_ONE;	alu_flags = 0;	osc_cond_bit = -1;
					acc_we_nbits = N_OSC_HIGH;
				end
				6:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_OSC_HIGH;	alu_flags = 0;	osc_cond_bit = -1;
					acc_we_nbits = wf[`SYNTH_WF_BIT_PRENOISE_ALT] ? N_OSC_HIGH-1 : N_OSC_HIGH;
				end
				7:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_PERM;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
				8:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
				// flip msb
				//9:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ONE;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end

				// Like the normal program, but earlier, copied and adjusted
				/*
				// 12-13: amp_clamp
				12:	begin; we = 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT2;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG;	osc_cond_bit = -1;	acc_we_nbits = -1; end
				13:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_EXT2;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0 | 2**`SYNTH_ALU_FLAG_BIT_INV_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
				*/
				// 16-21: acc = sar(acc)
				16,17,18,19,20,21: begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SAR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
				// 22: out_acc += acc
				22: begin; we = use_alt_osc ? 0 : 2**`SYNTH_WE_BIT_OUT_ACC;	term1_sel = `SYNTH_TERM1_OUT_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end

				default: begin; we = 0; term1_sel = 'X; term2_sel = 'X; alu_flags = 'X; osc_cond_bit = 'X; acc_we_nbits = 'X; end
			endcase
			// Copied and adjusted from normal case
			if (chan_timer[TIMER_BITS-1:3]==(16>>3) && chan_timer[2:1] != '1) begin
				// Consider: Share comparator?
				if (chan_timer[2:0] >= n_sar) we = '0;
			end
		end else begin
			if (chan_timer[5] == 0) begin
				if (do_noise) begin
					if (chan_timer[4:1] == 6 >> 1) begin
						// 6-7: load osc
						if (chan_timer[0] == 0) begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_OSC_LOW;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
						if (chan_timer[0] == 1) begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = n_shr; end
					end
					if (chan_timer[4:3] == 8 >> 3) begin
						// 8-15: iterate
						if (chan_timer[0] == 0) begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_PERM;	term2_sel = `SYNTH_TERM2_OSC_HIGH;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
						if (chan_timer[0] == 1) begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
					end
				end else begin
					// factor * osc
					if (chan_timer[TIMER_BITS-1:3] == '0) begin
						// 0-7: shr part
						if (chan_timer[2:0] != '1) begin
							// 0-6: oct dependent shr
							// acc = (i == 0 ? 0 : (acc >> 1)) + (osc[i] ? ext : 0)
							we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = factor_sel;	alu_flags = mul_flags;	acc_we_nbits = -1;
							osc_cond_bit = chan_timer[2:0];
							if (chan_timer[2:0] == '0) term1_sel = `SYNTH_TERM1_ZERO;
							// If n_shr = 0, we skip the initial reset of acc, which gives wrong results. But that should be ok, that octave starts at almost 8 kHz.
							if (chan_timer[2:0] >= n_shr) we = '0;
						end else begin
							// 7: fixed shr
							// acc = shr(acc)
							we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1;
						end
					end else begin
						// 8-29: ror part
						if (chan_timer[0] == 0) begin
							// if (osc[i + n_shr]) acc += ext 	(acc_we_nbits = ACC_BITS-1-i)
							// ACC_BITS-1-i = ~chan_timer[4:1]
							// i = ACC_BITS-1 - ~chan_timer[4:1]
							// ACC_BITS-1-i = 15-chan_timer[4:1]
							// i = ACC_BITS-16 + chan_timer[4:1]
							we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;		term2_sel = factor_sel;	alu_flags = mul_flags;
							//osc_cond_bit = ACC_BITS-1 - ((~chan_timer)[4:1]) + n_shr; // TODO: simplify?

							//osc_cond_bit = (ACC_BITS-16) + chan_timer[4:1] + n_shr; // TODO: simplify?
							//acc_we_nbits = (~chan_timer[4:1])+1;

							osc_cond_bit = (ACC_BITS-16+1) + chan_timer[4:1] + n_shr; // TODO: simplify?
							acc_we_nbits = (~chan_timer[4:1]);
						end else begin
							// acc = ror(acc)
							we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1;
						end
			/*
						if (ACC_BITS == 11) begin
							if (chan_timer[4:1] == 4) we = '0; // special case
						end else if (ACC_BITS == 12) begin
							// special case: do nothing
						end else begin
							if (chan_timer[4:1] <= 15-ACC_BITS) we = '0;
						end*/
						if (ACC_BITS == 11) begin
						end else begin
							if (chan_timer[4:1] <= 15-1-ACC_BITS) we = '0;
						end
						//if (chan_timer[4:1] == '1) we = 0;
						if (chan_timer[4:1] == '1) begin
							// 30: p1 = (x < 0)
							// 31-33: triangle (just 31 here)
							case (chan_timer[0])
								// p1 = (x < 0)
								0: begin; we = 2**`SYNTH_WE_BIT_P1;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
								// tri
								//   if (x < 0); x = -x
								1: begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_LSB_MINUS_ONE;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_P_SIGN_ACC;	osc_cond_bit = -1;	acc_we_nbits = -1; end
								//    x = 2x - Nh + 1 # add 1 to avoid -Nh
								default: begin; we = 'X; term1_sel = 'X; term2_sel = 'X; alu_flags = 'X; osc_cond_bit = 'X; acc_we_nbits = 'X; end
							endcase
						end
					end
				end
			end else begin // chan_timer[5] == 1
				// waveform
				if (chan_timer[4] == 0) begin
					if (do_noise) begin
						we = 0; term1_sel = 'X; term2_sel = 'X; alu_flags = 'X; osc_cond_bit = 'X; acc_we_nbits = 'X;
					end else if (chan_timer[3:2]=='0) begin
						/*
						// 32: p1 = (x < 0)
						// 33-35: triangle
						case (chan_timer[1:0])
							// p1 = (x < 0)
							0: begin; we = 2**`SYNTH_WE_BIT_P1;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
							// tri
							//   if (x < 0); x = -x
							1: begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_LSB_MINUS_ONE;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_P_SIGN_ACC;	osc_cond_bit = -1;	acc_we_nbits = -1; end
							//    x = 2x - Nh + 1 # add 1 to avoid -Nh
							2: begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
							3: begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ALMOST_ONE;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2;	osc_cond_bit = -1;	acc_we_nbits = -1; end
							default: begin; we = 'X; term1_sel = 'X; term2_sel = 'X; alu_flags = 'X; osc_cond_bit = 'X; acc_we_nbits = 'X; end
						endcase
						*/
						// 31-33: triangle (just 32-33 here)
						case (chan_timer[1:0])
							// tri
							//    x = 2x - Nh + 1 # add 1 to avoid -Nh -- needed?
							0: begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
							1: begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ALMOST_ONE;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2;	osc_cond_bit = -1;	acc_we_nbits = -1; end
`ifdef USE_EXT3
							// add PWM offset, saturate
							2:	begin; we = 2**`SYNTH_WE_BIT_ACC | 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT3;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_P_RESULT_OV | 2**`SYNTH_ALU_FLAG_BIT_COMP_POS_TERM2;	osc_cond_bit = -1;	acc_we_nbits = -1; end
							3:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_ALMOST_ONE;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
							//default: begin; we = '0; term1_sel = 'X; term2_sel = 'X; alu_flags = 'X; osc_cond_bit = 'X; acc_we_nbits = 'X; end
							default: begin; we = 'X; term1_sel = 'X; term2_sel = 'X; alu_flags = 'X; osc_cond_bit = 'X; acc_we_nbits = 'X; end
`else
							default: begin; we = '0; term1_sel = 'X; term2_sel = 'X; alu_flags = 'X; osc_cond_bit = 'X; acc_we_nbits = 'X; end
`endif
						endcase
					end else begin
						// 36-47: clamp_2x
						case (chan_timer[0])
							0: begin; we = 2**`SYNTH_WE_BIT_ACC | 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | saw_flags;	osc_cond_bit = -1;	acc_we_nbits = -1; end
							1: begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_ALMOST_ONE;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0 | saw_flags;	osc_cond_bit = -1;	acc_we_nbits = -1; end
							default: begin; we = 'X; term1_sel = 'X; term2_sel = 'X; alu_flags = 'X; osc_cond_bit = 'X; acc_we_nbits = 'X; end
						endcase
						// TODO: Share the comparator with other uses?
						if (chan_timer[3:1] == '1) alu_flags[`SYNTH_ALU_FLAG_BIT_P1] = 0; // fixed clamp_2x
						else if (chan_timer[3:1] > n_slant) we = '0; // Don't need to clear WE_P0?
					end
				end else begin // chan_timer[4] == 1
					case (chan_timer[3:0])
						// 48-51: trans
						0: begin; we = do_noise ? 0 : 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT1;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_INV_P_RESULT | saw_flags;	osc_cond_bit = -1;	acc_we_nbits = -1; end
						1: begin; we = do_noise ? 0 : 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0 | saw_flags | 2**`SYNTH_ALU_FLAG_BIT_INV_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
						2: begin; we = do_noise ? 0 : 2**`SYNTH_WE_BIT_ACC | 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT1;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0 | saw_flags;	osc_cond_bit = -1;	acc_we_nbits = -1; end
						3: begin; we = do_noise ? 0 : 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_ALMOST_ONE;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0 | saw_flags;	osc_cond_bit = -1;	acc_we_nbits = -1; end
						/*
						// 52-53: aamp_sym
						4: begin; we = 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC_SAR1;	term2_sel = `SYNTH_TERM2_EXT2;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG;	osc_cond_bit = -1;	acc_we_nbits = -1; end
						5: begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SAR1;	term2_sel = `SYNTH_TERM2_EXT2;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0 | 2**`SYNTH_ALU_FLAG_BIT_INV_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
						*/
						// 52-53: amp_clamp
						4:	begin; we = 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT2;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG;	osc_cond_bit = -1;	acc_we_nbits = -1; end
						5:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_EXT2;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0 | 2**`SYNTH_ALU_FLAG_BIT_INV_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
						// 54-55: nop
						// CONSIDER: Better to express the repetition in another way?
						// 56-61: acc = sar(acc)
						8,9,10,11,12,13: begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SAR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
						// 62: out_acc += acc
						14: begin; we = use_alt_osc ? 0 : 2**`SYNTH_WE_BIT_OUT_ACC;	term1_sel = `SYNTH_TERM1_OUT_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
						// Cycle 63 should be a nop, waiting to set up next channel
						default: begin; we = 0; term1_sel = 'X; term2_sel = 'X; alu_flags = 'X; osc_cond_bit = 'X; acc_we_nbits = 'X; end
					endcase

					if (chan_timer[3]==1 && chan_timer[2:1] != '1) begin
						// Consider: Share comparator?
						if (chan_timer[2:0] >= n_sar) we = '0;
					end
				end
			end
		end
	end

	pwl4_synth_ALU #(.ACC_BITS(ACC_BITS), .OSC_BITS(OSC_BITS), .ALT_OSC_BITS(ALT_OSC_BITS), .OUT_ACC_BITS(OUT_ACC_BITS), .OUT_ACC_INITIAL(OUT_ACC_INITIAL)) alu (
		.clk(clk), .reset(reset), .en(en || reset), .advance(advance),
		.term1_sel(term1_sel), .term2_sel(term2_sel), .alu_flags(alu_flags), .osc_cond_bit(osc_cond_bit), .acc_we_nbits(acc_we_nbits), .we(we),
		.ext0(ext0), .ext1(ext1), .ext2(ext2), .ext3(ext3), .detune(detune),
		.use_alt_osc(use_alt_osc), .alt_osc(alt_osc),
		.double_osc_step(double_osc_step),
		.osc_out(osc), .acc_out(acc), .we_out(we_out), .out_acc(out_acc)
	);

	assign channel_output_valid = use_alt_osc && (chan_timer == 62);
endmodule : pwl4_scheduler
