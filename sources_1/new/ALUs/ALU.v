module ALU #(
    parameter WIDTH = 32
) (
    input signed [WIDTH-1:0] A, B,
    input [2:0] sel,
    output reg signed [WIDTH-1:0] result,
    output zero_flag
);
    assign zero_flag = ~| result;
    always @(*) begin
        case (sel)
            3'd0:   result = A+B;   // ADD 
            3'd1:   result = A-B;   // SUB
            3'd2:   result = A&B;   // AND
            3'd3:   result = A|B;   // OR
            3'd4:   result = A^B;   // XOR
            3'd5:   result = (A<B);   // SLT
            3'd6:   result = A<<B;   // SLL
            3'd7:   result = A>>B;   // SRL
            default: result = 0; 
        endcase
    end 
endmodule