`timescale 10ps/1ps

module tb_TC3to3;
	reg setn, resetn;
	reg clock, sensor;
	wire NS_G, NS_Y, NS_R, EW_G, EW_Y, EW_R;
	wire [3:0] Q; // counter Q

	tc_mealy_TC3to3 TC(Q, NS_G, NS_Y, NS_R, EW_G, EW_Y, EW_R, setn, resetn, clock ,sensor); // TC

	initial
	begin 
		sensor <= 1; 
		clock <= 0;
		setn <= 0; 
		resetn <= 1;

		#1 setn <= 1;
		#18 sensor <= 0; // sensor
		#30 sensor <= 1; 
	end

	always
		#1 clock = ~clock;
endmodule


