
`timescale 10ps/1ps

module tb_sync_counter;
	reg control, setn, resetn, clock; 
	wire [2:0] Q;
wire NS, EW;

	sync_counter test(Q, control, setn, resetn, clock, NS, EW);
 
	initial
	begin
		control <= 1;
		setn <= 0;
		resetn <= 1;
		clock <= 0;

		#1 setn <= 1;
		#20 control <= 0;
	end
 
	always
		#1 clock = ~clock;
endmodule
