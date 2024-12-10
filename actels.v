module C1 (input A0, A1, SA, B0, B1, SB, S0, S1, output F);
	initial begin 
      		$system("c1.exe");
    	end

	wire F1, F2, S2;

	assign F1 = (SA) ? A1 : A0;
	assign F2 = (SB) ? B1 : B0;
	assign S2 = S0 | S1;
	assign F = (S2) ? F2 : F1;

endmodule

module C2 #(parameter N)(input[N-1:0] D00, D01, D10, D11,input  A1, B1, A0, B0, output[N-1:0]out);
	initial begin 
      		$system("c2.exe");
    	end

	wire S1, S0;

	assign S1 = A1 | B1;
	assign S0 = A0 & B0;
	assign out = ({S1, S0} == 2'b00) ? D00 :
			({S1, S0} == 2'b01) ? D01 :
			({S1, S0} == 2'b10) ? D10 :
			({S1, S0} == 2'b11) ? D11 : 2'bxx;
endmodule

module S1 #(parameter N)(input[N-1:0] D00, D01, D10, D11,input  A1, B1, A0, CLR, CLK,output reg[N-1:0] out);
 	initial begin 
      		$system("s2-s1.exe ");
    	end

	wire S1, S0;
	wire [N-1:0] muxout;

	assign S1 = A1 | B1;
	assign S0 = A0 & CLR;
	assign mux_out = ({S1, S0} == 2'b00) ? D00 :
			({S1, S0} == 2'b01) ? D01 :
			({S1, S0} == 2'b10) ? D10 :
			({S1, S0} == 2'b11) ? D11 : 2'bxx;

	always@(posedge CLK, posedge CLR)
	begin
		if(CLR)
			out <= 0;
		else
			out <= mux_out;
	end
endmodule

module S2 #(parameter N)(input[N-1:0] D00, D01, D10, D11, input A1, B1, A0, B0, CLR, CLK, output reg[N-1:0] out);
	initial begin 
      		$system("s2-s1.exe ");
    	end

	wire S1, S0;
	wire[N-1:0] mux_out;

	assign S1 = A1 | B1;
	assign S0 = A0 & B0;
	assign mux_out = ({S1, S0} == 2'b00) ? D00 :
			({S1, S0} == 2'b01) ? D01 :
			({S1, S0} == 2'b10) ? D10 :
			({S1, S0} == 2'b11) ? D11 : 2'bxx;

	always@(posedge CLK, posedge CLR)
	begin
		if(CLR)
			out <= 0;
		else
			out <= mux_out;
	end
endmodule