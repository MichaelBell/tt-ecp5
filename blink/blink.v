module blink (
    input      clk_i,
    output     led_o
);
    localparam MAX = 2_500_000;
    localparam WIDTH = $clog2(MAX);

    reg  [WIDTH-1:0] count = 0;
    reg  led = 0;

    always @(posedge clk_i) begin
        count <= count + 1;

        if (count == MAX) begin
            led <= ~led;
            count <= 0;
        end
    end

    assign led_o = led;
endmodule