//TCES 330 SPRING 2023
//Project - Jonathan/Conrad
//ALU

module ALU(A, B, S, Q);
	input [15:0] A, B;
	input [2:0]S;
	output logic [15:0]Q;

	always @* begin
	 case (S)
	  0: Q =(A+B);
	  1: Q =(A-B);
	  2: Q =(A);
	  3: Q =(A^B);
	  4: Q =(A|B);
	  5: Q =(A&B);
	  6: Q =(A+1'b1);
	 endcase
	end
endmodule
//testbench
module ALU_tb();
	logic [15:0] A, B;
	logic [2:0]S;
	logic [15:0]Q;

	ALU DUT (A, B, S, Q);

	initial begin
	 A=100; B=100; S=0; #10;
	  assert (Q==A+B) $display("Confirm"); else $display("Fail");
	 A=100; B=100; S=1; #10;
	  assert (Q==A-B) $display("Confirm"); else $display("Fail");
	 A=100; B=100; S=2; #10;
	  assert (Q==A) $display("Confirm"); else $display("Fail");
	 A=100; B=100; S=3; #10;
	  assert (Q==A^B) $display("Confirm"); else $display("Fail");
	 A=100; B=100; S=4; #10;
	  assert (Q==A|B) $display("Confirm"); else $display("Fail");
	 A=16'd7; B=16'd3; S=5; #10;
	  assert (Q==(A&B)) $display("Confirm"); else $display("Fail");
	 A=100; B=100; S=6; #10;
	  assert (Q==A+1'b1) $display("Confirm"); else $display("Fail");
	end
endmodule