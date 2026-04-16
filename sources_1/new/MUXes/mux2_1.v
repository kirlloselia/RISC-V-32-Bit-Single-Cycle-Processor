module mux2_1 #(
    parameter WIDTH = 32
) (
    input [WIDTH-1:0] A, B,
    input sel,
    output [WIDTH-1:0] result
);
    assign result = sel ? B : A;
endmodule