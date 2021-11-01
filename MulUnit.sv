
module MulUnit
(
  input               clk, rst,
  input        [ 7:0] iMulDat, //equal B
  input        [ 7:0] iDat1X,
  input        [ 9:0] iDat3X,
  input        [10:0] iDat5X,
  input        [10:0] iDat7X,
  output logic [15:0] oDat
);

  logic [7:0] dat;
  EnReg #(8) U_DatInput(clk,rst,1'b1,iMulDat,dat);
  
  logic [1:0]       negative, negative_r;
  logic [1:0][ 3:0] boothSel, boothSel_r, shiftSel, shiftSel_r;
  BoothEncode U_LowBoothEncode({dat[3:0],1'b0}, negative[0], boothSel[0], shiftSel[0]);
  BoothEncode U_HighBoothEncode(dat[7:3]      , negative[1], boothSel[1], shiftSel[1]);
  EnReg #(2) U_Negative(clk,rst,1'b1,negative,negative_r);
  EnReg #(8) U_BoothSel(clk,rst,1'b1,boothSel,boothSel_r);
  EnReg #(8) U_ShiftSel(clk,rst,1'b1,shiftSel,shiftSel_r);

  logic [15:0] outputDat;
  ComputeUnit U_ComputeUnit(iDat1X, iDat3X, iDat5X, iDat7X, 
                            negative_r, boothSel_r, shiftSel_r, outputDat);
  EnReg #(16) U_DatOutput(clk,rst,1'b1,outputDat,oDat);

endmodule : MulUnit
