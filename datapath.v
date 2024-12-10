module datapath #(parameter N)(input clk, rst, select, ld_sh1, ld_sh2, en_sh1, en_sh2, sh1_type, cnt_en, cnt_type, input [N-1:0] input1, input2,
                output [N-1:0] result, output input1_msb, input2_msb, up_co, down_co);

    	wire [N-1:0] input1_shifted, input2_shifted, mult_out, mux_out;

	wire temp;

    	shift_left_right_reg #(N) sh_reg1(clk, rst, ld_sh1, mux_out, 1'b0, en_sh1, sh1_type, input1_shifted, input1_msb);

    	shift_left_right_reg #(N) sh_reg2(clk, rst, ld_sh2, input2, 1'b0, en_sh2, 1'b1, input2_shifted, input2_msb);

	MUX_2_input #(N) mux_2(input1, mult_out, select, mux_out);

    	array_mult #(8) array_multiplierr(input1_shifted[N-1:N-8], input2_shifted[N-1:N-8], mult_out);

    	counter cnt(clk, rst, cnt_en, cnt_type, down_co, up_co, temp);

    	assign result = input1_shifted;

endmodule