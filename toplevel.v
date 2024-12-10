module toplevel(input clk, rst, rst2, start, input [15:0] input1, input2, output done, output [15:0] result);

    	wire input1_msb, input2_msb, up_co, down_co;
    	wire select, ld_sh1, ld_sh2, en_sh1, en_sh2, sh1_type, cnt_en, cnt_type;

    	datapath #(16) dp(clk, rst, select, ld_sh1, ld_sh2, en_sh1, en_sh2, sh1_type, cnt_en, cnt_type, input1, input2, result, input1_msb, input2_msb, up_co, down_co);

    	controller c(clk, rst, rst2, start, input1_msb, input2_msb, up_co, down_co, select, ld_sh1, ld_sh2, en_sh1, en_sh2, sh1_type, cnt_en, cnt_type, done);

endmodule