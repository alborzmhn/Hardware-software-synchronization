module controller (input clk, rst, rst2, start, input1_msb, input2_msb, co_up, co_down, output select, ld_sh1, ld_sh2, en_sh1, en_sh2, sh_type, cnt_en, cnt_type, done);

        wire [9:0] temp;

	wire state_idle, state_init, state_input1, state_shift1, state_input2, state_shift2, state_mult, state_result_shift, state_downcount
	, state_done;   

        wire idle_wire, start_rise, start_fall;
        wire first_val, sec_val, third_val, mult_res;
        wire not_start, not_input1_msb, not_input2_msb, not_co_up, not_co_down;

        // STATE: IDLE
        AND and_idle(not_start, temp[0], idle_wire);
        OR_3_input or_idle(temp[9], rst, idle_wire, state_idle);
        Register reg_idle(clk, rst2, 1'b1, state_idle, temp[0]);
        
        // STATE: INIT
        AND and_init1(temp[0], start, start_rise);
        AND and_init2(temp[1], start, start_fall);
        OR or_init(start_rise, start_fall, state_init);
        Register reg_init(clk, rst, 1'b1, state_init, temp[1]);

        // STATE: INPUT1
        AND and_input1(temp[1], not_start, first_val);
        OR or_input1(first_val, temp[3], state_input1);
        Register reg_input1(clk, rst, 1'b1, state_input1, temp[2]);

        // STATE: SHIFT1
        AND_3_input and_shift1(temp[2], not_input1_msb, not_co_up, state_shift1);
        Register reg_shift1(clk, rst, 1'b1, state_shift1, temp[3]);

        // STATE: INPUT2
        AND and_input2(temp[2], sec_val, third_val);
        OR or_input21(input1_msb, co_up, sec_val);
        OR or_input22(third_val, temp[5], state_input2);
        Register reg_input2(clk, rst, 1'b1, state_input2, temp[4]);

        // STATE: SHIFT2
        AND_3_input and_shift2(temp[4], not_input2_msb, not_co_up, state_shift2);
        Register reg_shift2(clk, rst, 1'b1, state_shift2, temp[5]);

        // STATE: MULT
        AND and_mult(temp[4], mult_res, state_mult);
        OR or_mult(input2_msb, co_up, mult_res);
        Register reg_mult(clk, rst, 1'b1, state_mult, temp[6]);

        // STATE: RESULT SHIFT
        OR or_result_shift(temp[6], temp[8], state_result_shift);
        Register reg_result_shift(clk, rst, 1'b1, state_result_shift, temp[7]);

        // STATE: DOWNCOUNT
        AND and_downcount(temp[7], not_co_down, state_downcount);
        Register reg_downcount(clk, rst, 1'b1, state_downcount, temp[8]);

        // STATE: DONE
        AND and_done(temp[7], co_down, state_done);
        Register reg_done(clk, rst, 1'b1, state_done, temp[9]);

        NOT not1(start, not_start);
        NOT not2(input1_msb, not_input1_msb);
        NOT not3(input2_msb, not_input2_msb);
        NOT not4(co_up, not_co_up);
        NOT not5(co_down, not_co_down);

        assign select = temp[6];
        OR ld_shl_value(temp[6], temp[1], ld_sh1);
        assign ld_sh2 = temp[1];
        OR en_shl_value(temp[3], temp[8], en_sh1);
        assign en_sh2 = temp[5];
        assign sh_type = temp[3];
        OR_3_input cnt_en_value(temp[3], temp[5], temp[8], cnt_en);
        assign cnt_type = temp[8];
        assign done = temp[9];
endmodule

module controller2 (input clk, rst, start, msb_A, msb_B, co_up, co_down, output reg sel, ld1, ld2, en_sh1, en_sh2, sh_dir, en_cn1, cnt_dir, done);
	parameter [3:0] A = 0, B = 1, C = 2, D = 3, E = 4, F = 5, G = 6, H = 7, I = 8, J = 9;
	reg [3:0] ns, ps;

    	always @(posedge clk, posedge rst) begin
        	if (rst)
            		ps <= A;
        	else
            		ps <= ns;
    	end

    	always @(ps, start, msb_A, msb_B, co_up, co_down) begin
		case (ps)
	    		A: ns = (start == 1'b1) ? B : A;
            		B: ns = (start == 1'b1) ? B : C;
            		C: ns = (~msb_A && (~co_up)) ? D : (msb_A || co_up) ? E : C;
            		D: ns = C;
	    		E: ns = (~msb_B && (~co_up)) ? F : (msb_B || co_up) ? G : E;
            		F: ns = E;
            		G: ns = H;
            		H: ns = (~co_down) ? I : J;
	    		I: ns = H;
            		J: ns = A;
	    		default: ns = A;
		endcase
    	end

    	always @(ps) begin
		{sel, ld1, ld2, en_sh1, en_sh2, sh_dir, en_cn1, cnt_dir, done} = 9'b0;
		case (ps)
	    		A: ;
            		B: {ld1, ld2} = 2'b11;
            		C: ;
            		D: {sh_dir, en_cn1, en_sh1} = 3'b111;
	    		E: ;
            		F: {en_cn1, en_sh2} = 2'b11;
            		G: {ld1, sel} = 2'b11;
            		H: ;
	    		I: {cnt_dir, en_cn1, en_sh1} = 3'b111;
            		J: done = 1'b1;
			default:;
		endcase
	end
endmodule