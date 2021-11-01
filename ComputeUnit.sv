
module ComputeUnit
(
  input             [ 7 :0] iDat1X,
  input             [ 9 :0] iDat3X,
  input             [ 10:0] iDat5X,
  input             [ 10:0] iDat7X,
  input        [1:0]       iNegative,  // high Dat B[7:3] and low Dat A[3:-1] in the arry
  input        [1:0][ 3:0] iBoothSel,  
  input        [1:0][ 3:0] iShiftSel,
  output logic      [15:0] oDat
);

  logic [1:0][7 :0] dat1XMask;
  logic [1:0][9 :0] dat3XMask;
  logic [1:0][10:0] dat5XMask;
  logic [1:0][10:0] dat7XMask;

  Mask #( 8) U_LowDat1XMask(iBoothSel[0][0], iDat1X, dat1XMask[0]);
  Mask #(10) U_LowDat3XMask(iBoothSel[0][1], iDat3X, dat3XMask[0]);
  Mask #(11) U_LowDat5XMask(iBoothSel[0][2], iDat5X, dat5XMask[0]);  //set iBoothsel as a en signal
  Mask #(11) U_LowDat7XMask(iBoothSel[0][3], iDat7X, dat7XMask[0]);  //one hot make only the useful number 
                                                                    


  wire [ 9:0] lowDat1X3X  = {{2{dat1XMask[0][$high(dat1XMask[0])]}},dat1XMask[0]} | dat3XMask[0];     
  wire [10:0] lowBoothDat = {lowDat1X3X[$high(lowDat1X3X)],lowDat1X3X} | dat5XMask[0] | dat7XMask[0]; 
  logic  [13:0] lowBoothRslt_1;
 

  SignedShiftLeft #(11,3) U_LowDatShift(iShiftSel[0], lowBoothDat, lowBoothRslt_1); 
  wire [15:0]  lowBoothRslt = {{2{lowBoothRslt_1[$high(lowBoothRslt_1)]}},lowBoothRslt_1};
  wire [15:0] lowNegative = {$size(lowNegative){iNegative[0]}};
  wire [ 4:0] lowRsltDatLow4Bit = (lowBoothRslt[0+:4] ^ lowNegative[0+:4]) + iNegative[0];  
  wire [ 11:0] lowRsltDatHighBit = lowBoothRslt[15-:$size(lowRsltDatHighBit)]^lowNegative[15-:$size(lowRsltDatHighBit)]; //
  //wire        lowRsltCarry      = lowRsltDatLow4Bit[4];


 Mask #( 8) U_HighDat1XMask(iBoothSel[1][0], iDat1X, dat1XMask[1]);
 Mask #( 10) U_HighDat3XMask(iBoothSel[1][1], iDat3X, dat3XMask[1]);
 Mask #(11) U_HighDat5XMask(iBoothSel[1][2], iDat5X, dat5XMask[1]);
 Mask #(11) U_HighDat7XMask(iBoothSel[1][3], iDat7X, dat7XMask[1]);

 wire [9:0] highDat1X3X  = {{2{dat1XMask[1][$high(dat1XMask[1])]}},dat1XMask[1]} | dat3XMask[1];
 wire [10:0] highBoothDat = {highDat1X3X[$high(highDat1X3X)],highDat1X3X} | dat5XMask[1] | dat7XMask[1];

 logic [13:0] highBoothRslt_1;  //only use [0:11]
 SignedShiftLeft #(11,3) U_HighDatShift(iShiftSel[1], highBoothDat, highBoothRslt_1);

 wire [11:0] highBoothRslt = highBoothRslt_1[$high(highBoothRslt)-:$size(highBoothRslt)];

 wire [11:0] highNegative = {$size(highNegative){iNegative[1]}};
 wire [11:0] highRsltDat  = (highBoothRslt ^ highNegative) + iNegative[1];   

 wire [11:0] rsltHigh = highRsltDat + lowRsltDatHighBit + lowRsltDatLow4Bit[$high(lowRsltDatLow4Bit)] ; 
 assign oDat = {rsltHigh, lowRsltDatLow4Bit[3:0]};

endmodule : ComputeUnit
