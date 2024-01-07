//TCES 330 SPRING 2023
//Project - Jonathan/Conrad
//DE2 Test - Project

`timescale 1 ns / 1 ps 
module Project(CLOCK_50, SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, StateOut);
    
   // changing to DE2 control 
  //logic Clk;             // system clock
  //logic Reset;           // system reset
  
  
	input CLOCK_50;
  input [2:1]KEY;  
  input [17:15]SW;  
  output [0:6]HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
  logic [15:0] IR_Out;   // instruction register
  logic [6:0] PC_Out;    // program counter
  output [3:0] StateOut;
  wire [3:0] NextState;        // state machine state, next state
  logic [15:0] ALU_A, ALU_B, ALU_Out;  // ALU inputs and output 
  bit [2:0] DisplayState; // for controling the hex displays
  bit [3:0] hexout1, hexout2, hexout3, hexout4;
  
 
 
  //Processor DUT( Clk, Reset, IR_Out, PC_Out, State, NextState, ALU_A, ALU_B, ALU_Out );
  Processor DUT( KEY[2], KEY[1], IR_Out, PC_Out, StateOut, NextState, ALU_A, ALU_B, ALU_Out );
  
  

  // generate 50 MHz clock
  /*
  always begin
    Clk = 0;
    #10;
    Clk = 1'b1;
    #10;
  end
  */
  

  
  always @* begin
  
    DisplayState = { SW[17], SW[16], SW[15] };
    
    case (DisplayState) 
    
      default: begin
      
        hexout1 <= PC_Out[6:4];
        hexout2 <= PC_Out[3:0];
        hexout3 <= 4'b0;
        hexout4 <= StateOut;
      
      end
      1: begin
      
        hexout1 <= ALU_A[15:12];
        hexout2 <= ALU_A[11:08];
        hexout3 <= ALU_A[07:04];
        hexout4 <= ALU_A[03:00];
      
      end
      2: begin
      
         hexout1 <= ALU_B[15:12];
         hexout2 <= ALU_B[11:08];
         hexout3 <= ALU_B[07:04];
         hexout4 <= ALU_B[03:00];
         
      end
      3: begin
      
        hexout1 <= ALU_Out[15:12];
        hexout2 <= ALU_Out[11:08];
        hexout3 <= ALU_Out[07:04];
        hexout4 <= ALU_Out[03:00];
        
      end
      4: begin
      
        hexout1 <= 4'b0;
        hexout2 <= 4'b0;
        hexout3 <= 4'b0;
        hexout4 <= NextState[03:00];
        
      end
    endcase
  end
  
        Decoder(HEX7[0:6], hexout1);
        Decoder(HEX6[0:6], hexout2);
        Decoder(HEX5[0:6], hexout3);
        Decoder(HEX4[0:6], hexout4);
        
        Decoder(HEX3[0:6], IR_Out[15:12]);
        Decoder(HEX2[0:6], IR_Out[11:08]);
        Decoder(HEX1[0:6], IR_Out[07:04]);
        Decoder(HEX0[0:6], IR_Out[03:00]);

/* test from different module
initial	// Test stimulus
  begin
    $display( "\nBegin Simulation." );
    Reset = 0;         // reset for one clock
    @ ( posedge Clk ) 
    #10 Reset = 1;
    wait( IR_Out == 16'h5000 );  // halt instruction
    $display( "\nEnd of Simulation.\n" );
    $stop;
  end
  
initial begin
    $monitor( "Time is %0t : Reset = %b   PC_Out = %h   IR_Out = %h  State = %h  ALU A = %h  ALU B = %h ALU Out = %h", $stime, Reset, PC_Out, IR_Out, State, ALU_A, ALU_B, ALU_Out );
   
end
*/


endmodule    



                           





/* OLD
module Processor ( Clk, Reset, IR_Out, PC_Out, State, NextState, ALU_A, ALU_B, ALU_Out, StateOut );
  input Clk;             // system clock
  input Reset;           // system reset
  output [15:0] IR_Out;   // instruction register
  output [6:0] PC_Out;    // program counter
  output [3:0] State, StateOut, NextState;        // state machine state, next state
  output [15:0] ALU_A, ALU_B, ALU_Out;  // ALU inputs and output 

assign Stateout = State;

wire [7:0] D_addr_wire;
wire [3:0] RF_W_addr_wire, RF_Ra_addr_wire, RF_Rb_addr_wire;
wire [2:0] Alu_s0_wire;
wire D_wr_wire, RF_W_en_wire, RF_s_wire;
 
ControlUnit control (Clk, Reset, D_addr_wire, RF_W_addr_wire, RF_Ra_addr_wire, RF_Rb_addr_wire, Alu_s0_wire, D_wr_wire, RF_s_wire, RF_W_en_wire, StateOut, NextState);
//(Clk, Reset, D_addr, RF_W_addr, RF_Ra_addr, RF_Rb_addr, Alu_s0, D_wr, RF_s, RF_W_en, StateOut);

Datapath data (Clk, D_wr_wire, D_addr_wire, RF_s_wire, RF_Ra_addr_wire,  RF_Rb_addr_wire, RF_W_addr_wire, RF_W_en_wire, Alu_s0_wire); 
//(Clock, dmWriteEn, dmAddr, MuxS, regAaddr,  regBaddr, regWaddr, regWriteEn, aluSel);

assign IR_Out = control.IRout1;
assign PC_Out = control.PC_out1;
assign State = control.StateOut;
assign NextState = control.NextState;
assign ALU_A = data.regAdata;
assign ALU_B = data.regBdata;
assign ALU_Out = data.aluQ;


endmodule


`timescale 1 ns / 1 ps
module testProcessor_tb();
 
  logic Clk;             // system clock
  logic Reset;           // system reset
  logic [15:0] IR_Out;   // instruction register
  logic [6:0] PC_Out;    // program counter
  logic [3:0] State, NextState;        // state machine state, next state
  logic [15:0] ALU_A, ALU_B, ALU_Out;  // ALU inputs and output 
 
  Processor DUT( Clk, Reset, IR_Out, PC_Out, State, NextState, ALU_A, ALU_B, ALU_Out );

  // generate 50 MHz clock
  always begin
    Clk = 0;
    #10;
    Clk = 1'b1;
    #10;
  end

initial	// Test stimulus
  begin
    $display( "\nBegin Simulation." );
    Reset = 1;         // reset for one clock
    @ ( posedge Clk ) 
    #10 Reset = 0;
    //wait( IR_Out == 16'h5000 );  // halt instruction
    wait( DUT.control.IRout1 == 16'h5000 );  // halt instruction
    $display( "\nEnd of Simulation.\n" );
    $stop;
  end
  
initial begin
    $monitor( "Time is %0t : Reset = %b   PC_Out = %h   IR_Out = %h  State = %h  ALU A = %h  ALU B = %h ALU Out = %h", $stime, Reset, PC_Out, IR_Out, State, ALU_A, ALU_B, ALU_Out );
   
end


endmodule    

*/

                           