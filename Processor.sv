//TCES 330 SPRING 2023
//Project - Jonathan/Conrad
//Processor

  
module Processor( Clk, Reset, IR_Out, PC_Out, StateOut, NextState, ALU_A, ALU_B, ALU_Out);


  input Clk; // processor clock
  input Reset; // system reset
  output logic [15:0] IR_Out; // Instruction register
  output logic [7:0] PC_Out; // Program counter
  output [3:0] StateOut; // FSM current state
  output [3:0] NextState; // FSM next state (or 0 if you don’t use one)
  output logic [15:0] ALU_A; // ALU A-Side Input
  output logic [15:0] ALU_B; // ALU B-Side Input
  output logic [15:0] ALU_Out; // ALU current output
  
  
  wire [7:0] D_addr_wire;
  wire [3:0] RF_W_addr_wire, RF_Ra_addr_wire, RF_Rb_addr_wire;
  wire [2:0] Alu_s0_wire;
  wire D_wr_wire, RF_W_en_wire, RF_s_wire;
  
  
  wire [15:0] CU_IRout; 
  wire [6:0] CU_PC_out; 
  //wire [3:0] CU_StateOut, CU_NextState;
   
  ControlUnit control (Clk, ~Reset, D_addr_wire, RF_W_addr_wire, RF_Ra_addr_wire, RF_Rb_addr_wire, Alu_s0_wire, D_wr_wire, RF_s_wire, RF_W_en_wire, StateOut, NextState, CU_IRout, CU_PC_out);
  //(Clk, Reset, D_addr, RF_W_addr, RF_Ra_addr, RF_Rb_addr, Alu_s0, D_wr, RF_s, RF_W_en, StateOut);

  Datapath data (Clk, D_wr_wire, D_addr_wire, RF_s_wire, RF_Ra_addr_wire,  RF_Rb_addr_wire, RF_W_addr_wire, RF_W_en_wire, Alu_s0_wire, DP_RegA, DP_RegB, DP_aluQ); 
  //(Clock, dmWriteEn, dmAddr, MuxS, regAaddr,  regBaddr, regWaddr, regWriteEn, aluSel);

always @* begin
   IR_Out <= CU_IRout;
   PC_Out <= CU_PC_out;
   ALU_A <= DP_RegA;
   ALU_B <= DP_RegB;
   ALU_Out <= DP_aluQ;
end
 

endmodule


/* OLD
module Project(CLOCK_50, SW, KEY, HEX0, HEX1, HEX2, HEX4, HEX5, HEX6, HEX7, StateOut);
    
    
	input CLOCK_50;
  input [17:0]SW;
  input [3:0]KEY;  
  output [0:6]HEX0, HEX1, HEX2, HEX4, HEX5, HEX6, HEX7;
  output [3:0]StateOut;
  
  logic D_wr, RF_s, RF_W_en;
  logic [7:0] D_addr;
  logic [3:0] RF_W_addr, RF_Ra_addr, RF_Rb_addr;
  logic [2:0] Alu_s0;
  
 //Reset; - which switch links to reset? using SW[1] for now?
  //module ControlUnit(Clk, Reset, D_addr, RF_W_addr, RF_Ra_addr, RF_Rb_addr, Alu_s0, D_wr, RF_s, RF_W_en, StateOut);
ControlUnit controlModule(CLOCK_50, SW[1], D_addr, RF_W_addr, RF_Ra_addr, RF_Rb_addr, Alu_s0, D_wr, RF_s, RF_W_en, StateOut);
  
  //module Datapath(Clock, dmWriteEn, dmAddr, MuxS, regAaddr,  regBaddr, regWaddr, regWriteEn, aluSel);
Datapath dataModule (CLOCK_50, D_wr, D_addr, RF_s, RF_Ra_addr,  RF_Rb_addr, RF_W_addr, RF_W_en, Alu_s0);
  */