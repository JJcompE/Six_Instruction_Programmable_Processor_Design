//TCES 330 SPRING 2023
//Project - Jonathan/Conrad
//PC

module PC(Clk, PCup, PCclr, PC_out);

input Clk, PCup, PCclr;
output logic [6:0] PC_out;

	always_ff @(posedge Clk) begin
	 if (PCclr) begin
	  PC_out <= 7'd0;
	 end
	 else if (PCup) begin
	   PC_out <= PC_out+7'd1;
	 end
	 else PC_out <= PC_out;
	end

endmodule
//testbench
`timescale 1ns/1ns

module PC_tb();

logic Clk, PCup, PCclr;
logic [6:0] PC_out;

PC DUT (Clk, PCup, PCclr, PC_out);
	always begin
	 Clk = 0; #10;
	 Clk = 1; #10;
	end
	initial begin
	@(negedge Clk) PCclr=1; PCup=0; //changing at falling edge
	@(posedge Clk) #5;
	 assert (PC_out == 7'd0);
	@(negedge Clk) PCup=1;
	 assert (PC_out == 7'd0);
	@(negedge Clk) PCclr=0;
	@(posedge Clk) #5; //counter incrementing now
	 //assert (PCout == 7'd1);
	PCclr=0; #500;
	PCclr=1; #50;
	
$stop; 
	end
initial $monitor($time,,,"Clr=%b PCup=%b PCout=%d",PCclr,PCup,PC_out);

endmodule