/*
 * Copyright (c) 2025 Toivo Henningsson
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

`include "pwl4_synth.vh"


module demo_top #(parameter COLOR_CHANNEL_BITS=2, HALF_FPS=0) (
		input clk, reset,
		input wire [1:0] advance,

		output wire pwm_out,
		output wire [COLOR_CHANNEL_BITS*3-1:0] rgb,
		output wire hsync, vsync, new_frame
	);

/*
	pwl4_player player(
		.clk(clk), .reset(reset),.en(1), .advance(advance),
		.use_alt_osc(0),
		.pwm_out(pwm_out)
	);
*/

	field_test #(.COLOR_CHANNEL_BITS(COLOR_CHANNEL_BITS), .HALF_FPS(HALF_FPS)) field_top(
		.clk(clk), .reset(reset), .advance(advance),
		.rgb(rgb), .new_frame(new_frame), .hsync(hsync), .vsync(vsync),
		.pwm_out(pwm_out)
	);
endmodule : demo_top
