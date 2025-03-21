module seven_seg (
    input        clk,
    output [7:0] uo_out
);
    localparam MAX = 10 * 1024 * 1024 * 8;
    localparam WIDTH = $clog2(MAX);

    reg  [WIDTH-1:0] count = 0;

    always @(posedge clk) begin
        count <= count + 1;

        if (count == MAX) begin
            count <= 0;
        end
    end

    Seg7 decoder(
        .value(count[WIDTH-1:WIDTH-4]),
        .seg_out(uo_out[6:0])
    );

    assign uo_out[7] = count[WIDTH-5];
endmodule
