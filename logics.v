module AND(input a1, a2, output out);
    	C1 and_2_logic (.A0(1'b0),.A1(a1),.SA(a2),.B0(),.B1(),.SB(),.S0(1'b0),.S1(1'b0),.F(out));
endmodule

module OR (input a1, a2, output out);
		C1 or_2_logic (.A0(a1), .A1(1'b1), .SA(a2), .B0(), .B1(), .SB(), .S0(1'b0), .S1(1'b0), .F(out));
endmodule

module NOT(input a, output out);
		C1 not_logic (.A0(1'b1), .A1(1'b0), .SA(a), .B0(), .B1(), .SB(), .S0(1'b0), .S1(1'b0), .F(out));
endmodule

module XOR(input a1, a2, output out);
    	C2 #(1) xor_2_logic(.D00(1'b0), .D01(1'b0), .D10(1'b1), .D11(1'b0), .A1(a1), .B1(a2), .A0(a1), .B0(a2), .out(out));
endmodule

module AND_3_input (input a1, a2, a3, output out);
    	C2 #(1) and_3_logic(.D00(1'b0), .D01(1'b0), .D10(1'b0), .D11(1'b1), .A1(1'b0), .B1(a1), .A0(a2), .B0(a3), .out(out));
endmodule

module AND_4_input (input a1, a2, a3, a4, output out);
    	C2 #(1) and_4_logic(.D00(1'b0), .D01(1'b0), .D10(1'b0), .D11(1'b1), .A1(a1), .B1(a2), .A0(a3), .B0(a4), .out(out));
endmodule

module OR_3_input (input a1, a2, a3, output out);
    	C2 #(1) or_3_logic (.D00(1'b0), .D01(1'b1), .D10(1'b1), .D11(1'b1), .A1(a1), .B1(a2), .A0(a3), .B0(1'b1), .out(out));
endmodule

module AND_5_input (input a1, a2, a3, a4, a5, output out);
    	wire temp;
    	AND_3_input and1(a1, a2, a3, temp);
    	AND_3_input and2(temp, a4, a5, out);
endmodule

module OR_5_input (input a1, a2, a3, a4, a5, output out);
    	wire temp;
    	OR_3_input or1(a1, a2, a3, temp);
    	OR_3_input or2(temp, a4, a5, out);
endmodule

module MUX_4_input #(parameter N = 1) (input [N-1:0] a1, a2, a3, a4, input [1:0] sel, output [N-1:0] mux_out);
    	C2 #(N) mux_4_logic (.D00(a1), .D01(a2), .D10(a3), .D11(a4), .A1(sel[1]), .A0(sel[0]), .B0(1'b1), .B1(1'b0), .out(mux_out));
endmodule

module MUX_2_input #(parameter N = 1) (input [N-1:0] a1, a2, input sel, output [N-1:0] mux_out);
    	C2 #(N) mux_2_logic (.D00(a1), .D01(a2), .D10(), .D11(), .A1(1'b0), .B1(1'b0), .A0(sel), .B0(1'b1), .out(mux_out));
endmodule

module Register #(parameter N = 1) (input clk, rst, en, input [N-1:0] reg_in, output wire [N-1:0] reg_out);
		S2 #(N) reg_logic (.D01(reg_in), .D10(), .D11(), .D00(reg_out), .A1(1'b0), .B1(1'b0), .A0(en), .B0(1'b1), .CLR(rst), .CLK(clk), .out(reg_out));
endmodule
