//TCES 330 SPRING 2023
//Project - Jonathan/Conrad
//Datapath

module Datapath(Clock, dmWriteEn, dmAddr, MuxS, regAaddr,  regBaddr, regWaddr, regWriteEn, aluSel, DP_RegA, DP_RegB, DP_aluQ);

  // master clock
  input Clock;
  
  // DataMem/RAM Variables
  input dmWriteEn;
  input [7:0]dmAddr;
  wire [15:0]dmRdata; //read-out data
  

  // Mux variables
	input MuxS;  // mux select
	wire [15:0] MuxM;  // mux output
  
  // Register variables
  input [3:0]regAaddr, regBaddr, regWaddr;
  input regWriteEn;
  wire [15:0]regAdata, regBdata;
  output logic [15:0]DP_RegA, DP_RegB, DP_aluQ;
  
  // ALU Variables
  input [2:0] aluSel;
  wire [15:0]aluQ;

  
  //          DataMem(Addr, writeEn, Clock, WriteData, Rdata);
  //DataMem unitDataMem (DMAddr, DMwriteEn, Clock, regAdata, dmRdata);
  
  //     module RAM (address, clock, data, wren, q);
  RAM unitDataMem (dmAddr, Clock, regAdata, dmWriteEn, dmRdata);
  
  //         Mux2to1(M, fromALU, fromRdata, S);
  Mux2to1 unitMux(MuxM, aluQ, dmRdata, MuxS);

  //           Register(Aaddr, Baddr, Waddr, writeEn, Clock, WriteData, Adata, Bdata);
  Register unitReg(regAaddr, regBaddr, regWaddr, regWriteEn, Clock, MuxM, regAdata, regBdata);
  
  //           module ALU(A, B, S, Q);
  ALU unitALU (regAdata, regBdata, aluSel, aluQ);
  
  always @* begin
    DP_RegA <= regAdata;
    DP_RegB <= regBdata;
    DP_aluQ <= aluQ;
    end


endmodule

`timescale 1ns/1ns
module Datapath_tb();

  logic Clock;
  
  logic dmWriteEn;
  logic [7:0]dmAddr;
	logic MuxS;
  logic [3:0]regAaddr, regBaddr, regWaddr;
  logic regWriteEn;
  logic [2:0] aluSel;


   Datapath DUT (Clock, dmWriteEn, dmAddr, MuxS, regAaddr,  regBaddr, regWaddr, regWriteEn, aluSel);

  // run clock
  always begin
    Clock = 0; #10;
    Clock = 1; #10;
  end
  
  /*
  // write to datamem test
  dmWriteEn = 1'd1;  // enable datamem writing
  dmAddr = 8'd0;       // init to address 0
  
  regWriteEn = 1'd1; // enable register writing
  regAaddr = 4'd0;    // init all addresses to 0
  regBaddr = 4'd0;
  regWaddr = 4'd0;
  */
  
  
  
  // example from class time
  // testing to implement RF[10] = RF[2] + RF[3]
  initial begin
  
    //setup registers 
    //regAdata = 1'b0; regBdata = 1'b0;
    dmWriteEn = 1'b0;
    regWriteEn = 1'b1;
    regAaddr = 4'd0;
    regBaddr = 4'd1;
    aluSel = 3'b0;
    MuxS = 1'd1;
    
    
    //dmWriteEn = 1'b1; dmAddr=4'd2; #40;      //  set register 2            DUT.dmRdata = 16'd10; 
    dmWriteEn = 1'b0; dmAddr=4'd0; #60;      //  set register 2            DUT.dmRdata = 16'd10; 
    dmWriteEn = 1'b0; dmAddr=4'd1; #60;      //  set register 3            DUT.dmRdata = 16'd20; 
    dmWriteEn = 1'b0; dmAddr=4'd2;  #60;  //  set register 10           DUT.dmRdata = 16'd100;
    
    // do the math
    regAaddr = 4'd2;
    regBaddr = 4'd3;
    regWaddr = 4'd10;
    #100;
    $stop;
  end
  
  initial $monitor($time,,, dmWriteEn,,, dmAddr,,, regAaddr,,, regBaddr,,, MuxS,,, DUT.MuxM,,, );
  
  
  
  
endmodule