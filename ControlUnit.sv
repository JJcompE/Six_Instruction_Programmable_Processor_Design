//TCES 330 SPRING 2023
//Project - Jonathan/Conrad
//Control unit

module ControlUnit(Clk, Reset, D_addr, RF_W_addr, RF_Ra_addr, RF_Rb_addr, Alu_s0, D_wr, RF_s, RF_W_en, StateOut, NextState, CU_IRout, CU_PC_out);

wire PCclr1;
wire PCup1, IR_Id1;
wire [6:0]PC_out1; 
wire [15:0]Data1, IRout1;

input Clk, Reset;
output [7:0] D_addr;
output [3:0] RF_W_addr, RF_Ra_addr, RF_Rb_addr;
output [2:0] Alu_s0;
output D_wr, RF_s, RF_W_en;

output [3:0]StateOut, NextState;

output logic [15:0] CU_IRout;
output logic[6:0] CU_PC_out;

PC PCunit0 (Clk, PCup1, PCclr1, PC_out1); //(Clk, PCup, PCclr, PC_out)
IR IRunit0 (Clk, IR_Id1, Data1, IRout1); //(Clk, IR_Id, Data, IRout);
ROM IMunit0 (PC_out1, Clk, Data1);//(address, clock, q)
ControlSM FSMunit0 (Clk, Reset, IRout1, StateOut, NextState, IR_Id1, D_addr, D_wr, RF_s, RF_W_addr, RF_W_en, RF_Ra_addr, RF_Rb_addr, Alu_s0, PCclr1, PCup1); 
//(Clk, Reset, IRout, StateOut, IR_Id, D_addr, D_wr, RF_s, RF_W_addr, RF_W_en, RF_Ra_addr, RF_Rb_addr, Alu_s0, PCclr, PCup);

always @* begin
  CU_IRout <= IRout1;
  CU_PC_out <= PC_out1;
end

endmodule
`timescale 1ns/1ns
module ControlUnit_tb();

logic Clk, Reset;
logic [7:0] D_addr;
logic [3:0] RF_W_addr, RF_Ra_addr, RF_Rb_addr;
logic [2:0] Alu_s0;
logic D_wr, RF_s, RF_W_en;

logic [3:0]StateOut;

ControlUnit DUT(Clk, Reset, D_addr, RF_W_addr, RF_Ra_addr, RF_Rb_addr, Alu_s0, D_wr, RF_s, RF_W_en, StateOut, NextState);

  always begin
    Clk = 0; #10;
    Clk = 1; #10;
  end

  initial begin
    Reset = 1; #40;
    Reset = 0; #900;
    $stop;
  end
  
  initial $monitor($time,,,"Reset=%d PC_out1=%h IRout1=%b D_addr=%d RF_W_addr=%d RF_Ra_addr=%d RF_Rb_addr=%d Alu_s0=%d D_wr=%d RF_s=%d RF_W_en=%d StateOut=%d NextState=%d", 
Reset,DUT.PC_out1, DUT.IRout1,D_addr,RF_W_addr,DUT.RF_Ra_addr,DUT.RF_Rb_addr,Alu_s0,D_wr,RF_s,RF_W_en,StateOut,NextState);

endmodule