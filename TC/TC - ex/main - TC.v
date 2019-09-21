
module tb_JK;
reg J,K,Clk,R,S;
wire Qout;

JK test(Qout,J,K,S,R,Clk);

initial
Clk = 0;
always
#1 Clk = ~Clk;
initial begin
J = 0;
K = 0;
R = 1;
S = 1;
#2;
R = 0;
#2;
R = 1;
S = 0;
#2;
S = 1;
#2;
J = 0;
K = 1;
#2;
J = 1;
K = 0;
#2;
J = 1;
K = 1;
end
endmodule

module sync_counter(Q, Switch, Setn, Resetn, Clock, NS, EW);
	input Switch, Setn, Resetn, Clock;
	output [2:0] Q;
output NS, EW;
	reg high;

	initial
		high = 1;

	JK jk2(Q[2], Q[0], 
			high,
			Setn, Resetn, Clock);
	JK jk1(Q[1], Q[2], Q[2], Setn, Resetn, Clock);
	JK jk0(Q[0], (Q[2] & Q[1]), high, Setn, Resetn, Clock);

JK ns(NS, high, high, Setn, Resetn, Q[2]);
assign EW = ~NS;

endmodule
