module Full_adder (input wire a, b, cin, output wire sum, cout);
    
	wire temp1, temp2, temp3;
    
    	XOR xor1(a, b, temp1);
    	XOR xor2(temp1, cin, sum);
    
    	AND and1(temp1, cin, temp2);
    	AND and2(a, b, temp3);

    	OR or1(temp2, temp3, cout);

endmodule

module adder #(parameter N) (input [N-1:0] a, b, input cin, output [N-1:0] sout, output cout);

    	wire [N:0] co; 
    	assign co[0] = cin;

    	genvar i;

   	generate
        	for (i = 0; i < N; i = i + 1) begin : adder_gen
            		Full_adder fulladder (a[i], b[i], co[i], sout[i], co[i + 1]);
        	end
    	assign cout = co[N];
    	endgenerate

endmodule

module counter (input clk, rst, en, type, output down_co, up_co, output [4:0] count_out);

    	wire [4:0] temp, next;
	wire temp2;  
    
    	genvar i;
    	generate
        	for (i = 0; i < 5; i = i + 1) begin : generator_reg
            		Register #(1) register (clk, rst, en, next[i], count_out[i]);
        	end
    	endgenerate
    
    	MUX_2_input #(5) mux (5'b1, 5'b11111, type, temp); 
    	adder #(5) add (count_out, temp, 1'b0, next, cout);

   	OR_5_input or1 (count_out[0], count_out[1], count_out[2], count_out[3], count_out[4], temp2);
    	NOT not1 (temp2, down_co);
    	AND_5_input and1 (count_out[0], count_out[1], count_out[2], count_out[3], count_out[4], up_co);

endmodule

module multiplier_1bit(input x_inp, y_inp, p_inp, c_inp, output p_out, c_out);
   
    	wire xy, and_sec_out, and_third_out, and_fourth_out, x_out_second;
    
    	AND and1(p_inp, xy, and_sec_out);
    	AND and2(x_inp, y_inp, xy);
    	AND and3(p_inp, c_inp, and_third_out);
    	AND and4(xy, c_inp, and_fourth_out);

    	XOR x_out_first(p_inp, xy, x_out_second);
    	XOR x_outr_sec(x_out_second, c_inp, p_out);

    	OR_3_input or_inst(and_sec_out , and_third_out, and_fourth_out, c_out);

endmodule

module shift_left_right_reg #(parameter N) (input clk, rst, ld, input [N-1:0] data_in, input ser_in, shift_en, shift_type, output [N-1:0] data_out, output c_out);

    	wire [N+1:0] shifted_input;
    	assign shifted_input[N + 1] = ser_in;
    	assign shifted_input[0] = ser_in;

    	wire reg_enable;
    	OR or1(shift_en, ld, reg_enable);
    
    	genvar i;

    	generate
        	for (i = 1; i < N + 1; i = i + 1) begin : gen_shift_reg
        		wire mux_out;
            		MUX_4_input #(1) mux4(shifted_input[i + 1], shifted_input[i - 1], data_in[i - 1], data_in[i - 1], {ld, shift_type}, mux_out);
            		Register #(1) reg_inst(clk, rst, reg_enable, mux_out, shifted_input[i]);
        	end
    	endgenerate

    	assign c_out = shifted_input[N];
    	assign data_out = shifted_input[N:1];
endmodule

module shift_left_reg #(parameter N) (input clk, rst, ld, ser_in, shift_en, input [N-1:0] data_in, output c_out, output [N-1:0] data_out);

        wire mux_out;
    	wire [N:0] shifted_input;
    	assign shifted_input[0] = ser_in;

    	wire reg_enable;
    	OR or1(shift_en, ld, reg_enable);
    
    	genvar i;

    	generate
        	for (i = 1; i < N + 1; i = i + 1) begin : gen_shift_reg
            		MUX_2_input #(1) mux2(shifted_input[i - 1], data_in[i - 1], ld, mux_out);
            		Register #(1) reg_inst(clk, rst, reg_enable, mux_out, shifted_input[i]);
        	end
    	endgenerate

    	assign c_out = shifted_input[N];
    	assign data_out = shifted_input[N:1];
endmodule

module array_mult #(parameter N = 8) (input [N-1:0] A, B, output [2 * N-1:0] P);

    	wire carry [N:0][N:0];
    	wire sum [N:0][N:0];

    	genvar i,j;

    	generate
        	for (i = 0; i < N; i = i + 1) begin : init
            		assign carry[i][0] = 1'b0; 
            		assign sum[0][i + 1] = 1'b0; 
            		assign sum[i + 1][N] = carry[i][N];
        	end
    	endgenerate

    	generate
        	for (i = 0; i < N; i = i + 1) begin : rows
            		for (j = 0; j < N; j = j + 1) begin : cols
                		multiplier_1bit mult (A[i], B[j], sum[i][j + 1], carry[i][j], sum[i + 1][j], carry[i][j + 1]);
            		end
        	end
    	endgenerate

    	generate
        	for (i = 0; i < N; i = i + 1) begin : outs
            		assign P[i] = sum[i + 1][0]; 
            		assign P[i + N] = sum[N][i + 1];
        	end
    	endgenerate

endmodule
