/*
 * Copyright (c) 2025 Toivo Henningsson
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

`include "../src/afl2_alu.vh"

// assumes 9 <= BITS <= 16
module rotate_right #(parameter BITS=9) (
		input wire [BITS-1:0] in,
		input wire [3:0] n_ror,

		output wire [BITS-1:0] out
	);
	wire [BITS-1:0] x0 = in;

	wire [BITS-1:0] x1 = n_ror[0] ? {x0[1-1:0], x0[BITS-1:1]} : x0;
	wire [BITS-1:0] x2 = n_ror[1] ? {x1[2-1:0], x1[BITS-1:2]} : x1;
	wire [BITS-1:0] x3 = n_ror[2] ? {x2[4-1:0], x2[BITS-1:4]} : x2;
	wire [BITS-1:0] x4 = n_ror[3] ? {x3[8-1:0], x3[BITS-1:8]} : x3;

	assign out = x4;
endmodule

// assumes 9 <= BITS <= 16
module shifter #(parameter BITS=9) (
		input wire [BITS-1:0] in,
		input wire signed [4:0] n_shr,

		output wire [BITS-1:0] out
	);

	localparam MAX_BITS = 16;

	wire do_shl = n_shr[4];
	wire [3:0] n_ror = n_shr[3:0] - (do_shl ? (MAX_BITS - BITS) : 0);
	wire [BITS-1:0] mask0 = '1;
	wire [BITS-1:0] mask = (mask0 >> n_ror) ^ (do_shl ? '1 : '0);

	wire [BITS-1:0] rotated;
	rotate_right #(.BITS(BITS)) ror(
		.in(in), .n_ror(n_ror),
		.out(rotated)
	);

	assign out = rotated & mask;
endmodule

module priority_encoder #(parameter BITS=8) (
		input wire [BITS-1:0] bits,
		output wire signed [$clog2(BITS+1)+1-1:0] n_shr, // will always be < 0
		output wire underflow
	);
	localparam POS_BITS = $clog2(BITS+1);

	// not registers
	int i;
	reg signed [POS_BITS+1-1:0] pos;
	reg under;
	always_comb begin
		pos = 'X;
		under = 1;
		for (i = 0; i < BITS; i++) if (bits[i]) begin
			under = 0;
			pos = i-BITS;
		end
	end
	assign n_shr = pos;
	assign underflow = under;
endmodule


module afl2_alu #(parameter E_BITS=4, M_BITS=8, SHIFT_BITS=4+1, M_MASK_BITS=2) (
		input wire clk, reset, en,

		input wire [`AFL_INST_BITS-1:0] inst,
		// If both_args_same is high, use both_args_source to decide if both args are acc or source
		input wire both_args_same, both_args_source,
		input wire flip_acc, // flip the value of acc going into the calculation
		input wire abs_result,
		input wire flip_result,

		input wire [1+E_BITS+M_BITS-1:0] ext,
		input wire signed [SHIFT_BITS-1:0] n_arg2_shr_ext,
		input wire neg_arg2_ext,
		input wire m_mask_sext, m_mask_sext2,

		output wire [1+E_BITS+M_BITS-1:0] acc_out,
		output wire int_msb_out,
		output wire [M_BITS-1:0] m_result0
	);

	localparam REG_BITS = 1 + E_BITS + M_BITS;
	localparam R_BITS = M_BITS + 1;
	//localparam SHIFT_BITS = 4+1;

	genvar i;

	wire s1, s2, s_acc, s_reg;
	wire signed [E_BITS-1:0] e1_0, e2, e_reg;
	wire signed [E_BITS+1-1:0] e1, e1_0_ext;
	wire [R_BITS-1:0] r1_0, r1, r2;
	wire signed [SHIFT_BITS-1:0] prio_enc_out;
	wire prio_enc_underflow;

	wire [E_BITS+1-1:0] e_sum;

	// State
	// =====
	reg [REG_BITS-1:0] acc;
	reg p;
	reg [1:0] last_r_sum_msbs;

	// Control signals
	// ===============
	// not registers
	reg swap_args;
	reg use_e1, use_r1; // after swapping
	reg acc_we, p_we, block_e_we;
	reg neg_r2, neg_e2;
	reg e_carry_in;
	reg signed [SHIFT_BITS-1:0] n_r2_shr, n_r2_shr_normalize;
	reg replace_r2shifted_msb, r2_shifted_new_msb;
	reg replace_e1_with_n_shr_normalize;
	reg rshift_e2;
	reg r_msb_from_sign;
	always_comb begin
		swap_args = 0;
		use_e1 = 1;
		use_r1 = 1;
		acc_we = 0;
		block_e_we = 0;
		p_we = 0;
		neg_r2 = 0;
		neg_e2 = 0;
		e_carry_in = 0;
		n_r2_shr = 0;
		//n_r2_shr_normalize = 'X;
		replace_r2shifted_msb = 0;
		r2_shifted_new_msb = 'X;
		replace_e1_with_n_shr_normalize = 0;
		rshift_e2 = 0;
		r_msb_from_sign = 0;

		case (inst)
			`AFL_INST_LOAD: begin
				acc_we = 1;
				use_e1 = 0;
				use_r1 = 0;
			end
			`AFL_INST_SQRT: begin
				acc_we = 1;
				use_e1 = 0;
				use_r1 = 0;
				rshift_e2 = 1;
				n_r2_shr = 1;
				replace_r2shifted_msb = 1;
				r2_shifted_new_msb = e2[0];
			end
			`AFL_INST_ADDALL0, `AFL_INST_ADDALL1: begin
				acc_we = inst[0];
				e_carry_in = p;
				p_we = 1;
			end
			`AFL_INST_CMPABS: begin
				neg_r2 = 1;
				neg_e2 = 1;
				e_carry_in = neg_e2;
				p_we = 1;
			end
			`AFL_INST_ADDINT: begin
				acc_we = 1;
				block_e_we = 1;
				r_msb_from_sign = 1;
				n_r2_shr = n_arg2_shr_ext;
				neg_r2 = neg_arg2_ext;
			end
			`AFL_INST_ADD: begin
				acc_we = 1;
				swap_args = p;
				neg_e2 = 1;
				e_carry_in = neg_e2;
				//n_r2_shr = e_sum;
				// saturate n_r2_shr if e_sum is too low
				n_r2_shr = (e_sum[E_BITS-1:SHIFT_BITS-1] == 0) ? e_sum : 2**(E_BITS-1)-1;
				neg_r2 = s1 ^ s2;
			end
			`AFL_INST_NORMALIZE: begin
				acc_we = 1;
				swap_args = 1;
				use_r1 = 0;
				replace_e1_with_n_shr_normalize = 1;
				case (last_r_sum_msbs)
					0: begin
						//n_r2_shr_normalize = prio_enc_out;
					end
					1: begin
						//n_r2_shr_normalize = 0;
					end
					2, 3: begin
						//n_r2_shr_normalize = 1;
						replace_r2shifted_msb = 1;
						r2_shifted_new_msb = last_r_sum_msbs[0];
					end
				endcase
				n_r2_shr = n_r2_shr_normalize;
			end
			default: begin
				acc_we = 0;
			end
		endcase
	end

	always_comb begin
		n_r2_shr_normalize = 'X;
		case (inst)
			`AFL_INST_NORMALIZE: begin
				case (last_r_sum_msbs)
					0: n_r2_shr_normalize = prio_enc_out;
					1: n_r2_shr_normalize = 0;
					2, 3: n_r2_shr_normalize = 1;
					default: n_r2_shr_normalize = 'X;
				endcase
			end
			default:;
		endcase
	end



	// Computation
	// ===========

	// Readout, prepare
	// ----------------
	wire [REG_BITS-1:0] accval = {acc[REG_BITS-1] ^ flip_acc, acc[REG_BITS-2:0]};

	//assign s_acc = accval[REG_BITS-1];
	//assign s_reg = ext[REG_BITS-1];

	wire signed [E_BITS-1:0] e_acc;
	wire [M_BITS-1:0] m_acc, m_reg;
	assign {s_acc, e_acc, m_acc} = accval;
	assign {s_reg, e_reg, m_reg} = ext;

	wire arg1_source = both_args_same ? both_args_source :  swap_args;
	wire arg2_source = both_args_same ? both_args_source : !swap_args;
	wire [REG_BITS-1:0] arg1 = arg1_source ? ext : accval;
	wire [REG_BITS-1:0] arg2 = arg2_source ? ext : accval;

	assign {s1, e1_0, r1_0[M_BITS-1:0]} = arg1;
	assign {s2, e2, r2[M_BITS-1:0]} = arg2;
	assign e1_0_ext = {e1_0[E_BITS-1], e1_0};
	assign e1 = use_e1 ? (replace_e1_with_n_shr_normalize ? n_r2_shr_normalize : e1_0_ext) : 0;
	/*
	assign r1_0[R_BITS-1] = 1'b1;
	assign r2[R_BITS-1] = 1'b1;
	*/
	// Hack to represent zero
	assign r1_0[R_BITS-1] = r_msb_from_sign ? s1 : ($unsigned(e1_0) != 2**(E_BITS-1));
	assign r2[R_BITS-1] = r_msb_from_sign ? s2 : ($unsigned(e2) != 2**(E_BITS-1));

	assign r1 = use_r1 ?  r1_0 : 0;

	wire [E_BITS-1:0] e2_shifted = rshift_e2 ? {e2[E_BITS-1], e2[E_BITS-1:1]} : e2;
	wire [R_BITS-1:0] r2_shifted0, r2_shifted;

	shifter #(.BITS(R_BITS)) r2_shifter(
		.in(r2), .n_shr(n_r2_shr),
		.out(r2_shifted0)
	);
	assign r2_shifted[R_BITS-2-1:0] = r2_shifted0[R_BITS-2-1:0];
	assign r2_shifted[R_BITS-2] = replace_r2shifted_msb ? r2_shifted_new_msb : r2_shifted0[R_BITS-2];
	assign r2_shifted[R_BITS-1] = r2_shifted0[R_BITS-1];


	wire [E_BITS-1:0] e2_2 = neg_e2 ? ~e2_shifted : e2_shifted;
	wire [R_BITS+1-1:0] r2_2 = neg_r2 ? ~r2_shifted : r2_shifted;

	// Calculate
	// ---------
	priority_encoder #(.BITS(M_BITS)) prio_enc(
		.bits(m_acc),
		.n_shr(prio_enc_out), .underflow(prio_enc_underflow)
	);

	wire r_carry_in = neg_r2;
	wire [R_BITS+1-1:0] r_sum = r1 + r2_2 + r_carry_in;
	//wire [R_BITS+1-1:0] r1_ext = {r_msb_from_sign & r1[R_BITS-1], r1};
	//wire [R_BITS+1-1:0] r2_2_ext = {r_msb_from_sign & r2_2[R_BITS-1], r2_2};
	//wire [R_BITS+1-1:0] r_sum = r1_ext + r2_2_ext + r_carry_in;

	//wire [E_BITS+1-1:0] e1_ext = {e1[E_BITS-1], e1};
	wire [E_BITS+1-1:0] e2_2_ext = {e2_2[E_BITS-1], e2_2};
	assign e_sum = e1 + e2_2_ext + e_carry_in;

	wire s_prod = s1 ^ s2;
	//wire s_prod = s_acc ^ s_reg;


	// Assign results
	// --------------
	wire s_result_r_sum = r_sum[M_BITS];

	// not registers
	reg s_result, p_result;
	reg [E_BITS+1-1:0] e_result;
	reg [M_BITS-1:0] m_result;
	reg underflow;
	always_comb begin
		s_result = s_prod;
		e_result = e_sum;
		m_result = r_sum[M_BITS-1:0];
		p_result = r_sum[M_BITS];
		underflow = 0;

		case (inst)
			`AFL_INST_CMPABS: begin
				p_result = (e_result == 0) ? r_sum[M_BITS] : e_sum[E_BITS];
			end
			`AFL_INST_ADD: begin
				s_result = s1;
				e_result = e1;
			end
			`AFL_INST_NORMALIZE: begin
				s_result = s_acc; //s2;
				e_result = e_sum;
				underflow = prio_enc_underflow && last_r_sum_msbs == 0;
			end
			`AFL_INST_LOAD: begin
				s_result = s2;
			end
			`AFL_INST_SQRT: begin
				s_result = s2;
			end
			`AFL_INST_ADDINT: begin
				s_result = s_result_r_sum;
			end
			default: ;
		endcase // inst

		if (e_result[E_BITS] != e_result[E_BITS-1]) begin
			// over/underflow
			if (e_result[E_BITS]) underflow = 1;
			// TODO: otherwise overflow
		end

		if (underflow) begin
			m_result = '0;
			e_result = -2**(E_BITS-1);
		end

		if (m_mask_sext) begin
			m_result[M_BITS-1 -: M_MASK_BITS] = {M_MASK_BITS{m_result[M_BITS-1-M_MASK_BITS]}};
			m_result[M_BITS-1] = !m_result[M_BITS-1];
		end
		if (m_mask_sext2) begin
			m_result[M_BITS-1 -: 1] = {1{m_result[M_BITS-1-1]}};
			m_result[M_BITS-1] = !m_result[M_BITS-1];
		end

		s_result = (abs_result ? 0 : s_result) ^ flip_result;
	end


	// Store results
	// =============
	always @(posedge clk) if (en) begin
		//if (acc_we) acc <= {s_result, e_result[E_BITS-1:0], m_result};
		if (acc_we) begin
			acc[E_BITS+M_BITS] <= s_result;
			if (!block_e_we) acc[E_BITS+M_BITS-1 -: E_BITS] <= e_result[E_BITS-1:0];
			acc[M_BITS-1:0] <= m_result;
		end
		if (p_we) p <= p_result;
		if (inst == `AFL_INST_ADD) last_r_sum_msbs <= r_sum[M_BITS+1:M_BITS];
	end

	assign acc_out = acc; // Don't apply flip_acc
	assign int_msb_out = s_result_r_sum;
	assign m_result0 = r_sum[M_BITS-1:0];
endmodule : afl2_alu
