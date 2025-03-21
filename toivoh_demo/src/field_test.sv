/*
 * Copyright (c) 2025 Toivo Henningsson
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

`include "pwl4_synth.vh"
`include "afl2_alu.vh"
`include "common.vh"


module raster_scan_c(
		input wire clk, reset,

		output wire signed [11:0] x,
		output wire signed [9:0] y,
		output wire active, hsync, vsync, new_line, new_frame, x_active, y_active
	);

	localparam X_BITS = 12;
	localparam BP_W = 48*2;
	localparam ACTIVE_W = 640*2;
	localparam FP_W = 16*2;
	localparam SYNC_W = 96*2;

	localparam BP_X0 = -BP_W - ACTIVE_W/2;
	localparam ACTIVE_X0 = BP_X0 + BP_W;
	localparam FP_X0 = ACTIVE_X0 + ACTIVE_W;
	localparam SYNC_X0 = FP_X0 + FP_W;
	localparam SYNC_X1 = SYNC_X0 + SYNC_W;


	localparam Y_BITS = 10;
	localparam ACTIVE_H = 480;
	localparam FP_H = 10;
	localparam SYNC_H = 2;
	localparam BP_H = 33;

	localparam ACTIVE_Y0 = 0 - ACTIVE_H/2;
	localparam FP_Y0 = ACTIVE_Y0 + ACTIVE_H;
	localparam SYNC_Y0 = FP_Y0 + FP_H;
	localparam BP_Y0 = SYNC_Y0 + SYNC_H;
	localparam BP_Y1 = BP_Y0 + BP_H;


	reg signed [X_BITS-1:0] x_reg;
	reg signed [Y_BITS-1:0] y_reg;

	assign new_line = (x_reg == SYNC_X1-1);
	assign new_frame = (y_reg == BP_Y1-1) && new_line;
	always @(posedge clk) begin
		if (reset || new_line) x_reg <= BP_X0;
		else x_reg <= x_reg + 1;

		if (reset || new_frame) y_reg <= ACTIVE_Y0;
		else y_reg <= y_reg + new_line;
	end

	assign x_active = (ACTIVE_X0 <= x_reg && x_reg < FP_X0);
	assign y_active = (y_reg < FP_Y0);

	assign active = x_active && y_active;
	// active low
	assign hsync  = !(SYNC_X0 <= x_reg && x_reg < SYNC_X1); 
	assign vsync  = !(SYNC_Y0 <= y_reg && y_reg < BP_Y0);

	assign x = x_reg;
	assign y = y_reg;
endmodule


module bitshuffle #(parameter IN_BITS=8, OUT_BITS=8, parameter PATTERN='h01234567) (
		input wire [IN_BITS-1:0] in,
		output wire [OUT_BITS-1:0] out
	);
	genvar i;
	wire [3:0] source_inds[OUT_BITS];
	generate
		for (i = 0; i < OUT_BITS; i++) begin
			assign source_inds[i] = (PATTERN>>(4*i))&15;
			assign out[i] = source_inds[i] >= IN_BITS ? 0 : in[source_inds[i]];
		end
	endgenerate
endmodule

module noise_source #(parameter STATE_BITS=6, X_BITS=12, NUM_ITER=2, PATTERN_X0=0, PATTERN_DX=0, PATTERN_STATE=0, PATTERN_SUM=0, SELECT_X0=0, SELECT_DX=0) (
		input wire clk, reset,

		input wire restart,
		//input wire [STATE_BITS-1:0] x0, dx,
		input wire [X_BITS-1:0] x,

		output wire done,
		output wire [STATE_BITS-1:0] noise
	);

	localparam NUM_ITER_BITS = $clog2(NUM_ITER);


	wire [STATE_BITS-1:0] x0, dx;
	bitshuffle #(.IN_BITS(X_BITS), .OUT_BITS(STATE_BITS), .PATTERN(SELECT_X0)) select_x0(.in(x), .out(x0));
	bitshuffle #(.IN_BITS(X_BITS), .OUT_BITS(STATE_BITS), .PATTERN(SELECT_DX)) select_dx(.in(x), .out(dx));


	reg [STATE_BITS-1:0] state;
	reg [NUM_ITER_BITS-1:0] num_iter;

	assign done = (num_iter == NUM_ITER-1);

	wire [STATE_BITS-1:0] x01, state1, dx1, sum2;
	bitshuffle #(.IN_BITS(STATE_BITS), .OUT_BITS(STATE_BITS), .PATTERN(PATTERN_X0)) shuffle_x0(.in(x0), .out(x01));
	bitshuffle #(.IN_BITS(STATE_BITS), .OUT_BITS(STATE_BITS), .PATTERN(PATTERN_DX)) shuffle_dx(.in(dx), .out(dx1));
	bitshuffle #(.IN_BITS(STATE_BITS), .OUT_BITS(STATE_BITS), .PATTERN(PATTERN_STATE)) shuffle_state(.in(state), .out(state1));

	wire [STATE_BITS-1:0] state_in1 = restart ? x01 : state1;
	wire [STATE_BITS-1:0] sum1 = state_in1 + dx1;

	bitshuffle #(.IN_BITS(STATE_BITS), .OUT_BITS(STATE_BITS), .PATTERN(PATTERN_SUM)) shuffle_sum(.in(sum1), .out(sum2));

	always @(posedge clk) begin
		if (restart) begin
			num_iter <= 0;
		end else begin
			num_iter <= num_iter + !done;
		end
		if (!done) state <= sum2;
	end
	assign noise = sum2;
endmodule


module field_table #(parameter X_BITS=5, CMP_BITS=7) (
		input wire signed [X_BITS-1:0] x,
		output reg [CMP_BITS-1:0] cmp // not a register
	);

	always_comb begin 
		case (x)
`include "field-table-generated.v"
			default: cmp = 'X;
		endcase
	end
endmodule


module field_test #(parameter COLOR_CHANNEL_BITS=4, HALF_FPS=0, OSC_BITS=`OSC_BITS) (
		input clk, reset,
		input wire [1:0] advance,

		output wire [COLOR_CHANNEL_BITS*3-1:0] rgb,
		output wire hsync, vsync, new_frame,

		output wire pwm_out
	);

	localparam X0_BITS = 12;
	localparam X_BITS = 10;
	localparam Y_BITS = 9;
	localparam VIS_Y_BITS = 9;

	genvar i;

	// Raster scan
	// ===========
	wire signed [X0_BITS-1:0] x0;
	wire signed [X_BITS-1:0] x = x0[X0_BITS-1:1];
	wire new_pixel = x0[0];
	wire signed [Y_BITS-1:0] y;
	wire active, x_active, y_active;
	wire new_line;
	//raster_scan_c rs(
	raster_scan rs(
		.clk(clk), .reset(reset), .en(1'b1),
		.x(x0), .y(y),
		.active(active), .hsync(hsync), .vsync(vsync), .new_frame(new_frame), .new_line(new_line),
		.x_active(x_active), .y_active(y_active)
	);

	// Control
	// =======
`ifdef USE_AFL
	reg [`DEMO_TIME_BITS-1:0] timer;
`else 
	wire [`DEMO_TIME_BITS-1:0] timer = rosc[OSC_BITS-1:10];
`endif

	wire [`DEMO_CONTROL_BITS-1:0] control;
	demo_control controller(.timer(timer), .control(control));


	// Field
	// =====
	wire [COLOR_CHANNEL_BITS-1:0] r, g, b;
	wire [OSC_BITS-1:0] rosc;

`ifdef USE_FIELD
	localparam FRAC_BITS = 2;
	localparam DELTA_BITS = FRAC_BITS;
	localparam FX_BITS = 9 + FRAC_BITS;
	localparam FY_BITS = 9 + FRAC_BITS;

	localparam TABLE_BUCKET_BITS = 5;

	localparam TABLE_OUT_BITS = 7;
	localparam CMP_BITS = 5;
	// TABLE_OUT_BITS = CMP_BITS + FRAC_BITS

	reg [FX_BITS-1:0] fx;
	reg [FY_BITS-1:0] fy;
	wire [DELTA_BITS-1:0] delta_fx, delta_fy, dx1, dx2, dy1, dy2;

	wire [10:0] field_timer = timer;

	wire [FX_BITS-1:0] fx0 = field_timer >> 1;
	wire [FX_BITS-1:0] fy0 = ~field_timer >> 2;

	wire [X_BITS-1:0] xy = new_line ? y : x;
	wire [FX_BITS-1:0] fxy = new_line ? fy : fx;

	wire [TABLE_OUT_BITS-1:0] table_out;
	field_table #(.X_BITS(X_BITS-TABLE_BUCKET_BITS), .CMP_BITS(TABLE_OUT_BITS)) ft(.x(xy[X_BITS-1:TABLE_BUCKET_BITS]), .cmp(table_out));

	wire [FRAC_BITS-1:0] delta;
	wire [CMP_BITS-1:0] cmp_val;
	assign {delta, cmp_val} = table_out;

	wire [CMP_BITS-1:0] cmp;
	generate
		for (i = 0; i < CMP_BITS; i++) assign cmp[i] = xy[CMP_BITS-1-i];
	endgenerate

	wire [FX_BITS-1:0] next_fxy = fxy + delta + (cmp_val >= cmp);

	always @(posedge clk) begin
`ifdef DEBUG_ON
		if (reset) begin
			fx <= -320;
			fy <= -240;
			//timer <= `DEMO_TIME_START;
		end else 
`endif
		begin
			if (new_line) fx <= fx0;
			else if (new_pixel && x_active) fx <= next_fxy;
			if (new_frame || reset) fy <= fy0;
			else if (new_line && y_active) fy <= next_fxy;
			//timer <= timer + new_frame;
		end
		if (reset || new_frame) timer <= rosc[OSC_BITS-1:10];
	end

	//assign {r, g, b} = x[5:0] ^ x[X_BITS-1:6] ^ y[5:0] ^ y[Y_BITS-1:6];
	//assign {r, g, b} = fx ^ fy;

	localparam N = 3;
	localparam M = 6;

/*
	//wire on = fx[FRAC_BITS+N -: N] == 0 && fy[FRAC_BITS+N -: N] == 0;
	wire [M-1:0] ix = fx[FRAC_BITS+M -: M];
	wire [M-1:0] iy = fy[FRAC_BITS+M -: M];
//	wire [M-1:0] ix = {ix0[M/2-1:0], iy0[M/2-1:0]};
//	wire [M-1:0] iy = {ix0[M-1:M/2], iy0[M-1:M/2]};
	wire [M-1:0] ix2 = {ix[5],  ix[4],  ix[0],  ix[2],  ix[3],  ix[1]} ^ 52;
	wire on = (ix2 == iy);
*/


	wire [6:0] ix = fx[9+FRAC_BITS-1:2+FRAC_BITS];
	wire [7:0] iy = fy[9+FRAC_BITS-1:1+FRAC_BITS];

	localparam STATE_BITS = 8;
	localparam NUM_ITER = 3; // TODO: increase
	localparam NOISE_CMP_BITS = 4;

	wire signed [X_BITS-1-3:0] x_shr = x[X_BITS-1:3];

	//wire noise_valid = fx[1+FRAC_BITS];
	wire noise_valid = fx[1+FRAC_BITS] && (x_shr != -40);
	//wire next_noise_valid = next_fxy[1+FRAC_BITS];

	//wire restart_noise = noise_valid & !next_noise_valid;
	wire restart_noise = (fx[1+FRAC_BITS:FRAC_BITS] == 0);
	wire [STATE_BITS-1:0] noise;

	noise_source #(.STATE_BITS(STATE_BITS), .X_BITS(15), .NUM_ITER(NUM_ITER),
