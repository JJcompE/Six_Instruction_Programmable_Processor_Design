//TCES 330 SPRING 2023
//Project - Jonathan/Conrad
//Control State Machine

module ControlSM (Clk, Reset, IRout, StateOut, NextState, IR_Id, D_addr, D_wr, RF_s, RF_W_addr, RF_W_en, RF_Ra_addr, RF_Rb_addr, Alu_s0, PCclr, PCup);

input Clk, Reset;
input [15:0]IRout;
output logic [7:0] D_addr;
output logic [3:0] RF_W_addr, RF_Ra_addr, RF_Rb_addr;
output logic [2:0] Alu_s0;
output logic D_wr, RF_s, RF_W_en, PCclr, PCup, IR_Id;

output [3:0]StateOut; //for monitoring outputs
output logic [3:0] NextState;

logic [3:0]CurrentState;
assign StateOut = CurrentState;

bit [3:0] operation;
assign operation = IRout[15:12]; //partition instruction to determine operation

localparam A=4'd0, B=4'd1, C=4'd2, D=4'd3, E=4'd4, F=4'd5, G=4'd6, H=4'd7, I=4'd8, J=4'd9;
// A=Init, B=Fetch, C=Decode, D=NOOP, E=Load A, F=Load B, G=Store, H=Add, I=Sub, J=Halt

always_comb begin //condition checking for state
       NextState<=B;
       D_addr<=8'd0; D_wr<=1'd0; RF_s<=1'd0; RF_W_addr<=4'd0; RF_W_en<=1'd0; RF_Ra_addr<=4'd0; RF_Rb_addr<=4'd0; Alu_s0<=3'd2; PCup<=1'd0; IR_Id<=1'd0; PCclr<=1'd0;
		
	case (CurrentState)
  default: begin
        NextState<=B;
        D_addr<=8'd0; D_wr<=1'd0; RF_s<=1'd0; RF_W_addr<=4'd0; RF_W_en<=1'd0; RF_Ra_addr<=4'd0; RF_Rb_addr<=4'd0; Alu_s0<=3'd2; PCup<=1'd0; IR_Id<=1'd0; PCclr<=1'd0;
		 end
	 A: begin 
        $display("A State");	
        PCclr<=1; 
	    	NextState <= B;
	    end
	 B: begin
      $display("B State");	
	    PCup<=1'd1; IR_Id<=1'd1; PCclr<=1'd0;
	    	NextState <= C;
	    end
	 C: begin
      $display("C State");	
	     case (operation) // A=Init, B=Fetch, C=Decode, D=NOOP, E=Load A, F=Load B, G=Store, H=Add, I=Sub, J=Halt
        4'b0000: NextState <= D;
        4'b0001: NextState <= G; 
        4'b0010: NextState <= E;
	    	4'b0011: NextState <= H;
	    	4'b0100: NextState <= I;
	    	4'b0101: NextState <= J; 
		//default: NextState = CurrentState;
	     endcase
	    end
	 D: begin
      $display("D State");	
	    NextState<=B;
	    end
	 E: begin 
      $display("E State");	
	    D_addr<=IRout[11:4]; RF_s<=1; RF_W_addr<=IRout[3:0]; PCclr<=1'd0;  
	   	NextState <= F;
	    end
	 F: begin
      $display("F State");	
      $display("IRout[11:8]: %b", IRout[11:8]);	
	    D_addr<=IRout[11:4]; RF_s<=1; RF_W_addr<=IRout[3:0]; RF_W_en<=1; PCclr<=1'd0; IR_Id<=1'd0;
	    	NextState <= B;
	    end
	 G: begin
      $display("G State");	
      $display("IRout[11:8]: %b", IRout[11:8]);	
	      RF_Ra_addr<=IRout[11:8]; D_addr<=IRout[7:0]; D_wr<=1;
	    	NextState <= B;
	    end
	 H: begin
      $display("H State");	
	    RF_W_addr<=IRout[3:0]; RF_W_en<=1; RF_Ra_addr<=IRout[11:8]; RF_Rb_addr<=IRout[7:4];
	    Alu_s0<=3'd0; RF_s<=0;
	    	NextState <= B;
	    end
	 I: begin
      $display("I State");	
	    RF_W_addr<=IRout[3:0]; RF_W_en<=1; RF_Ra_addr<=IRout[11:8]; RF_Rb_addr<=IRout[7:4];
	    Alu_s0<=3'd1; RF_s<=0;
	    	NextState <= B;
	    end 
	 J: begin
      $display("J State");	
	    NextState<=J; 
		end
	 endcase
end

always_ff @(posedge Clk) begin
	if (Reset)
	  CurrentState <= A;
	else
	  CurrentState <= NextState; 
	end
endmodule

module ControlSM_tb();

logic Clk, Reset;
logic [15:0]IRout;
logic [7:0] D_addr;
logic [3:0] RF_W_addr, RF_Ra_addr, RF_Rb_addr;
logic [2:0] Alu_s0;
logic D_wr, RF_s, RF_W_en, PCclr, PCup, IR_Id;

logic [3:0]StateOut;

	ControlSM DUT(Clk, Reset, IRout, StateOut, NextState, IR_Id, D_addr, D_wr, RF_s, RF_W_addr, RF_W_en, RF_Ra_addr, RF_Rb_addr, Alu_s0, PCclr, PCup);
	always begin  // 50 MHz Clock
	  Clk = 0;	#10;
	  Clk = 1;   #10;
	end
  
  initial begin
    Reset = 1; #40;
    Reset = 0; IRout=16'h3def; #100;
    $stop;
  end
  
  initial $monitor("oper= %h IRout=%h D_addr=%h D_wr=%h RF_s=%h RF_W_addr=%h RF_W_en=%h RF_Ra_addr=%h RF_Rb_addr=%h Alu_s0=%h PCclr=%h PCup=%h State=%h NextState=%h IR_Id=%h", DUT.operation, IRout, D_addr, D_wr, RF_s, RF_W_addr, RF_W_en, RF_Ra_addr, RF_Rb_addr, Alu_s0, PCclr, PCup, StateOut, NextState, IR_Id);
endmodule