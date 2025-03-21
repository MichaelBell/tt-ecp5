	0:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE;	osc_cond_bit = 0;	acc_we_nbits = -1; end
	1:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE;	osc_cond_bit = 1;	acc_we_nbits = -1; end
	2:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE;	osc_cond_bit = 2;	acc_we_nbits = -1; end
	3:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE;	osc_cond_bit = 3;	acc_we_nbits = -1; end
	4:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE;	osc_cond_bit = 4;	acc_we_nbits = -1; end
	5:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	6:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	7:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_P_RESULT_LSB_ACC;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	8:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE;	osc_cond_bit = 5;	acc_we_nbits = 11; end
	9:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	10:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE;	osc_cond_bit = 6;	acc_we_nbits = 10; end
	11:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	12:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE;	osc_cond_bit = 7;	acc_we_nbits = 9; end
	13:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	14:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE;	osc_cond_bit = 8;	acc_we_nbits = 8; end
	15:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	16:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE;	osc_cond_bit = 9;	acc_we_nbits = 7; end
	17:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	18:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE;	osc_cond_bit = 10;	acc_we_nbits = 6; end
	19:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	20:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE;	osc_cond_bit = 11;	acc_we_nbits = 5; end
	21:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	22:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE;	osc_cond_bit = 12;	acc_we_nbits = 4; end
	23:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	24:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE;	osc_cond_bit = 13;	acc_we_nbits = 3; end
	25:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	26:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE;	osc_cond_bit = 14;	acc_we_nbits = 2; end
	27:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	28:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE;	osc_cond_bit = 15;	acc_we_nbits = 1; end
	29:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	30:	begin; we = 2**`SYNTH_WE_BIT_P1;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	31:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_LSB_MINUS_ONE;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_P_SIGN_ACC;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	32:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	33:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ALMOST_ONE;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	34:	begin; we = 2**`SYNTH_WE_BIT_ACC | 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT3;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_P_RESULT_OV | 2**`SYNTH_ALU_FLAG_BIT_COMP_POS_TERM2;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	35:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_ALMOST_ONE;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	36:	begin; we = 2**`SYNTH_WE_BIT_ACC | 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P1;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	37:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_ALMOST_ONE;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0 | 2**`SYNTH_ALU_FLAG_BIT_P1;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	38:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	39:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	40:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	41:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	42:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	43:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	44:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	45:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	46:	begin; we = 2**`SYNTH_WE_BIT_ACC | 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	47:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_ALMOST_ONE;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	48:	begin; we = 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT1;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_INV_P_RESULT | 2**`SYNTH_ALU_FLAG_BIT_P1;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	49:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0 | 2**`SYNTH_ALU_FLAG_BIT_P1 | 2**`SYNTH_ALU_FLAG_BIT_INV_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	50:	begin; we = 2**`SYNTH_WE_BIT_ACC | 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT1;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0 | 2**`SYNTH_ALU_FLAG_BIT_P1;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	51:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_ALMOST_ONE;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0 | 2**`SYNTH_ALU_FLAG_BIT_P1;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	52:	begin; we = 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT2;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	53:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_EXT2;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0 | 2**`SYNTH_ALU_FLAG_BIT_INV_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	54:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	55:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	56:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SAR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	57:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SAR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	58:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SAR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	59:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	60:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	61:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	62:	begin; we = 2**`SYNTH_WE_BIT_OUT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_OUT_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	63:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end

	0:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE;	osc_cond_bit = 0;	acc_we_nbits = -1; end
	1:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE;	osc_cond_bit = 1;	acc_we_nbits = -1; end
	2:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE;	osc_cond_bit = 2;	acc_we_nbits = -1; end
	3:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE;	osc_cond_bit = 3;	acc_we_nbits = -1; end
	4:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE;	osc_cond_bit = 4;	acc_we_nbits = -1; end
	5:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	6:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	7:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_P_RESULT_LSB_ACC;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	8:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE;	osc_cond_bit = 5;	acc_we_nbits = 11; end
	9:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	10:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE;	osc_cond_bit = 6;	acc_we_nbits = 10; end
	11:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	12:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE;	osc_cond_bit = 7;	acc_we_nbits = 9; end
	13:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	14:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE;	osc_cond_bit = 8;	acc_we_nbits = 8; end
	15:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	16:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE;	osc_cond_bit = 9;	acc_we_nbits = 7; end
	17:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	18:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE;	osc_cond_bit = 10;	acc_we_nbits = 6; end
	19:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	20:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE;	osc_cond_bit = 11;	acc_we_nbits = 5; end
	21:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	22:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE;	osc_cond_bit = 12;	acc_we_nbits = 4; end
	23:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	24:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE;	osc_cond_bit = 13;	acc_we_nbits = 3; end
	25:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	26:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE;	osc_cond_bit = 14;	acc_we_nbits = 2; end
	27:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	28:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT0;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE;	osc_cond_bit = 15;	acc_we_nbits = 1; end
	29:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	30:	begin; we = 2**`SYNTH_WE_BIT_P1;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	31:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_LSB_MINUS_ONE;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_P_SIGN_ACC;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	32:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	33:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ALMOST_ONE;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	34:	begin; we = 2**`SYNTH_WE_BIT_ACC | 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT3;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_P_RESULT_OV | 2**`SYNTH_ALU_FLAG_BIT_COMP_POS_TERM2;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	35:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_ALMOST_ONE;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	36:	begin; we = 2**`SYNTH_WE_BIT_ACC | 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	37:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_ALMOST_ONE;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	38:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	39:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	40:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	41:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	42:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	43:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	44:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	45:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	46:	begin; we = 2**`SYNTH_WE_BIT_ACC | 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	47:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_ALMOST_ONE;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	48:	begin; we = 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT1;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_INV_P_RESULT;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	49:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0 | 2**`SYNTH_ALU_FLAG_BIT_INV_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	50:	begin; we = 2**`SYNTH_WE_BIT_ACC | 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT1;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	51:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_ALMOST_ONE;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	52:	begin; we = 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT2;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	53:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_EXT2;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0 | 2**`SYNTH_ALU_FLAG_BIT_INV_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	54:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	55:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	56:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SAR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	57:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SAR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	58:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SAR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	59:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	60:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	61:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	62:	begin; we = 2**`SYNTH_WE_BIT_OUT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_OUT_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	63:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end

	0:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_OSC_LOW;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	1:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	2:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	3:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = 6; end
	4:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = 6; end
	5:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_ALMOST_ONE;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = 5; end
	6:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_OSC_HIGH;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = 5; end
	7:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_PERM;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	8:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	9:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	10:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	11:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	12:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	13:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	14:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	15:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	16:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SAR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	17:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SAR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	18:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SAR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	19:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	20:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	21:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	22:	begin; we = 2**`SYNTH_WE_BIT_OUT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_OUT_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	23:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end

	0:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_OSC_HIGH;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE | 2**`SYNTH_ALU_FLAG_BIT_DRUM;	osc_cond_bit = 0;	acc_we_nbits = -1; end
	1:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_OSC_HIGH;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE | 2**`SYNTH_ALU_FLAG_BIT_DRUM;	osc_cond_bit = 1;	acc_we_nbits = -1; end
	2:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_OSC_HIGH;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE | 2**`SYNTH_ALU_FLAG_BIT_DRUM;	osc_cond_bit = 2;	acc_we_nbits = -1; end
	3:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_OSC_HIGH;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE | 2**`SYNTH_ALU_FLAG_BIT_DRUM;	osc_cond_bit = 3;	acc_we_nbits = -1; end
	4:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_OSC_HIGH;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE | 2**`SYNTH_ALU_FLAG_BIT_DRUM;	osc_cond_bit = 4;	acc_we_nbits = -1; end
	5:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_OSC_HIGH;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE | 2**`SYNTH_ALU_FLAG_BIT_DRUM;	osc_cond_bit = 5;	acc_we_nbits = -1; end
	6:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	7:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_P_RESULT_LSB_ACC;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	8:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_OSC_HIGH;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE | 2**`SYNTH_ALU_FLAG_BIT_DRUM;	osc_cond_bit = 6;	acc_we_nbits = 11; end
	9:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	10:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_OSC_HIGH;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE | 2**`SYNTH_ALU_FLAG_BIT_DRUM;	osc_cond_bit = 7;	acc_we_nbits = 10; end
	11:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	12:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_OSC_HIGH;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE | 2**`SYNTH_ALU_FLAG_BIT_DRUM;	osc_cond_bit = 8;	acc_we_nbits = 9; end
	13:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	14:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_OSC_HIGH;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE | 2**`SYNTH_ALU_FLAG_BIT_DRUM;	osc_cond_bit = 9;	acc_we_nbits = 8; end
	15:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	16:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_OSC_HIGH;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE | 2**`SYNTH_ALU_FLAG_BIT_DRUM;	osc_cond_bit = 10;	acc_we_nbits = 7; end
	17:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	18:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_OSC_HIGH;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE | 2**`SYNTH_ALU_FLAG_BIT_DRUM;	osc_cond_bit = 11;	acc_we_nbits = 6; end
	19:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	20:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_OSC_HIGH;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE | 2**`SYNTH_ALU_FLAG_BIT_DRUM;	osc_cond_bit = 12;	acc_we_nbits = 5; end
	21:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	22:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_OSC_HIGH;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE | 2**`SYNTH_ALU_FLAG_BIT_DRUM;	osc_cond_bit = 13;	acc_we_nbits = 4; end
	23:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	24:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_OSC_HIGH;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE | 2**`SYNTH_ALU_FLAG_BIT_DRUM;	osc_cond_bit = 14;	acc_we_nbits = 3; end
	25:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	26:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_OSC_HIGH;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE | 2**`SYNTH_ALU_FLAG_BIT_DRUM;	osc_cond_bit = 15;	acc_we_nbits = 2; end
	27:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	28:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_OSC_HIGH;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_DETUNABLE | 2**`SYNTH_ALU_FLAG_BIT_DRUM;	osc_cond_bit = 16;	acc_we_nbits = 1; end
	29:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_ROR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	30:	begin; we = 2**`SYNTH_WE_BIT_P1;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	31:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_LSB_MINUS_ONE;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_P_SIGN_ACC;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	32:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	33:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ALMOST_ONE;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	34:	begin; we = 2**`SYNTH_WE_BIT_ACC | 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT3;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_P_RESULT_OV | 2**`SYNTH_ALU_FLAG_BIT_COMP_POS_TERM2;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	35:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_ALMOST_ONE;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	36:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	37:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	38:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	39:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	40:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	41:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	42:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	43:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	44:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	45:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	46:	begin; we = 2**`SYNTH_WE_BIT_ACC | 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	47:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_ALMOST_ONE;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	48:	begin; we = 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT1;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_INV_P_RESULT;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	49:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0 | 2**`SYNTH_ALU_FLAG_BIT_INV_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	50:	begin; we = 2**`SYNTH_WE_BIT_ACC | 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT1;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	51:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_ALMOST_ONE;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	52:	begin; we = 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT2;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	53:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_EXT2;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0 | 2**`SYNTH_ALU_FLAG_BIT_INV_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	54:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	55:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	56:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	57:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	58:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	59:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	60:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	61:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	62:	begin; we = 2**`SYNTH_WE_BIT_OUT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_OUT_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	63:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end

	0:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	1:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	2:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	3:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	4:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	5:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	6:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_OSC_LOW;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	7:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = 2; end
	8:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_PERM;	term2_sel = `SYNTH_TERM2_OSC_HIGH;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	9:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	10:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_PERM;	term2_sel = `SYNTH_TERM2_OSC_HIGH;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	11:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	12:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_PERM;	term2_sel = `SYNTH_TERM2_OSC_HIGH;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	13:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	14:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_PERM;	term2_sel = `SYNTH_TERM2_OSC_HIGH;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	15:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SHR1;	term2_sel = `SYNTH_TERM2_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	16:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	17:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	18:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	19:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	20:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	21:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	22:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	23:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	24:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	25:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	26:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	27:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	28:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	29:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	30:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	31:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	32:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	33:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	34:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	35:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	36:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	37:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	38:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	39:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	40:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	41:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	42:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	43:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	44:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	45:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	46:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	47:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	48:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	49:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	50:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	51:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	52:	begin; we = 2**`SYNTH_WE_BIT_P0;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_EXT2;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2 | 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	53:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ZERO;	term2_sel = `SYNTH_TERM2_EXT2;	alu_flags = 2**`SYNTH_ALU_FLAG_BIT_FLIP_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_NEG_TERM2_IF_NEG | 2**`SYNTH_ALU_FLAG_BIT_P0 | 2**`SYNTH_ALU_FLAG_BIT_INV_P0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	54:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	55:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	56:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SAR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	57:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SAR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	58:	begin; we = 2**`SYNTH_WE_BIT_ACC;	term1_sel = `SYNTH_TERM1_ACC_SAR1;	term2_sel = `SYNTH_TERM2_ZERO;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	59:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	60:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	61:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end
	62:	begin; we = 2**`SYNTH_WE_BIT_OUT_ACC;	term1_sel = `SYNTH_TERM1_ACC;	term2_sel = `SYNTH_TERM2_OUT_ACC;	alu_flags = 0;	osc_cond_bit = -1;	acc_we_nbits = -1; end
	63:	begin; we = 0;	term1_sel = 'X;	term2_sel = 'X;	alu_flags = 'X;	osc_cond_bit = 'X;	acc_we_nbits = 'X; end