//		.PATTERN_X0('h76543210), .PATTERN_DX('h76543210), .PATTERN_STATE('h76543210), .PATTERN_SUM('h76543210), .SELECT_X0('hf6543210), .SELECT_DX('hedcba987) // identity
		.PATTERN_X0('h76543210), .PATTERN_DX('h76543210), .PATTERN_STATE('h12376540), .PATTERN_SUM('h41357026), .SELECT_X0('hf65c3218), .SELECT_DX('h7ed4ba90) // big
//		.PATTERN_X0('h76543210), .PATTERN_DX('h76543210), .PATTERN_STATE('h17025463), .PATTERN_SUM('h50127346), .SELECT_X0('hf6d43298), .SELECT_DX('h7e5cba10) // smaller, some diagonal
	) nsource(
		.clk(clk), .reset(reset),
		.restart(restart_noise),
		.x({iy, ix}),
		.noise(noise)
	);

	//assign noise = {iy[1:0], ix[1:0]};

	wire on = noise_valid && (noise[NOISE_CMP_BITS-1:0] == '0);
	wire [1:0] light = noise >> NOISE_CMP_BITS;




	wire [1:0] px = fx[FRAC_BITS-1:0] ^ (fx[FRAC_BITS] ? 3 : 0);
	wire [1:0] py = fy[FRAC_BITS-1:0] ^ (fy[FRAC_BITS] ? 3 : 0);
	wire [1:0] p = on ? (px < py ? px : py) : 0;
	//wire [1:0] p0 = (px < py ? px : py);
	//wire [1:0] p1 = (p0 < light ? p0 : light);
	//wire [1:0] p1 = p0;
	//wire p = on ? p1 : '0;


	reg [1:0] p1; // not a register
	always_comb begin
		case (light)
			3: p1 = p;
			2: case(p)
				0: p1 = 0;
				1, 2: p1 = 1;
				3: p1 = 2;
			endcase
			1, 0: p1 = p[1];
			default: p1 = 0;
		endcase
	end

	wire [COLOR_CHANNEL_BITS-1:0] c = p1 << (COLOR_CHANNEL_BITS - 2);
	assign {r, g, b} = {c, c, c};
`else // USE_FIELD
	assign {r, g, b} = '0;
`endif

	wire logo_pixel;
`ifdef USE_LOGO
	wire [4:0] logo_x = (x >> 5) ^ 5'b10000;
	wire [3:0] logo_y = (y >> 5) ^ 4'b1000;
	wire logo_tri = x[4:0] < y[4:0];
	wire [9:0] logo_addr = {logo_x, logo_y, logo_tri};

	wire logo_pixel0;
	logo_table ltable(
		.addr(logo_addr),
		.data(logo_pixel0)
	);

	wire [1:0] logo_lines0 = control[`DEMO_CONTROL_BIT_LOGO_LINES1 -: 2];
	wire [1:0] logo_lines = logo_lines0 ^ (control[`DEMO_CONTROL_BIT_REV_LOGO_LINES] && logo_lines0[1] ? 2 : 0);

	wire [1:0] logo_line = logo_y[3:2];
	wire logo_blink = !timer[3];
	assign logo_pixel = logo_pixel0 && (control[`DEMO_CONTROL_BIT_LOGO_ON] && (logo_line <= logo_lines) && (logo_line != 3 || logo_blink));

	reg logo_prev_pixel;
	always_ff @(posedge clk) if (new_pixel) logo_prev_pixel <= logo_pixel;
