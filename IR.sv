//TCES 330 SPRING 2023
//Project - Jonathan/Conrad
//IR

module IR(Clk, IR_Id, Data, IRout);

input Clk, IR_Id;
input [15:0]Data;
output logic [15:0]IRout;

//always_ff @(posedge Clk) begin
always @* begin
	if (IR_Id) 
	  IRout <= Data;
	else
	  IRout <= IRout; 
	end
endmodule

module IR_tb();

logic Clk, IR_Id;
logic [15:0]Data;
logic [15:0]IRout;

IR DUT(Clk, IR_Id, Data, IRout);

always begin
 Clk = 0; #10;
 Clk = 1; #10;
end
	initial begin
	@(negedge Clk) IR_Id=0; //changing at falling edge
	@(posedge Clk) Data= 16'hffff; #5;
	@(negedge Clk) IR_Id=1; #20;
	@(negedge Clk) IR_Id=0;
	@(posedge Clk) Data= 16'haaaa; #5;
	@(negedge Clk) IR_Id=1; #20;
$stop; 
	end
initial $monitor($time,,,"IR_Id=%b Data=%b PCout=%b", IR_Id, Data, IRout);

endmodule