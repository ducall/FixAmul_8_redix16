
module PreprocessUnit
#(OUTPUT_PORT_NUM = 1
)(
  input              clk, rst,
  input              iEn,
  input        [7:0] iDat,
  output logic [OUTPUT_PORT_NUM-1:0][7 :0] oDat1X,//
  output logic [OUTPUT_PORT_NUM-1:0][9 :0] oDat3X,//
  output logic [OUTPUT_PORT_NUM-1:0][10:0] oDat5X,//
  output logic [OUTPUT_PORT_NUM-1:0][10:0] oDat7X //
);

  logic       enable;
  logic [7:0] dat1X;
  EnReg #(1) U_EnInput(clk,rst,(iEn|enable),iEn,enable);
  EnReg #(8) U_DatInput(clk,rst,iEn,iDat,dat1X);

  wire [ 9:0 ] dat2X = {{dat1X[$high(dat1X)],dat1X}, 1'b0  };
  wire [ 10:0] dat4X = {{{2{dat1X[$high(dat1X)]}},dat1X}, 2'b00 };
  wire [ 10:0] dat8X = {dat1X, 3'b000};

  wire [ 9:0] dat3X = dat2X + {{2{dat1X[$high(dat1X)]}},dat1X};
  wire [ 10:0] dat5X = dat4X + {{3{dat1X[$high(dat1X)]}},dat1X};
  wire [ 10:0] dat7X = dat8X - {{3{dat1X[$high(dat1X)]}},dat1X};

  for(genvar i=0; i<OUTPUT_PORT_NUM; i=i+1) begin : Gen_Output
    EnReg #( 8) U_Dat1X(clk,rst,enable,dat1X,oDat1X[i]); //
    EnReg #(10) U_Dat3X(clk,rst,enable,dat3X,oDat3X[i]);
    EnReg #(11) U_Dat5X(clk,rst,enable,dat5X,oDat5X[i]);
    EnReg #(11) U_Dat7X(clk,rst,enable,dat7X,oDat7X[i]);
  end

endmodule : PreprocessUnit
