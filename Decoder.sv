//TCES 330
//4/22/23
//Conrad Motis
//Decorder.sv
//Binary to Decimal Converter


module Decoder(Hex, S);

    output logic [0:6]Hex;
    input logic [3:0]S;

    always @(S)
      case(S)
      0: Hex = 7'b0000001;
      1: Hex = 7'b1001111;
      2: Hex = 7'b0010010;
      3: Hex = 7'b0000110;
      4: Hex = 7'b1001100;
      5: Hex = 7'b0100100;
      6: Hex = 7'b0100000;
      7: Hex = 7'b0001111;
      8: Hex = 7'b0000000;
      9: Hex = 7'b0000100;
      10: Hex = 7'b0001000;
      11: Hex = 7'b1100000;
      12: Hex = 7'b0110001;
      13: Hex = 7'b1000010;
      14: Hex = 7'b0110000;
      15: Hex = 7'b0111000;
    endcase   

endmodule
