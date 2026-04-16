module mux3_1 #(
    parameter WIDTH = 32
) (
    input [WIDTH-1:0] A, B, C,
    input [1:0] sel,
    output [WIDTH-1:0] result
);
    wire [WIDTH-1:0] res0;
    mux2_1 mux1 (.A(A), .B(B), .sel(sel[0]), .result(res0));
    mux2_1 mux2 (.A(res0), .B(C), .sel(sel[1]), .result(result));
endmodule