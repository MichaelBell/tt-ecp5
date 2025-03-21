/*
 * Copyright (c) 2025 Toivo Henningsson
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

`include "common.vh"

module demo_control(
		input wire [`DEMO_TIME_BITS-1:0] timer,
		output wire [`DEMO_CONTROL_BITS-1:0] control
	);

	wire [`DEMO_TIME_BITS-10-1:0] pattern0 = timer >> 10;
	wire [1:0] subsection = timer >> 8;
	wire [6:0] ppos = timer >> 3;

	reg music_on, bdrum_on, ndrum_on, bass_on, noise_on, raise_on, prenoise_on, square_on, all_square_on;
	//wire music_on = (pattern0[1:0] != 0);

	wire section_final = (ppos[6:3] == '1);

	// not a register
	reg [`PATTERN_BITS-1:0] pattern;
	reg logo_on, rev_logo_lines;
	reg [`AFL_SECTION_BITS-1:0] afl_section;
	reg afl_on;
	reg wave_on;
	reg [`WAVE_MODE_BITS-1:0] wave_mode;
	always_comb begin
		music_on = 1;
		bdrum_on = 1;
		ndrum_on = 1;
		bass_on = 0;
		noise_on = 0;
		raise_on = 0;
		prenoise_on = 1;
		square_on = 0;
		all_square_on = 0;
		pattern = 'X;
		logo_on = 0; rev_logo_lines = 0;
		afl_section = 'X;
		afl_on = 1;
		wave_on = 1;
		wave_mode = `WAVE_MODE_PRENOISE;

		case (pattern0)
			0: begin
				music_on = 0; bdrum_on = 0; ndrum_on = 0;
				pattern = 0; // ´X?
				afl_section = `AFL_SECTION_PILLAR; afl_on = 0;
			end
			1: begin;
				bdrum_on = 0; ndrum_on = 0;
				pattern = 2;
				logo_on = 1;
				afl_section = `AFL_SECTION_PILLAR; afl_on = 0;
				//afl_section = `AFL_SECTION_PILLAR;
				//afl_section = `AFL_SECTION_RP;
				//afl_section = `AFL_SECTION_SPIRAL;
				if (section_final) ndrum_on = 1;
			end
			2: begin
				bdrum_on = 0;
				pattern = 0;
				square_on = 1;
				//wave_on = 0;
				wave_on = subsection[1];
				wave_mode = `WAVE_MODE_ARP;
				afl_section = `AFL_SECTION_PILLAR;
			end
			3: begin
				pattern = 0; // ´X?
				music_on = 0;
				all_square_on = 1;

				bdrum_on = 0;
				if (ppos[4:3] == '1) begin
					if (subsection[0]) bass_on = 1;
					if (subsection != 1) bdrum_on = 1;
				end
				if (subsection == 3 && ppos[4]) bass_on = 1;

				ndrum_on = bdrum_on;
				//wave_mode = bdrum_on ? `WAVE_MODE_DRUMS : `WAVE_MODE_PRENOISE;
				wave_mode = bass_on ? `WAVE_MODE_BASS : (bdrum_on ? `WAVE_MODE_DRUMS : `WAVE_MODE_PRENOISE);
				afl_section = `AFL_SECTION_PILLAR; afl_on = 0;
			end
			4: begin
`ifdef USE_RAISE
				pattern = 3;
				if (subsection == 3) prenoise_on = 0;
`else
				pattern = 2;
`endif
				afl_section = `AFL_SECTION_SPIRAL;
			end
			5: begin
`ifdef USE_RAISE
				raise_on = 1;
`endif
				square_on = 1;
				pattern = 1;
				logo_on = 1;
				afl_section = `AFL_SECTION_PILLAR; afl_on = 0;
				wave_mode = `WAVE_MODE_ARP;
			end
			6: begin;
`ifdef USE_RAISE
				raise_on = 1;
`endif
				all_square_on = 1;
				pattern = 2;
				logo_on = 1;
				wave_mode = `WAVE_MODE_ARP;
				afl_section = subsection[0];
				rev_logo_lines = (subsection == 3);
				afl_on = !rev_logo_lines;
				wave_on = !rev_logo_lines;

				bdrum_on = !subsection[1];
				ndrum_on = (subsection != 3);
				music_on = (ppos != '1);
			end
			7: begin;
				pattern = 'X;
				logo_on = 0;
				wave_on = 0;
				afl_section = 'X;
				afl_on = 0;
				music_on = 0;
				bdrum_on = 0;
				ndrum_on = 1;
				noise_on = 1;
				prenoise_on = 0;
			end
			default: begin
				pattern = 'X;
				afl_section = 'X;
				afl_on = 'X;
			end
		endcase
	end

	assign control[`DEMO_CONTROL_BIT_MELODY] = music_on;
	assign control[`DEMO_CONTROL_BIT_BDRUM] = bdrum_on;
	assign control[`DEMO_CONTROL_BIT_NDRUM] = ndrum_on;
	assign control[`DEMO_CONTROL_BIT_BASS] = bass_on;
	assign control[`DEMO_CONTROL_BIT_NOISE] = noise_on;
	assign control[`DEMO_CONTROL_BIT_RAISE] = raise_on;
	assign control[`DEMO_CONTROL_BIT_PRENOISE] = prenoise_on;
	assign control[`DEMO_CONTROL_BIT_SQUARE] = square_on;
	assign control[`DEMO_CONTROL_BIT_ALL_SQUARE] = all_square_on;

	assign control[`DEMO_CONTROL_BIT_EFFECT] = afl_on;


	// not registers
	reg logo_vis;
	reg [1:0] logo_lines;
	always_comb begin
		logo_vis = 1;
		logo_lines = 0;

		case (ppos[6:5])
//4 12 16
			0: case (ppos[4:1])
				0, 1: logo_vis = 0;
				2, 3, 4, 5: logo_lines = 0;
				6, 7: logo_lines = 1;
				default: logo_lines = 2;
			endcase
//36 42 48 54
			1: case (ppos[4:1])
				0, 1: logo_vis = 0;
				2, 3, 4: logo_lines = 0;
				5, 6, 7: logo_lines = 1;
				8, 9, 10: logo_lines = 2;
				default: logo_lines = 3;
			endcase
//64 (74) 80 86
			2: case (ppos[4:1])
				0, 1, 2, 3, 4: logo_vis = 0;
				5, 6, 7: logo_lines = 0;
				8, 9, 10: logo_lines = 1;
				default: logo_lines = 2;
			endcase
//108 116 124
			3: begin
				case (ppos[4:1])
					0, 1, 2, 3, 4, 5: logo_lines = 3; //logo_vis = 0;
					6, 7, 8, 9: logo_lines = 0;
					10, 11, 12, 13: logo_lines = 1;
					default: logo_lines = 2;
				endcase
				if (rev_logo_lines) logo_lines[0] ^= 1;
				logo_vis = (logo_lines != 3);
			end
			default: logo_lines = 'X;
		endcase
	end


	//assign control[`DEMO_CONTROL_BIT_DETUNE_DOUBLE] = !pattern[1];
	assign control[`DEMO_CONTROL_BIT_DETUNE_DOUBLE] = 1;

	assign control[`DEMO_CONTROL_BIT_PATTERN + `PATTERN_BITS     - 1 -: `PATTERN_BITS]     = pattern;
	assign control[`DEMO_CONTROL_BIT_AFL     + `AFL_SECTION_BITS - 1 -: `AFL_SECTION_BITS] = afl_section;

	assign control[`DEMO_CONTROL_BIT_LOGO_ON] = logo_vis && logo_on;
	assign control[`DEMO_CONTROL_BIT_REV_LOGO_LINES] = 0; //rev_logo_lines;
	//wire [3:0] pos4 = timer >> 4;
	//wire [1:0] logo_lines = (pos4[3:2] != 0) ? 3 : pos4[1:0];
	assign control[`DEMO_CONTROL_BIT_LOGO_LINES1 -: 2] = logo_lines;

	assign control[`DEMO_CONTROL_BIT_WAVE_ON] = wave_on;
	assign control[`DEMO_CONTROL_BIT_WAVE_MODE + `WAVE_MODE_BITS - 1 -: `WAVE_MODE_BITS] = wave_mode;
endmodule : demo_control
