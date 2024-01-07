//TCES 330 SPRING 2023
//Project - Jonathan/Conrad
//Mux2to1




module Mux2to1(M, fromALU, fromRdata, S);

	input S;
	input [15:0] fromALU, fromRdata;
	output logic [15:0] M;
	
  always @* begin
  if (~S) 
    M <= fromALU;
  else 
    M <= fromRdata;
  end
	
  
  
  
  //assign M = (fromALU & ~S) | (S & fromRdata);
	
	endmodule
	
	/*
module Mux2to1_tb;
	
    logic S;
	  logic [15:0] fromALU, fromRdata;
	  logic [15:0] M;
  
  
  Mux2to1 DUT (M, fromALU, fromRdata, S);
  
	initial begin;
	
  
  
	  for (int k=0; k<8; k++) begin
	  {X, Y, S}=k;
	  #10;
	  end
	end
	
	initial begin
	$monitor("S= %b\t X= %b\t Y= %b\t M= %b\t", S, X, Y, M);
	end
endmodule
*/

  