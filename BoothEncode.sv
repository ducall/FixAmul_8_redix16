module BoothEncode
(
  input        [4:0] iDat,
  output logic       oNegative,
  output logic [3:0] oBoothSel,
  output logic [3:0] oShiftSel
);
  wire b10Eq00   = ~(iDat[1] | iDat[0]);
  wire b10Eq00_n = ~b10Eq00;
  wire b10Eq11_n = ~(iDat[1] & iDat[0]);
  wire b10Eq11   =   iDat[1] & iDat[0];
  wire b10Xor    = b10Eq00_n & b10Eq11_n;  //find iDat[1:0] = 01,10  +1 +3 +5 +7 and -1 -3 -5 -7
  logic [3:0] b32Oh;
  always_comb begin
    unique case(iDat[3:2])
      2'b00   : b32Oh = 4'b0001;
      2'b01   : b32Oh = 4'b0010;
      2'b10   : b32Oh = 4'b0100;
      2'b11   : b32Oh = 4'b1000;
      default : b32Oh = 4'b0000;
    endcase
  end
  logic [8:1] factorVld;
  always_comb begin      //set num to onehot 
    factorVld[1] = (((~iDat[4]) & b32Oh[0]) | (iDat[4] & b32Oh[3])) & (b10Xor);  // find +1 and -1
    factorVld[2] = ((~iDat[4])&b32Oh[0]&b10Eq11) | ((~iDat[4])&b32Oh[1]&b10Eq00) // find +2 and -2
                  |(  iDat[4] &b32Oh[2]&b10Eq11) | (  iDat[4] &b32Oh[3]&b10Eq00);
    factorVld[3] = (((~iDat[4]) & b32Oh[1]) | (iDat[4] & b32Oh[2])) & (b10Xor);
    factorVld[4] = ((~iDat[4])&b32Oh[1]&b10Eq11) | ((~iDat[4])&b32Oh[2]&b10Eq00)
                  |(  iDat[4] &b32Oh[1]&b10Eq11) | (  iDat[4] &b32Oh[2]&b10Eq00);
    factorVld[5] = (((~iDat[4]) & b32Oh[2]) | (iDat[4] & b32Oh[1])) & (b10Xor);
    factorVld[6] = ((~iDat[4])&b32Oh[2]&b10Eq11) | ((~iDat[4])&b32Oh[3]&b10Eq00)
                  |(  iDat[4] &b32Oh[0]&b10Eq11) | (  iDat[4] &b32Oh[1]&b10Eq00);
    factorVld[7] = (((~iDat[4]) & b32Oh[3]) | (iDat[4] & b32Oh[0])) & (b10Xor);
    factorVld[8] = ((~iDat[4]) & b32Oh[3] & b10Eq11) | (iDat[4] & b32Oh[0] & b10Eq00);
  end                                  

  assign oNegative    = iDat[4] & ~(b32Oh[3] & b10Eq11);
  assign oBoothSel[0] = factorVld[1] | factorVld[2] | factorVld[4] | factorVld[8]; // For A1X
  assign oBoothSel[1] = factorVld[3] | factorVld[6];                               // For A3X
  assign oBoothSel[2] = factorVld[5];                                              // For A5X
  assign oBoothSel[3] = factorVld[7];                                              // For A7X

  assign oShiftSel[0] = factorVld[1] | factorVld[3] | factorVld[5] | factorVld[7]; // For booth data << 0
  assign oShiftSel[1] = factorVld[2] | factorVld[6];                               // For booth data << 1
  assign oShiftSel[2] = factorVld[4];                                              // For booth data << 2
  assign oShiftSel[3] = factorVld[8];                                              // For booth data << 3

endmodule : BoothEncode
