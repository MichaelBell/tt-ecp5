	TIME0+0: begin; inst = `AFL_INST_LOAD;	afl_arg = AFL_ARG_bias_trs;	end
	TIME0+1: begin; inst = `AFL_INST_ADDINT;	afl_arg = AFL_ARG_masked_bits;	end
	TIME0+2: begin; inst = `AFL_INST_ADDINT;	afl_arg = AFL_ARG_bias;	abs_result = 1'b1;	sflag2_we = 1'b1;	sflag_we = 1'b1;	end
	TIME0+3: begin; inst = `AFL_INST_ADD;	afl_arg = AFL_ARG_bias;	flip_acc = 1'b1;	flip_result = 1'b1;	end
	TIME0+4: begin; inst = `AFL_INST_ADDALL0;	both_args_source = 1'b0;	both_args_same = 1'b1;	end
	TIME0+5: begin; inst = `AFL_INST_ADD;	afl_arg = AFL_ARG_e_m2;	flip_acc = 1'b1;	flip_result = 1'b0;	end
	TIME0+6: begin; inst = `AFL_INST_ADDALL0;	afl_arg = AFL_ARG_trss_cosign_scaled2;	end
	TIME0+7: begin; inst = `AFL_INST_NOP;	dest_index = 2; dest_we = 1'b1;	end
	TIME0+8: begin; inst = `AFL_INST_LOAD;	afl_arg = AFL_ARG_bias_trs;	end
	TIME0+9: begin; inst = `AFL_INST_ADDINT;	afl_arg = AFL_ARG_masked_bits;	end
	TIME0+10: begin; inst = `AFL_INST_ADDINT;	afl_arg = AFL_ARG_one;	abs_result = 1'b1;	sflag2_we = 1'b0;	sqrt_valid_we[1] = 1'b1;	sflag_we = 1'b1;	sqrt_valid_use_sflag2 = 1'b1;	end
	TIME0+11: begin; inst = `AFL_INST_ADD;	afl_arg = AFL_ARG_bias;	flip_acc = 1'b1;	flip_result = 1'b1;	end
	TIME0+12: begin; inst = `AFL_INST_ADDALL0;	both_args_source = 1'b0;	both_args_same = 1'b1;	end
	TIME0+13: begin; inst = `AFL_INST_ADD;	afl_arg = AFL_ARG_e_m2;	flip_acc = 1'b1;	flip_result = 1'b0;	end
	TIME0+14: begin; inst = `AFL_INST_ADDALL0;	afl_arg = AFL_ARG_trs_cosign_scaled;	end
	TIME0+15: begin; inst = `AFL_INST_ADD;	afl_arg = AFL_ARG_bias;	end
	TIME0+16: begin; inst = `AFL_INST_LOAD;	afl_arg = AFL_ARG_bias_y;	dest_index = 3; dest_we = 1'b1;	end
	TIME0+17: begin; inst = `AFL_INST_ADDINT;	afl_arg = AFL_ARG_bias_trs;	abs_result = 1'b1;	masked_bits_we = 1'b1;	m_mask_sext = 1'b1;	n_arg2_shr_ext = 1;	end
	TIME0+18: begin; inst = `AFL_INST_ADD;	afl_arg = AFL_ARG_bias;	flip_acc = 1'b1;	flip_result = 1'b1;	abs_result = 1'b0;	end
	TIME0+19: begin; inst = `AFL_INST_ADDALL0;	both_args_source = 1'b0;	both_args_same = 1'b1;	end
	TIME0+20: begin; inst = `AFL_INST_ADD;	afl_arg = AFL_ARG_sat_small_r2;	flip_acc = 1'b1;	flip_result = 1'b0;	end
	TIME0+21: begin; inst = `AFL_INST_ADD;	afl_arg = AFL_ARG_reg2;	flip_acc = 1'b1;	flip_result = 1'b1;	end
	TIME0+22: begin; inst = `AFL_INST_SQRT;	both_args_source = 1'b0;	sqrt_valid_we[0] = 1'b1;	both_args_same = 1'b1;	end
	TIME0+23: begin; inst = `AFL_INST_ADDALL0;	afl_arg = AFL_ARG_circle_scale;	end
	TIME0+24: begin; inst = `AFL_INST_ADD;	afl_arg = AFL_ARG_reg3;	flip_acc = 1'b1;	flip_result = 1'b0;	dest_index = 4; dest_we = 1'b1;	end
	TIME0+25: begin; inst = `AFL_INST_LOAD;	afl_arg = AFL_ARG_reg4;	dest_index = 0; dest_we = 1'b1;	end
	TIME0+26: begin; inst = `AFL_INST_ADD;	afl_arg = AFL_ARG_reg3;	end
	TIME0+27: begin; inst = `AFL_INST_NOP;	dest_index = 1; dest_we = 1'b1;	end
	TIME0+28: begin; inst = `AFL_INST_LOAD;	afl_arg = AFL_ARG_reg2;	end
	TIME0+29: begin; inst = `AFL_INST_ADDALL0;	afl_arg = AFL_ARG_rescale2;	end
	TIME0+30: begin; inst = `AFL_INST_ADDALL0;	afl_arg = AFL_ARG_reg4;	end
	TIME0+31: begin; inst = `AFL_INST_ADD;	afl_arg = AFL_ARG_reg3;	end
	TIME0+32: begin; inst = `AFL_INST_NOP;	dest_index = 2; dest_we = 1'b1;	end
