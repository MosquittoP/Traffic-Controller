
module mod13_counter(Q, Setn, Resetn, Clock); //mod-13 counter(6-2-3-2)
	input Setn, Resetn, Clock;
	output [3:0] Q;
	reg K;

	initial
		K = 1;
	
	JK_SR jk3(Q[3], Q[2] & Q[1] & Q[0], Q[2], Setn, Resetn, Clock);
	JK_SR jk2(Q[2], Q[1] & Q[0], Q[3] | (Q[1] & Q[0]), Setn, Resetn, Clock);
	JK_SR jk1(Q[1], Q[0], Q[0], Setn, Resetn, Clock);
	JK_SR jk0(Q[0], ~Q[3] | ~Q[2], K, Setn, Resetn, Clock);
endmodule


module JK_SR(Q, J, K, Setn, Resetn, Clock); // J-K FF (counter)
	input J, K, Setn, Resetn, Clock;
	output reg Q;

	always @(posedge Clock)
	begin
		if (Setn == 0)
			Q <= 1;
		else if (Resetn == 0)
			Q <= 0;
		else
			case ({J,K})
				{1'b0, 1'b0}: Q = Q;
				{1'b0, 1'b1}: Q = 1'b0;
				{1'b1, 1'b0}: Q = 1'b1;
				{1'b1, 1'b1}: Q = ~Q;
			endcase
	end
endmodule


module tc_mealy_TC3to3(count, NS_G, NS_Y, NS_R, EW_G, EW_Y, EW_R, Setn, Resetn, Clock, sensor); // 6-output Traffic Controller
	output reg NS_G, NS_Y, NS_R, EW_G, EW_Y, EW_R;
	output wire [3:0] count;
	input Setn, Resetn, Clock, sensor;
	parameter NS_G_EW_R = 2'b00, NS_Y_EW_R = 2'b01, NS_R_EW_G = 2'b10, NS_R_EW_Y = 2'b11; // 4 state (S0~S3)
	reg [1:0]ps; // present state
	reg [1:0]ns; // next state
	reg ts0;
	reg ts1; // counter 6
	reg ts2; // counter 3
	reg ts3; // counter 2
	reg reset;
	
	initial
	begin
		ps <= NS_G_EW_R;
	end
	
	mod13_counter counter(count, Setn, reset, Clock);

	always @(ps, sensor) // sensor
	begin
		if (sensor == 0 && NS_G == 1)
			reset <= 0;
		else
			reset <= 1;
	end
	always @(count)
	begin
		if (count == 4'b0101)
		begin
			ts0 <= 0;
			ts1 <= 1;
			ts2 <= 0;
			ts3 <= 0;
		end
		else if (count == 4'b0111)
		begin
			ts0 <= 0;
			ts1 <= 0;
			ts2 <= 0;
			ts3 <= 1;
		end
		else if (count == 4'b1010)
		begin
			ts0 <= 0;
			ts1 <= 0;
			ts2 <= 1;
			ts3 <= 0;
		end
		else if (count == 4'b1100)
		begin
			ts0 <= 0;
			ts1 <= 0;
			ts2 <= 0;
			ts3 <= 1;
		end
		else
			ts0 <= 1;
	end
	
	always @(ts0, ts1, ts2, ts3, ps) // Mealy machine
	begin
		if (ps == NS_G_EW_R) // S0
		begin
			if (ts1 == 1) // NS_G_EW_R & ts1 high - (S1)
			begin
				ns <= NS_Y_EW_R;
				NS_G <= 0;
				NS_Y <= 1;
				NS_R <= 0;
				EW_G <= 0;
				EW_Y <= 0;
				EW_R <= 1;
			end
			else
			begin
				ns <= NS_G_EW_R;
				NS_G <= 1;
				NS_Y <= 0;
				NS_R <= 0;
				EW_G <= 0;
				EW_Y <= 0;
				EW_R <= 1;
			end
		end
		else if (ps == NS_Y_EW_R) //S1
		begin
			if (ts3 == 1) // NS_Y_EW_R & ts3 high - (S2)
			begin
				ns <= NS_R_EW_G;
				NS_G <= 0;
				NS_Y <= 0;
				NS_R <= 1;
				EW_G <= 1;
				EW_Y <= 0;
				EW_R <= 0;
			end
			else
			begin
				ns <= NS_Y_EW_R;
				NS_G <= 0;
				NS_Y <= 1;
				NS_R <= 0;
				EW_G <= 0;
				EW_Y <= 0;
				EW_R <= 1;
			end
		end
		else if (ps == NS_R_EW_G) // S2
		begin
			if (ts2 == 1) // NS_R_EW_G & ts2 high - (S3)
			begin
				ns <= NS_R_EW_Y;
				NS_G <= 0;
				NS_Y <= 0;
				NS_R <= 1;
				EW_G <= 0;
				EW_Y <= 1;
				EW_R <= 0;
			end
			else
			begin
				ns <= NS_R_EW_G;
				NS_G <= 0;
				NS_Y <= 0;
				NS_R <= 1;
				EW_G <= 1;
				EW_Y <= 0;
				EW_R <= 0;
			end
		end
		else if (ps == NS_R_EW_Y) // S3
		begin
			if (ts3 == 1) // NS_R_EW_Y & ts3 high - (S0)
			begin
				ns <= NS_G_EW_R;
				NS_G <= 1;
				NS_Y <= 0;
				NS_R <= 0;
				EW_G <= 0;
				EW_Y <= 0;
				EW_R <= 1;
			end
			else
			begin
				ns <= NS_R_EW_Y;
				NS_G <= 0;
				NS_Y <= 0;
				NS_R <= 1;
				EW_G <= 0;
				EW_Y <= 1;
				EW_R <= 0;
			end
		end
	end

	always @(posedge Clock)
		ps <= ns;

endmodule

