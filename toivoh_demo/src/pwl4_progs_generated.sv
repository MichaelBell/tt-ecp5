	0:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	1:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 0;	acc_we_nbits = -1; end
	2:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 1;	acc_we_nbits = -1; end
	3:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 2;	acc_we_nbits = -1; end
	4:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 3;	acc_we_nbits = -1; end
	5:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 4;	acc_we_nbits = -1; end
	6:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 5;	acc_we_nbits = -1; end
	7:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 6;	acc_we_nbits = -1; end
	8:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 7;	acc_we_nbits = -1; end
	9:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 8;	acc_we_nbits = -1; end
	10:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 9;	acc_we_nbits = -1; end
	11:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 10;	acc_we_nbits = -1; end
	12:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 11;	acc_we_nbits = -1; end

	13:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	14:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 0;	acc_we_nbits = 11; end
	15:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	16:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 1;	acc_we_nbits = 10; end
	17:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	18:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 2;	acc_we_nbits = 9; end
	19:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	20:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 3;	acc_we_nbits = 8; end
	21:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	22:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 4;	acc_we_nbits = 7; end
	23:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	24:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 5;	acc_we_nbits = 6; end
	25:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	26:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 6;	acc_we_nbits = 5; end
	27:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	28:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 7;	acc_we_nbits = 4; end
	29:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	30:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 8;	acc_we_nbits = 3; end
	31:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	32:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 9;	acc_we_nbits = 2; end
	33:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	34:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 10;	acc_we_nbits = 1; end
	35:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end

	36:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	37:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 0;	acc_we_nbits = -1; end
	38:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 1;	acc_we_nbits = -1; end
	39:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 2;	acc_we_nbits = -1; end
	40:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 3;	acc_we_nbits = -1; end
	41:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 4;	acc_we_nbits = -1; end
	42:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	43:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 5;	acc_we_nbits = 11; end
	44:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	45:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 6;	acc_we_nbits = 10; end
	46:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	47:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 7;	acc_we_nbits = 9; end
	48:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	49:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 8;	acc_we_nbits = 8; end
	50:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	51:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 9;	acc_we_nbits = 7; end
	52:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	53:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 10;	acc_we_nbits = 6; end
	54:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	55:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 11;	acc_we_nbits = 5; end
	56:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	57:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 12;	acc_we_nbits = 4; end
	58:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	59:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 13;	acc_we_nbits = 3; end
	60:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	61:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 14;	acc_we_nbits = 2; end
	62:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	63:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 0;	osc_cond_bit = 15;	acc_we_nbits = 1; end
	64:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end

	65:	begin; we = 2**`SYNTH_WE_BIT_ACC | 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	66:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_ALMOST_ONE;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end

	67:	begin; we = 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_INV_P_RESULT;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	68:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0 | 2**`SYNTH_ALU_FLAG_BIT_INV_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	69:	begin; we = 2**`SYNTH_WE_BIT_ACC | 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	70:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_ALMOST_ONE;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end

	71:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_LSB_MINUS_ONE;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_P_SIGN_ACC;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	72:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	73:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ALMOST_ONE;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2;	osc_cond_bit = -1;	acc_we_nbits = -1; end

	74:	begin; we = 2**`SYNTH_WE_BIT_ACC | 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_P_RESULT_OV;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	75:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_ALMOST_ONE;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end

	76:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_LSB_MINUS_ONE;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_P_SIGN_ACC;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	77:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	78:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ALMOST_ONE;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	79:	begin; we = 2**`SYNTH_WE_BIT_ACC | 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	80:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_ALMOST_ONE;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	81:	begin; we = 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_INV_P_RESULT;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	82:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0 | 2**`SYNTH_ALU_FLAG_BIT_INV_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	83:	begin; we = 2**`SYNTH_WE_BIT_ACC | 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	84:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_ALMOST_ONE;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end

	85:	begin; we = 2**`SYNTH_WE_BIT_P1;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	86:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_LSB_MINUS_ONE;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_P_SIGN_ACC;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	87:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	88:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ALMOST_ONE;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	89:	begin; we = 2**`SYNTH_WE_BIT_ACC | 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P1;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	90:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_ALMOST_ONE;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0 | 2**`SYNTH_ALU_FLAG_BIT_P1;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	91:	begin; we = 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_INV_P_RESULT | 2**`SYNTH_ALU_FLAG_BIT_P1;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	92:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0 | 2**`SYNTH_ALU_FLAG_BIT_P1 | 2**`SYNTH_ALU_FLAG_BIT_INV_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	93:	begin; we = 2**`SYNTH_WE_BIT_ACC | 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0 | 2**`SYNTH_ALU_FLAG_BIT_P1;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	94:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_ALMOST_ONE;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0 | 2**`SYNTH_ALU_FLAG_BIT_P1;	osc_cond_bit = -1;	acc_we_nbits = -1; end

	95:	begin; we = 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC_SAR1;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	96:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SAR1;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0 | 2**`SYNTH_ALU_FLAG_BIT_INV_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end

	97:	begin; we = 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	98:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0 | 2**`SYNTH_ALU_FLAG_BIT_INV_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end

	99:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_OSC_LOW;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	100:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	101:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	102:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = 6; end
	103:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = 6; end
	104:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_ALMOST_ONE;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = 5; end
	105:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_OSC_HIGH;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = 5; end
	106:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_PERM;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	107:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end

