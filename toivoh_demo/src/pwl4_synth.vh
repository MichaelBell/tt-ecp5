/*
 * Copyright (c) 2024-2025 Toivo Henningsson
 * SPDX-License-Identifier: Apache-2.0
 */

`define USE_EXT3


`define SYNTH_PRENOISE_MSB 15
`define SYNTH_QUAD_X_BITS 14

`define SYNTH_ACC_BIT_BITS 4
`define SYNTH_OSC_BIT_BITS 5

`define SYNTH_N_SAR_BITS 3
`define SYNTH_N_SLANT_BITS 3
`define SYNTH_N_SLANT_OFFSET 1

`define SYNTH_WF_BIT_SAW          0
`define SYNTH_WF_BIT_PRENOISE     1
`define SYNTH_WF_BIT_PRENOISE_ALT 2
`define SYNTH_WF_BIT_BDRUM        3
`define SYNTH_WF_BIT_NOISE        4
`define SYNTH_WF_BITS 5

`define LOG2_NEW_SAMPLE_CYCLES 2  // not more than 4, last cycle is not used



`define SYNTH_TERM1_BITS 4
`define SYNTH_TERM1_ZERO 			4'd0
`define SYNTH_TERM1_LSB_MINUS_ONE 	4'd1
//`define SYNTH_TERM1_ONE 			4'd2
//`define SYNTH_TERM1_OUT_ACC_INITIAL	4'd3

`define SYNTH_TERM1_ACC 			4'd8
`define SYNTH_TERM1_ACC_ROR1 		4'd9
`define SYNTH_TERM1_ACC_SHR1 		4'd10
`define SYNTH_TERM1_ACC_SAR1 		4'd11

`define SYNTH_TERM1_ACC_PERM 		4'd12
`define SYNTH_TERM1_OUT_ACC 		4'd15 // could go in either term


`ifdef USE_EXT3
`define SYNTH_TERM2_BITS 4
`define SYNTH_TERM2_ZERO 			4'd0
`define SYNTH_TERM2_ALMOST_ONE		4'd1

`define SYNTH_TERM2_OSC_LOW			4'd2 // Needs to be opposite to SYNTH_TERM1_LSB_MINUS_ONE
`define SYNTH_TERM2_OSC_HIGH		4'd3 // Needs to be opposite to SYNTH_TERM1_ACC_ROR1, SYNTH_TERM1_ACC_SHR1

`define SYNTH_TERM2_ACC 			4'd4
`define SYNTH_TERM2_EXT0 			4'd5 // Needs to be opposite to SYNTH_TERM1_ACC_SHR1
`define SYNTH_TERM2_EXT1 			4'd6 // Needs to be in term2 to be conditionally negated
`define SYNTH_TERM2_EXT2 			4'd7 // Needs to be in term2 to be conditionally negated
`define SYNTH_TERM2_EXT3 			4'd8 // Needs to be in term2 to be conditionally negated
`else
`define SYNTH_TERM2_BITS 3
`define SYNTH_TERM2_ZERO 			3'd0
`define SYNTH_TERM2_ALMOST_ONE		3'd1

`define SYNTH_TERM2_OSC_LOW			3'd2 // Needs to be opposite to SYNTH_TERM1_LSB_MINUS_ONE
`define SYNTH_TERM2_OSC_HIGH		3'd3 // Needs to be opposite to SYNTH_TERM1_ACC_ROR1, SYNTH_TERM1_ACC_SHR1

`define SYNTH_TERM2_ACC 			3'd4
`define SYNTH_TERM2_EXT0 			3'd5 // Needs to be opposite to SYNTH_TERM1_ACC_SHR1
`define SYNTH_TERM2_EXT1 			3'd6 // Needs to be in term2 to be conditionally negated
`define SYNTH_TERM2_EXT2 			3'd7 // Needs to be in term2 to be conditionally negated
`endif




`define SYNTH_ALU_FLAG_BIT_NEG_TERM2 0
//`define SYNTH_ALU_FLAG_BIT_IGNORE_SIGN_ACC 1
`define SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG 1
`define SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG 2
`define SYNTH_ALU_FLAG_BIT_ZEXT 3
`define SYNTH_ALU_FLAG_BIT_P_RESULT_OV 4
`define SYNTH_ALU_FLAG_BIT_CARRY_IN_P1 5
`define SYNTH_ALU_FLAG_BIT_DETUNABLE 6 // could be term2_sel == SYNTH_TERM2_EXT0?
`define SYNTH_ALU_FLAG_BIT_DRUM 7
`define SYNTH_ALU_FLAG_BIT_INV_P_RESULT 8
//`define SYNTH_ALU_FLAG_BIT_AND_P_RESULT_P0 3
//`define SYNTH_ALU_FLAG_BIT_AND_P_RESULT_N_ACC_SM1 4
`define SYNTH_ALU_FLAG_BIT_P_SIGN_ACC 9
`define SYNTH_ALU_FLAG_BIT_P0 10
`define SYNTH_ALU_FLAG_BIT_P1 11
`define SYNTH_ALU_FLAG_BIT_INV_P0 12
`define SYNTH_ALU_FLAG_BIT_INV_P1 13
`define SYNTH_ALU_FLAG_BIT_COMP_POS_TERM2 14
`define SYNTH_ALU_FLAG_BITS 15


`define SYNTH_WE_BIT_OSC_LOW 0
`define SYNTH_WE_BIT_OSC_HIGH 1
`define SYNTH_WE_BIT_OSC2 2
`define SYNTH_WE_BIT_ACC 3
`define SYNTH_WE_BIT_OUT_ACC 4
`define SYNTH_WE_BIT_OUT 5
`define SYNTH_WE_BIT_P0 6
`define SYNTH_WE_BIT_P1 7
`define SYNTH_WE_BITS 8


`ifdef SIM
	`define MC_CHANGE_X
`elsif FPGA
	//`define MC_CHANGE_ZERO
	`define MC_PIPELINE_SCHED_INPUTS
`else
	//`define MC_BUF_CELLS // Turn off for IHP, can't get it to work and doesn't seem t be needed
`endif

`ifdef MC_CHANGE_X
`define MC_CHANGE
`endif
`ifdef MC_CHANGE_ZERO
`define MC_CHANGE
`endif
