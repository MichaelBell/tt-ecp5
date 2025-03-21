/*
 * Copyright (c) 2025 Michael Bell
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_ecp5_wrapper (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    inout  wire [7:0] uio,      // Bidir ios
    input  wire       clk,
    input  wire       rst_n
);

    wire [7:0] uio_in;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            assign uio[i] = uio_oe[i] ? uio_out[i] : 1'bz;
            assign uio_in[i] = uio[i];
        end
    endgenerate

    tt_um_toivoh_demo_tt10 i_project(
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .ena(1'b1),
        .clk(clk),
        .rst_n(rst_n)
    );

endmodule