`else
	assign logo_pixel = 0;
	wire logo_prev_pixel = 0;
`endif

	// Pixel combiner
	// ==============
	wire wave_visible;

`ifdef USE_AFL
	wire [`AFL_SECTION_BITS-1:0] afl_section, afl_section_mc;
	assign afl_section = control[`DEMO_CONTROL_BIT_AFL + `AFL_SECTION_BITS - 1 -: `AFL_SECTION_BITS];

	//wire [3:0] blocked;
	//wire bl_front;
	// not registers
	reg [2:0] blocked;
	reg bl_front, bl_behind_wave;

	//assign rgb = active ? {r, g, b} : '0;
	//assign rgb = active ? (blocked ? {2'd1, 2'd2, 2'd3} : {r, g, b}) : '0;
	//assign rgb = active ? ((|blocked) ? (blocked[1] ? {2'd2, 2'd3, 2'd3} : {2'd1, 2'd2, 2'd3}) : {r, g, b}) : '0;

	wire bl = (|blocked) && control[`DEMO_CONTROL_BIT_EFFECT];
	wire bl_top = blocked[1] && !(blocked[0] && bl_front == 0);
	/*
//	assign rgb = active ? (bl ? (bl_top ? {2'd2, 2'd3, 2'd3} : {2'd1, 2'd2, 2'd3}) : {r, g, b}) : '0;
	//assign rgb = active ? (bl ? (bl_top ? {2'd1, 2'd2, 2'd3} : {2'd0, 2'd1, 2'd2}) : {r, g, b}) : '0;
	//assign rgb = active ? (logo_pixel ? {2'd1, 2'd2, 2'd2} : (bl ? (bl_top ? {2'd1, 2'd2, 2'd3} : {2'd0, 2'd1, 2'd2}) : {r, g, b})) : '0;
	assign rgb = active ? (logo_pixel ? (logo_prev_pixel ? {2'd0, 2'd1, 2'd1} : {2'd1, 2'd3, 2'd2}) : (bl ? (bl_top ? {2'd1, 2'd2, 2'd3} : {2'd0, 2'd1, 2'd2}) : {r, g, b})) : '0;
	*/
	reg [5:0] rgb_out;
	always_comb begin
		rgb_out = {r, g, b};

		if (bl) begin
			rgb_out = bl_top ? {2'd1, 2'd2, 2'd3} : {2'd0, 2'd1, 2'd2};
		end

		if (control[`DEMO_CONTROL_BIT_WAVE_ON] && wave_visible && (!bl || bl_behind_wave)) begin
//			rgb_out = (afl_section == `AFL_SECTION_SPIRAL) ? {2'd2, 2'd3, 2'd3} : {2'd1, 2'd1, 2'd3};
			rgb_out = (afl_section == `AFL_SECTION_SPIRAL) ? {2'd2, 2'd3, 2'd3} : {2'd0, 2'd0, 2'd3};
		end

		if (logo_pixel) begin
			rgb_out = logo_prev_pixel ? {2'd0, 2'd1, 2'd1} : {2'd1, 2'd3, 2'd2};
		end

		if (!active) rgb_out ='0;
	end
	assign rgb = rgb_out;

`else
	assign rgb = active ? (wave_visible ? {2'd0, 2'd1, 2'd2} : {r, g, b}) : '0;
`endif


	// AFL
	// ===
`ifdef USE_AFL
	localparam E_BITS = 5;
	localparam M_BITS = 11;
	localparam SHIFT_BITS = 4+1;
	localparam M_MASK_BITS = 2;

	localparam REG_BITS = 1 + E_BITS + M_BITS;

	localparam NUM_AFL_REGS = 5;
	localparam NUM_SQRT_VALID = 3;

	localparam NUM_AFL_SOURCES = NUM_AFL_REGS + 1;
	localparam AFL_SOURCE_BITS = $clog2(NUM_AFL_SOURCES);

	localparam NUM_COMPS = NUM_AFL_REGS+1;
	localparam COMP_BITS = X_BITS;
	localparam COMP_SHR = 1;

	//localparam TIME0 = (-368*2) >>> 2;
	localparam TIME0 = (-480*2) >>> 2;

	wire [X0_BITS-2-1:0] debug_pc = (x0 >> 2) - TIME0;

	wire signed [Y_BITS-2:0] y_pos = timer >> 2;
	wire signed [X_BITS-2:0] x_pos = timer >> 1;

	reg [NUM_SQRT_VALID-1:0] sqrt_valid;


	localparam AFL_ARG_BITS = 5;
	//localparam AFL_ARG_reg0 = 0;
	localparam AFL_ARG_reg1 = 0;
	localparam AFL_ARG_reg2 = 1;
	localparam AFL_ARG_reg3 = 2;
	localparam AFL_ARG_reg4 = 3;
	localparam AFL_ARG_bias_y    = 4;
	//localparam AFL_ARG_bias_xpos = 5;
	//localparam AFL_ARG_bias_ypos = 6;
	//localparam AFL_ARG_r2         = 7;
	//localparam AFL_ARG_r2_el_outer = 8;
	//localparam AFL_ARG_r2_el_inner = 9;
	localparam AFL_ARG_circle_scale = 5;
	//localparam AFL_ARG_el_scale     = 11;
	//localparam AFL_ARG_bias_tr      = 12;
	localparam AFL_ARG_bias_trs     = 6;
	localparam AFL_ARG_bias         = 7;
	localparam AFL_ARG_one          = 8;
	//localparam AFL_ARG_m_one          = 15;
	localparam AFL_ARG_half           = 9;
	//localparam AFL_ARG_tr_cosign_scaled = 15;
	localparam AFL_ARG_trs_cosign_scaled= 10;
	//localparam AFL_ARG_trs_cosign_rescaled= 16;
	//localparam AFL_ARG_trss_cosign_rescaled=16;
	localparam AFL_ARG_trss_cosign_scaled2= 11;
	localparam AFL_ARG_trs_cosign_scaled3 = 12;
	localparam AFL_ARG_trs_cosign_scaled4 = 13;
	//localparam AFL_ARG_cosign_rescaled_half=20;
	localparam AFL_ARG_cosign_ss_rescaled_half=14;
	localparam AFL_ARG_rescale2           = 15;
	localparam AFL_ARG_sat_small_r2       = 16;
	//localparam AFL_ARG_sat_big_r2         = 23;
	localparam AFL_ARG_e_m2               = 17;
	//localparam AFL_ARG_y_sat1             = 25;
	//localparam AFL_ARG_y_sat2             = 26;
	localparam AFL_ARG_masked_bits        = 18;

	// not registers
	reg [`AFL_INST_BITS-1:0] inst, minst;
	reg dest_we;
	reg [AFL_SOURCE_BITS-1:0] dest_index; //, reg_index;
	reg both_args_same;
	reg both_args_source;
	reg afl_en;
	reg ext_s;
	reg signed [E_BITS-1:0] ext_e;
	reg signed [M_BITS-1:0] ext_val;
	reg ext_val_int;
	reg flip_acc, abs_result, flip_result;
	reg [NUM_SQRT_VALID-1:0] sqrt_valid_we;
	reg tr180;
	reg sflag_we, sflag2_we, masked_bits_we;
	reg signed [SHIFT_BITS-1:0] n_arg2_shr_ext;
	reg neg_arg2_ext;
	reg m_mask_sext, m_mask_sext2;
	reg sqrt_valid_use_sflag2;

	wire signed [X0_BITS-2-1:0] afl_pc, afl_pc_mc;
	wire [1:0] afl_sub_pc;
	assign {afl_pc, afl_sub_pc} = x0;

`ifdef USE_AFL_MC
	mc_buffer #(.BITS(`AFL_SECTION_BITS)) mc_buffer_afl_section(.clk(clk), .in(afl_section), .out(afl_section_mc));
	mc_buffer #(.BITS(X0_BITS-2)) mc_buffer_afl_pc(.clk(clk), .in(afl_pc), .out(afl_pc_mc));
`else
	assign afl_pc_mc = afl_pc;
	assign afl_section_mc = afl_section;
`endif


	reg [AFL_ARG_BITS-1:0] afl_arg;
	always_comb begin
		inst = `AFL_INST_NOP;
		//reg_index = NUM_AFL_REGS; // ext
		dest_we = 0;
		dest_index = 0;
		both_args_same = 0;
		both_args_source = 0;
		flip_acc = 0;
		abs_result = 0;
		flip_result = 0;
		afl_en = 1;
		tr180 = 0;
		sflag_we = 0;
		sflag2_we = 0;
		n_arg2_shr_ext = 0;
		neg_arg2_ext = 0;
		m_mask_sext = 0;
		m_mask_sext2 = 0;
		masked_bits_we = 0;
		sqrt_valid_use_sflag2 = 0;

/*
		ext_s = 0;
		ext_e = 0;
		ext_val_int = 1;
		ext_val = 0;
*/

		sqrt_valid_we = '0;

		afl_arg = 'X;

/*
		case (afl_pc)
//`include "generated-prog-rp.sv"
//`include "generated-prog-sat.sv"
//`include "generated-prog-spiral.sv"
`include "generated-prog-pillar.sv"
		endcase
*/
		case (afl_section_mc)
			`AFL_SECTION_PILLAR: case(afl_pc_mc)
`include "generated-prog-pillar.sv"
				//default: begin;  dest_index = 'X; both_args_same = 'X; both_args_source = 'X; flip_acc = 'X; abs_result = 'X; flip_result = 'X; tr180 = 'X; n_arg2_shr_ext = 'X; neg_arg2_ext = 'X; m_mask_sext = 'X; m_mask_sext2 = 'X; sqrt_valid_use_sflag2 = 'X;  end
			endcase
			`AFL_SECTION_SPIRAL: case(afl_pc_mc)
`include "generated-prog-spiral.sv"
				//default: begin;  dest_index = 'X; both_args_same = 'X; both_args_source = 'X; flip_acc = 'X; abs_result = 'X; flip_result = 'X; tr180 = 'X; n_arg2_shr_ext = 'X; neg_arg2_ext = 'X; m_mask_sext = 'X; m_mask_sext2 = 'X; sqrt_valid_use_sflag2 = 'X;  end
			endcase
/*
			`AFL_SECTION_RP: case(afl_pc_mc)
`include "generated-prog-rp.sv"
				//default: begin;  dest_index = 'X; both_args_same = 'X; both_args_source = 'X; flip_acc = 'X; abs_result = 'X; flip_result = 'X; tr180 = 'X; n_arg2_shr_ext = 'X; neg_arg2_ext = 'X; m_mask_sext = 'X; m_mask_sext2 = 'X; sqrt_valid_use_sflag2 = 'X;  end
			endcase
*/
			default: begin
				inst = 'X;
				// TODO: X for we:s also, if the default case can happen at least
				//dest_index = 'X; both_args_same = 'X; both_args_source = 'X; flip_acc = 'X; abs_result = 'X; flip_result = 'X; tr180 = 'X; n_arg2_shr_ext = 'X; neg_arg2_ext = 'X; m_mask_sext = 'X; m_mask_sext2 = 'X; sqrt_valid_use_sflag2 = 'X; 
			end
		endcase

		case ({inst, afl_sub_pc})
`ifdef USE_AFL_MC
			{`AFL_INST_ADD, 2'd1}: begin; minst = `AFL_INST_CMPABS; end
			{`AFL_INST_ADD, 2'd2}: begin; minst = `AFL_INST_ADD; end
			{`AFL_INST_ADD, 2'd3}: begin; minst = `AFL_INST_NORMALIZE; flip_acc = 0; flip_result = 0; end

			{`AFL_INST_ADDALL0, 2'd1}: begin; minst = `AFL_INST_ADDALL0; end
			{`AFL_INST_ADDALL0, 2'd2}: minst = `AFL_INST_ADDALL1;

			{`AFL_INST_LOAD, 2'd1}: minst = `AFL_INST_LOAD;
			{`AFL_INST_SQRT, 2'd1}: minst = `AFL_INST_SQRT;

			{`AFL_INST_ADDINT, 2'd1}: minst = `AFL_INST_ADDINT;
`else
			{`AFL_INST_ADD, 2'd0}: begin; minst = `AFL_INST_CMPABS; end
			{`AFL_INST_ADD, 2'd1}: begin; minst = `AFL_INST_ADD; end
			{`AFL_INST_ADD, 2'd2}: begin; minst = `AFL_INST_NORMALIZE; flip_acc = 0; flip_result = 0; end

			{`AFL_INST_ADDALL0, 2'd0}: begin; minst = `AFL_INST_ADDALL0; end
			{`AFL_INST_ADDALL0, 2'd1}: minst = `AFL_INST_ADDALL1;

			{`AFL_INST_LOAD, 2'd0}: minst = `AFL_INST_LOAD;
			{`AFL_INST_SQRT, 2'd0}: minst = `AFL_INST_SQRT;

			{`AFL_INST_ADDINT, 2'd0}: minst = `AFL_INST_ADDINT;
`endif

			default: begin
				afl_en = 0;
				minst = 'X;
			end
			//default: minst = `AFL_INST_NOP;
		endcase
`ifdef USE_AFL_MC
		if (afl_sub_pc != 1) dest_we = 0;
`else
		if (afl_sub_pc != 0) dest_we = 0;
`endif

		//afl_en = (minst != `AFL_INST_NOP);
	end

	(* mem2reg *) reg [REG_BITS-1:0] regs[NUM_AFL_REGS];
	reg sflag, sflag2;
	reg [M_MASK_BITS-1:0] masked_bits;


	wire [M_BITS+1-1:0] time_rot0 = timer << (M_BITS - 6);
	//wire [1:0] time_rot_offs;
	//wire [M_BITS+1-1:0] time_rot = time_rot0 + (time_rot_offs << (M_BITS-1));

	wire [M_BITS+1-1:0] time_rot = time_rot0;
	//wire [M_BITS+1-1:0] time_rot = (1 << 10); // !!!

	//assign time_rot_offs[0] = y[Y_BITS-1];
	//assign time_rot_offs[1] = tr180;

	always_comb begin
		ext_s = 0;
		ext_e = 0;
		ext_val_int = 1;
		ext_val = 0;
		case (afl_arg)
			//AFL_ARG_reg0: begin; ext_val_int = 0; {ext_s, ext_e, ext_val} = regs[0]; end
			AFL_ARG_reg1: begin; ext_val_int = 0; {ext_s, ext_e, ext_val} = regs[1]; end
			AFL_ARG_reg2: begin; ext_val_int = 0; {ext_s, ext_e, ext_val} = regs[2]; end
			AFL_ARG_reg3: begin; ext_val_int = 0; {ext_s, ext_e, ext_val} = regs[3]; end
			AFL_ARG_reg4: begin; ext_val_int = 0; {ext_s, ext_e, ext_val} = regs[4]; end

			AFL_ARG_bias_y: ext_val = {y, {(M_BITS - VIS_Y_BITS){1'b0}}};
			//AFL_ARG_bias_y: ext_val = 0;
			//AFL_ARG_bias_y: ext_val = {{VIS_Y_BITS{y[0]}}, {(M_BITS - VIS_Y_BITS){1'b0}}};

			//AFL_ARG_bias_xpos: ext_val = x_pos;
			//AFL_ARG_bias_ypos: ext_val = y_pos;

			AFL_ARG_masked_bits: begin; ext_val_int = 0; ext_val = {~masked_bits, {(M_BITS-M_MASK_BITS){1'b0}}}; end
//			AFL_ARG_masked_bits: begin; ext_val_int = 0; ext_val = {~masked_bits, {(M_BITS-M_MASK_BITS){1'b0}}} ^ {masked_bits[0], {(M_BITS-1){1'b0}}}; end

			//AFL_ARG_y_sat1:       begin; ext_val_int = 0; ext_e = -2; ext_val = 0; end
			//AFL_ARG_y_sat2:       begin; ext_val_int = 0; ext_e = -3; ext_val = 0; end
			//AFL_ARG_r2:          begin; ext_val_int = 0; ext_e = -3; ext_val = 0; end
			//AFL_ARG_r2_el_outer: begin; ext_val_int = 0; ext_e = -5; ext_val = 0; end
			//AFL_ARG_r2_el_inner: begin; ext_val_int = 0; ext_e = -6; ext_val = 0; end
			AFL_ARG_circle_scale:begin; ext_val_int = 0; ext_e = -1; ext_val = 0; end
			//AFL_ARG_el_scale:    begin; ext_val_int = 0; ext_e =  1; ext_val = 0; end

			//AFL_ARG_bias_tr:     begin; ext_val_int = 0; ext_val = time_rot[M_BITS-1:0]; end
			AFL_ARG_bias_trs:    begin; ext_val_int = 0; ext_val = time_rot[M_BITS-1:0]; ext_s = time_rot[M_BITS]; end
			AFL_ARG_bias:        ext_val = 0;
			AFL_ARG_one:         begin; ext_val_int = 0; ext_val = 0; end
//			AFL_ARG_m_one:         begin; ext_val_int = 0; ext_val = 0; ext_s = 1; end
			AFL_ARG_half:        begin; ext_val_int = 0; ext_val = 0; ext_e = -1; end
			AFL_ARG_e_m2:        begin; ext_val_int = 0; ext_val = 0; ext_e = -2; end
			//AFL_ARG_tr_cosign_scaled: begin; ext_val_int = 0; ext_val = 0; ext_s = time_rot[M_BITS]; ext_e = -1; end
			AFL_ARG_trs_cosign_scaled: begin; ext_val_int = 0; ext_val = 0; ext_s = sflag; ext_e = -1; end
			//AFL_ARG_trs_cosign_rescaled: begin; ext_val_int = 0; ext_val = 0; ext_s = sflag; ext_e = 2; end
			//AFL_ARG_trss_cosign_rescaled: begin; ext_val_int = 0; ext_val = 0; ext_s = sflag ^ sflag2; ext_e = 2; end

			//AFL_ARG_trss_cosign_scaled2: begin; ext_val_int = 0; ext_val = 0; ext_s = sflag ^ sflag2; ext_e = 2-8; end
			//AFL_ARG_rescale2: begin; ext_val_int = 0; ext_val = 0; ext_s = 0; ext_e = 8; end
			AFL_ARG_trss_cosign_scaled2: begin; ext_val_int = 0; ext_val = 0; ext_s = sflag;  ext_e = 2-9; end
			AFL_ARG_rescale2:            begin; ext_val_int = 0; ext_val = 0; ext_s = !sflag2; ext_e = 9; end

			AFL_ARG_trs_cosign_scaled3: begin; ext_val_int = 0; ext_val = 0; ext_s = sflag; ext_e = -1; end
			AFL_ARG_trs_cosign_scaled4: begin; ext_val_int = 0; ext_val = 0; ext_s = sflag; ext_e = 0; end
			//AFL_ARG_cosign_rescaled_half: begin; ext_val_int = 0; ext_val = 0; ext_s = sflag; ext_e = 1; end
			AFL_ARG_cosign_ss_rescaled_half: begin; ext_val_int = 0; ext_val = 0; ext_s = sflag ^ sflag2; ext_e = 1; end

			AFL_ARG_sat_small_r2: begin; ext_val_int = 0; ext_e = -7; ext_val = 0; end
			//AFL_ARG_sat_big_r2: begin; ext_val_int = 0; ext_e = -6; ext_val = 0; end

			default: begin; ext_s = 'X; ext_e = 'X; ext_val_int = 'X; ext_val = 'X; end
		endcase
	end



	wire [M_BITS-1:0] ext_m = {ext_val[M_BITS-1] ^ ext_val_int, ext_val[M_BITS-2:0]};
	wire [1+E_BITS+M_BITS-1:0] afl_ext;
	assign afl_ext = {ext_s, ext_e, ext_m};

/*
	wire [REG_BITS-1:0] sources[NUM_AFL_SOURCES];
	generate
		for (i = 0; i < NUM_AFL_REGS; i++) assign sources[i] = regs[i];
	endgenerate
	assign sources[NUM_AFL_REGS] = afl_ext;
	wire [REG_BITS-1:0] ext = sources[reg_index];
	*/
	wire [REG_BITS-1:0] ext = afl_ext;

	wire [1+E_BITS+M_BITS-1:0] acc;
	wire int_msb_out;
	wire [M_BITS-1:0] m_result0;
	afl2_alu #(.E_BITS(E_BITS), .M_BITS(M_BITS), .M_MASK_BITS(M_MASK_BITS)) afl_alu(
		.clk(clk), .reset(reset), .en(afl_en),
		.inst(minst), .ext(ext), .n_arg2_shr_ext(n_arg2_shr_ext),
		.both_args_same(both_args_same), .both_args_source(both_args_source), .flip_acc(flip_acc), .abs_result(abs_result), .flip_result(flip_result),
		.m_mask_sext(m_mask_sext), .m_mask_sext2(m_mask_sext2), .neg_arg2_ext(neg_arg2_ext),
		.acc_out(acc), .int_msb_out(int_msb_out), .m_result0(m_result0)
	);

	wire en = 1;

	//wire sflag2_source = int_msb_out;
	wire sflag2_source = int_msb_out ^ m_result0[M_BITS-1];
	//wire sflag2_source = 0;
	always @(posedge clk) if (en) begin
		if (sflag_we && afl_en) sflag <= int_msb_out;
		if (sflag2_we && afl_en) sflag2 <= sflag2_source;
		//if (masked_bits_we && afl_en) masked_bits <= m_result0[M_BITS-1 -: M_MASK_BITS];
		if (masked_bits_we && afl_en) masked_bits <= (m_result0[M_BITS-1 -: (M_MASK_BITS+1)] + 1) >>1;
	end

	generate
		for (i = 0; i < NUM_AFL_REGS; i++) begin
			always @(posedge clk) if (en) begin
				// Don't apply flip_acc
				if (dest_we && dest_index == i) regs[i] <= acc;
			end
		end
	endgenerate

	wire sqrt_valid_source = sqrt_valid_use_sflag2 ? sflag2_source : (acc[E_BITS+M_BITS] == 0);
	//wire sqrt_valid_source = 0;
	generate
		for (i = 0; i < NUM_SQRT_VALID; i++) begin
			always @(posedge clk) begin
				//if (sqrt_valid_we[i] && (afl_en || !sqrt_valid_use_sflag2)) sqrt_valid[i] <= sqrt_valid_source;
				if (sqrt_valid_we[i] && afl_en) sqrt_valid[i] <= sqrt_valid_source;
			end
		end
	endgenerate


//	wire [COMP_BITS-1:0] comp_values[NUM_COMPS];
	wire [M_BITS-1:0] comp_values0[NUM_COMPS];
	wire signed [COMP_BITS-1:0] comp_values[NUM_COMPS];
	wire [NUM_COMPS-1:0] comps;
	//wire [COMP_BITS-1:0] comp_x = {~x[X_BITS-1], x[X_BITS-2:0]};
	wire signed [COMP_BITS-1:0] comp_x = x;
	assign comp_values0[NUM_COMPS-1] = acc[M_BITS-1:0];
	generate
		for (i = 0; i < NUM_COMPS-1; i++) assign comp_values0[i] = regs[i][M_BITS-1:0];
		for (i = 0; i < NUM_COMPS;   i++) begin
			//assign comp_values[i] = {~comp_values0[i][M_BITS-1], comp_values0[i][M_BITS-2:COMP_SHR]};
			assign comp_values[i] = {{(1+COMP_BITS-(M_BITS-COMP_SHR)){~comp_values0[i][M_BITS-1]}}, comp_values0[i][M_BITS-2:COMP_SHR]};
			assign comps[i] = (comp_x >= comp_values[i]);
		end
	endgenerate

/*
	// TODO: sign extend properly into acc_x (needed?)
	//wire signed [X_BITS-1:0] acc_x = {~acc[M_BITS-1], acc[M_BITS-2:0]} << (VIS_Y_BITS - M_BITS);
	wire signed [X_BITS-1:0] acc_x = {~acc[M_BITS-1], acc[M_BITS-2:0]} >> (M_BITS - VIS_Y_BITS);
	wire acc_x_valid = sqrt_valid; // acc[M_BITS-1];
	//wire signed [E_BITS-1:0] afl_e = acc[E_BITS+M_BITS-1 -: E_BITS];
	//wire acc_x_valid = (afl_e == '0);
	assign blocked = acc_x_valid && !x[X_BITS-1] && (x <= acc_x);
	assign bl_front = y[Y_BITS-1];
	*/

	//assign blocked = sqrt_valid && !comps[1];
	//assign blocked = sqrt_valid && comps[0];

	/*
	//rp
	assign blocked[0] = sqrt_valid[0]  && comps[0] && !comps[1];
	//assign blocked[1] = sqrt_valid[1] && comps[2] && !comps[3];
	assign blocked[1] = (sqrt_valid[1] && comps[2] && !comps[3]) && !(sqrt_valid[2] && comps[4] && !comps[5]);
	assign blocked[2] = 0;
	*/

/*
	// sat
	assign blocked[0] = sqrt_valid[0]  && comps[0] && !comps[1];
	//assign blocked[1] = 0;
	assign blocked[1] = sqrt_valid[1]  && comps[2] && !comps[3];
	//assign bl_front = time_rot0[M_BITS];
	assign bl_front = time_rot[M_BITS] ^ time_rot[M_BITS-1];
	assign blocked[2] = sqrt_valid[2]  && comps[4] && !comps[5];
*/

	// pillar
	localparam REG_PILLAR_ml = NUM_AFL_REGS-4; // reg_light_angle = reg_l = num_regs-4
	localparam REG_PILLAR_mr = NUM_AFL_REGS-3; // reg_twist_phase = reg_r = num_regs-3
	localparam REG_PILLAR_m = NUM_AFL_REGS-2; // reg_twist_scale = reg_mid = num_regs-2
	localparam REG_PILLAR_l = NUM_AFL_REGS-1; // reg_side = num_regs-1
	localparam REG_PILLAR_r = 0; // reg_xr = 0

	wire lside = sqrt_valid[0];
	wire rside = sqrt_valid[1];
	wire l_highlight = lside ? comps[REG_PILLAR_l] && !comps[REG_PILLAR_ml] : comps[REG_PILLAR_ml] && !comps[REG_PILLAR_m];
	wire r_highlight = rside ? comps[REG_PILLAR_m] && !comps[REG_PILLAR_mr] : comps[REG_PILLAR_mr] && !comps[REG_PILLAR_r];
	//wire l_highlight = lside ?                        !comps[REG_PILLAR_ml] : comps[REG_PILLAR_ml] && !comps[REG_PILLAR_m];
	//wire r_highlight = rside ? comps[REG_PILLAR_m] && !comps[REG_PILLAR_mr] : comps[REG_PILLAR_mr];

	always_comb begin
		blocked = 'X;
		bl_front = 'X;
		bl_behind_wave = 0;

		case (afl_section)
			/*
			`AFL_SECTION_RP: begin
				blocked[0] = sqrt_valid[0]  && comps[0] && !comps[1];
				//blocked[1] = sqrt_valid[1] && comps[2] && !comps[3];
				blocked[1] = (sqrt_valid[1] && comps[2] && !comps[3]) && !(sqrt_valid[2] && comps[4] && !comps[5]);
				blocked[2] = 0;
				bl_front = y[Y_BITS-1];
			end
			*/
			`AFL_SECTION_SPIRAL: begin
				blocked[0] = sqrt_valid[0] && comps[0] && !comps[1];
				//blocked[1] = sqrt_valid[0] && comps[2] && !comps[3];
				//blocked[1] = sqrt_valid[0] && comps[0] && !comps[2];
				//blocked[1] = sqrt_valid[0] && (sflag2 ? comps[2] && !comps[1] : comps[0] && !comps[2]);
				blocked[1] = sqrt_valid[0] && (!sflag2 ? comps[2] && !comps[1] : comps[0] && !comps[2]);
				blocked[2] = 0;
				bl_front = 1;
				bl_behind_wave = ((sqrt_valid[1]==0) && wave_visible);
			end
			`AFL_SECTION_PILLAR: begin
				blocked[0] = comps[REG_PILLAR_l] && !comps[REG_PILLAR_r];
				blocked[1] = l_highlight | r_highlight;
				//blocked[1] = 0;
				//blocked[0] = comps[REG_PILLAR_l] && !comps[REG_PILLAR_m]; blocked[1] = comps[REG_PILLAR_m] && !comps[REG_PILLAR_r];
				blocked[2] = 0;
				bl_front = 1;
			end
			default: begin
				blocked = 'X;
				bl_front = 'X;
			end
		endcase
		//blocked[3] = wave_visible;
	end

	// debug
	wire [REG_BITS-1:0] reg0 = regs[0];
	wire [REG_BITS-1:0] reg1 = regs[1];
	wire [REG_BITS-1:0] reg2 = regs[2];
	wire [REG_BITS-1:0] reg3 = regs[3];
	wire [REG_BITS-1:0] reg4 = regs[4];
	wire [M_BITS-1:0] comp_value0_0 = comp_values0[0];
	wire [M_BITS-1:0] comp_value0_1 = comp_values0[1];
	wire [COMP_BITS-1:0] comp_value0 = comp_values[0];
	wire [COMP_BITS-1:0] comp_value1 = comp_values[1];
`endif

	// Player
	// ======
	localparam CHANNEL_BITS = 4;
	localparam ACC_BITS = 11;
	localparam ALT_OSC_BITS = 9;

	localparam WAVE_BITS = 8;


	wire right_side = !x[X_BITS-1];

	wire signed [X_BITS-4-1:0] x_shr4 = x >>> 4;
	wire signed [X_BITS-4-1:0] x_shr4_cmp = -400 >>> 4;
	wire x_shr4_small = x_shr4 < x_shr4_cmp;
	wire right_side_alt = !(right_side || x_shr4_small);
	//wire right_side_alt = rosc[HALF_FPS];

	wire bottom_half = !y[Y_BITS-1];


	//wire [CHANNEL_BITS-1:0] alt_channel = 8;
	//wire [CHANNEL_BITS-1:0] alt_channel = right_side_alt ? 8 : 9;
	//wire [CHANNEL_BITS-1:0] alt_channel = single_waveform ? 8 : {bottom_half, right_side_alt, 1'b0};

	//wire single_waveform = timer[4];
	//wire single_waveform = 1;

	wire [`WAVE_MODE_BITS-1:0] wave_mode = control[`DEMO_CONTROL_BIT_WAVE_MODE + `WAVE_MODE_BITS - 1 -: `WAVE_MODE_BITS];

	// not registers
	reg single_waveform;
	reg [CHANNEL_BITS-1:0] alt_channel;
	always_comb begin
		single_waveform = 0;
		alt_channel = 'X;
		case (wave_mode)
			`WAVE_MODE_PRENOISE: begin
				single_waveform = 1;
				alt_channel = 8;
			end
			`WAVE_MODE_BASS: begin
				single_waveform = 1;
				alt_channel = 0;
			end
			`WAVE_MODE_DRUMS: begin
				alt_channel = right_side_alt ? 9 : 10;
			end
			`WAVE_MODE_ARP: begin
				alt_channel = {bottom_half, right_side_alt, 1'b0};
			end
		endcase
		//if (afl_section == `AFL_SECTION_SPIRAL) single_waveform = 1;
	end


	wire signed [X_BITS-1:0] x_cmp_offs = single_waveform ? 0 : (right_side ? -128 : 128);



	wire [CHANNEL_BITS-1:0] channel;
	wire use_alt_osc = (channel == 11);
	wire signed [ACC_BITS-1:0] channel_output;
	wire channel_output_valid, chan_en;

	wire [ALT_OSC_BITS-1:0] alt_osc = y << (ALT_OSC_BITS - (Y_BITS-1));
	//wire [ALT_OSC_BITS-1:0] alt_osc = (y << (ALT_OSC_BITS - (Y_BITS-1))) ^ (1 << (ALT_OSC_BITS-1));

	pwl4_player #(.ALT_OSC_BITS(ALT_OSC_BITS), .DOUBLE_OSC_RATE(HALF_FPS)) player(
		.clk(clk), .reset(reset), .en(1), .advance(advance),
		.channel_out(channel),
		.use_alt_osc(use_alt_osc), .alt_channel(alt_channel), .alt_osc(alt_osc),
		.alt_n_sar(0),
		.pwm_out(pwm_out), .acc(channel_output), .channel_output_valid(channel_output_valid), .chan_en_out(chan_en),
		.rosc_out(rosc)
	);

	//reg signed [WAVE_BITS-1:0] wave, last_wave;
	reg signed [WAVE_BITS-1:0] wave, prev_wave, last_wave;

	always_ff @(posedge clk) begin
//		if (channel_output_valid) begin
/*
		if (channel_output_valid && !x0[9]) begin
			last_wave <= wave;
			wave <= (chan_en ? channel_output[ACC_BITS-1 -: WAVE_BITS] : 0);
		end
*/
		if (channel_output_valid) begin
			last_wave <= prev_wave;
			prev_wave <= wave;
			wave <= (chan_en ? channel_output[ACC_BITS-1 -: WAVE_BITS] : 0);
		end
	end

	wire signed [X_BITS-1:0] x_cmp = x + x_cmp_offs;

	wire gt_wave =      (x_cmp >= wave);
	wire gt_last_wave = (x_cmp >= last_wave);
	wire eq_wave =      (x_cmp == wave);

	assign wave_visible = eq_wave || (gt_wave != gt_last_wave);
endmodule

