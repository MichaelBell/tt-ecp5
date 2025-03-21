/*
 * Copyright (c) 2025 Toivo Henningsson
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module axis_scan #(parameter BITS=10) (
		input wire clk, reset, en,

		input wire [BITS-1:0] pos0, thresh0, thresh1, thresh2, thresh3,

		output reg [1:0] state,
		output reg [BITS-1:0] pos,
		output wire inc
	);

	reg [BITS-1:0] thresh;
	always_comb begin
		case (state)
			0: thresh = thresh0;
			1: thresh = thresh1;
			2: thresh = thresh2;
			3: thresh = thresh3;
			default: thresh = 'X;
		endcase // state
	end

	assign inc = en && (pos == thresh);

	always @(posedge clk) begin
		if (reset || (inc && (state == 3))) begin
			state <= 0;
			pos <= pos0;
		end else begin
			pos <= pos + en;
			state <= state + inc;
		end
	end
endmodule : axis_scan


module raster_scan (
		input wire clk, reset, en,

		output wire signed [10:0] x,
		output wire signed [9:0] y,
		output wire active, hsync, vsync, new_line, new_frame, x_active, y_active
	);

	// X
	localparam X_BITS = 11;
	// 						   state
	localparam FP_W = 16*2; 	// 0
	localparam SYNC_W = 96*2; 	// 1
	localparam BP_W = 48*2; 	// 2
	localparam ACTIVE_W = 640*2;// 3
	localparam X0 = -(FP_W + SYNC_W + BP_W) - ACTIVE_W/2;

	wire [1:0] x_state;
	wire x_inc;
	axis_scan #(.BITS(X_BITS)) scan_x(
		.clk(clk), .reset(reset), .en(en),
		.pos0(X0),
		.thresh0(X0 + FP_W - 1),
		.thresh1(X0 + FP_W + SYNC_W - 1),
		.thresh2(X0 + FP_W + SYNC_W + BP_W - 1),
		.thresh3(X0 + FP_W + SYNC_W + BP_W + ACTIVE_W - 1),
		.state(x_state), .pos(x), .inc(x_inc)
	);

	assign x_active =  (x_state == 3);
	assign hsync    = !(x_state == 1);
	assign new_line =   x_inc && !hsync;

	// Y
	localparam Y_BITS = 10;

/*
	// 						   state
	localparam ACTIVE_H = 480;  // 0
	localparam FP_H = 10;		// 1
	localparam SYNC_H = 2; 		// 2
	localparam BP_H = 33; 		// 3
	localparam Y0 = -ACTIVE_H/2;
*/
	// 						   state
	localparam BP_H = 33; 		// 0
	localparam ACTIVE_H = 480;  // 1
	localparam FP_H = 10;		// 2
	localparam SYNC_H = 2; 		// 3
	localparam Y0 = -ACTIVE_H/2 - BP_H;

	wire [1:0] y_state;
	wire y_inc;
	axis_scan #(.BITS(Y_BITS)) scan_y(
		.clk(clk), .reset(reset), .en(en && new_line),
		.pos0(Y0),
		.thresh0(Y0 + BP_H - 1),
		.thresh1(Y0 + BP_H + ACTIVE_H - 1),
		.thresh2(Y0 + BP_H + ACTIVE_H + FP_H - 1),
		.thresh3(Y0 + BP_H + ACTIVE_H + FP_H + SYNC_H - 1),
		.state(y_state), .pos(y), .inc(y_inc)
	);
/*
	assign y_active  =  (y_state == 0);
	assign vsync     = !(y_state == 2);
	assign new_frame =   y_inc && (y_state == 3);
*/
	assign y_active  =  (y_state == 1);
	assign vsync     = !(y_state == 3);
	assign new_frame =   y_inc && (y_state == 3);

	assign active = x_active && y_active;
endmodule : raster_scan
