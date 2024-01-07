//TCES 330 SPRING 2023
//Project - Jonathan/Conrad
//Register

module Register(Aaddr, Baddr, Waddr, writeEn, Clock, WriteData, Adata, Bdata);

  input [3:0]Aaddr, Baddr, Waddr;
  input writeEn, Clock;
  input [15:0]WriteData;
  output logic [15:0]Adata, Bdata;
  
  bit [15:0] register [0:15];
  


    
   assign Adata = register[Aaddr];
   assign Bdata = register[Baddr];

  always_ff @ (posedge Clock) begin

    if (writeEn) begin  //if writing is ON
    
       register[Waddr] <= WriteData;
    
    end
  end
  
  
 endmodule
 
 
 
 module Register_tb();
  
  
    logic [3:0]Aaddr, Baddr, Waddr;
    logic  writeEn, Clock;
    logic [15:0]WriteData;
    logic [15:0]Adata, Bdata;
    
    bit [4:0] addrCounter;
    
    Register DUT (Aaddr, Baddr, Waddr, writeEn, Clock, WriteData, Adata, Bdata);
    
    // clock setup
    always begin
      Clock = 0; #10;
      Clock = 1; #10;
    end
    
    // memory load and read test
    initial begin
    
      // load values to mem
      writeEn = 1;
      Aaddr = 0;
      Baddr = 0;
      for (addrCounter = 0; addrCounter <= 4'b1111; addrCounter++) begin
        WriteData = addrCounter; Waddr = addrCounter; #40;
      end
      
      
      // read values from mem
      writeEn = 0;
      for (addrCounter = 0; addrCounter <= 4'b1111; addrCounter++) begin
        Aaddr = addrCounter; Baddr = addrCounter; #40;
        $display("Memory address A\[%d\] contains: %d", Aaddr, DUT.Adata);
        $display("Memory address B\[%d\] contains: %d", Baddr, DUT.Bdata);
        assert ((Aaddr == addrCounter) && (Baddr == addrCounter) && (DUT.Adata == addrCounter) && (DUT.Bdata == addrCounter)) $display("mem check good"); else $display("mem check FAILED");
      end
      
    
    $stop;
    end
   
  
  
endmodule
