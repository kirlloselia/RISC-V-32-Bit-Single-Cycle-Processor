module ADDER #(
    parameter WIDTH = 32
) (
    input signed [WIDTH-1:0] A, B,
    output signed [WIDTH-1:0] result
);
    assign result = A+B;
endmodule