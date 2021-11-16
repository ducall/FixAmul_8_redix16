
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
                                                                    


  wire [ 9:0] lowDat1X3X  = {{2{dat1XMask[0][$high(dat1XMask[0])]}},dat1XMask[0]} | dat3XMask[0] ;    
  wire [10:0] lowDat5X7X  = dat5XMask[0] | dat7XMask[0] ; 
  wire [10:0] lowBoothDat = {lowDat1X3X[$high(lowDat1X3X)],lowDat1X3X} | lowDat5X7X ; 
 
 //shiftcombin
  
  logic  [ 3:0][10:0] datTmp  ;
 
  Mask #( 11) shiftMask0(iShiftSel[0][0], lowBoothDat, datTmp[0]);
  Mask #( 11) shiftMask1(iShiftSel[0][1], lowBoothDat, datTmp[1]);
  Mask #( 11) shiftMask2(iShiftSel[0][2], lowBoothDat, datTmp[2]);
  Mask #( 11) shiftMask3(iShiftSel[0][3], lowBoothDat, datTmp[3]);
  
  wire   datTmpoDat0  = datTmp[0][ 0] ;
  wire   datTmpoDat1  = datTmp[0][ 1] | datTmp[1][ 0] ;
  wire   datTmpoDat2  = datTmp[0][ 2] | datTmp[1][ 1] | datTmp[2][ 0] ;
  wire   datTmpoDat3  = datTmp[0][ 3] | datTmp[1][ 2] | datTmp[2][ 1] | datTmp[3][ 0] ;
  wire   datTmpoDat4  = datTmp[0][ 4] | datTmp[1][ 3] | datTmp[2][ 2] | datTmp[3][ 1] ;
  wire   datTmpoDat5  = datTmp[0][ 5] | datTmp[1][ 4] | datTmp[2][ 3] | datTmp[3][ 2] ;
  wire   datTmpoDat6  = datTmp[0][ 6] | datTmp[1][ 5] | datTmp[2][ 4] | datTmp[3][ 3] ;
  wire   datTmpoDat7  = datTmp[0][ 7] | datTmp[1][ 6] | datTmp[2][ 5] | datTmp[3][ 4] ;
  wire   datTmpoDat8  = datTmp[0][ 8] | datTmp[1][ 7] | datTmp[2][ 6] | datTmp[3][ 5] ;
  wire   datTmpoDat9  = datTmp[0][ 9] | datTmp[1][ 8] | datTmp[2][ 7] | datTmp[3][ 6] ;
  wire   datTmpoDat10 = datTmp[0][10] | datTmp[1][ 9] | datTmp[2][ 8] | datTmp[3][ 7] ;
  wire   datTmpoDat11 = datTmp[0][10] | datTmp[1][10] | datTmp[2][ 9] | datTmp[3][ 8] ;
  wire   datTmpoDat12 = datTmp[0][10] | datTmp[1][10] | datTmp[2][10] | datTmp[3][ 9] ;
  wire   datTmpoDat13 = datTmp[0][10] | datTmp[1][10] | datTmp[2][10] | datTmp[3][10] ;

  wire [13:0] lowBoothRslt_1 = {datTmpoDat13,datTmpoDat12,datTmpoDat11,datTmpoDat10,datTmpoDat9,datTmpoDat8,datTmpoDat7,datTmpoDat6,datTmpoDat5,datTmpoDat4,datTmpoDat3,datTmpoDat2,datTmpoDat1,datTmpoDat0}; 

 // SignedShiftLeft #(11,3) U_LowDatShift(iShiftSel[0], lowBoothDat, lowBoothRslt_1); 
  wire [15:0]  lowBoothRslt      = {{2{lowBoothRslt_1[$high(lowBoothRslt_1)]}},lowBoothRslt_1};
  wire [15:0]  lowNegative       = {$size(lowNegative){iNegative[0]}};
  wire [ 4:0]  lowRsltDatLow4Bit = (lowBoothRslt[0+:4] ^ lowNegative[0+:4]) + iNegative[0];  
  wire [ 11:0] lowRsltDatHighBit = lowBoothRslt[15-:$size(lowRsltDatHighBit)]^lowNegative[15-:$size(lowRsltDatHighBit)]; //



 Mask #( 8) U_HighDat1XMask(iBoothSel[1][0], iDat1X, dat1XMask[1]) ;
 Mask #(10) U_HighDat3XMask(iBoothSel[1][1], iDat3X, dat3XMask[1]) ;
 Mask #(11) U_HighDat5XMask(iBoothSel[1][2], iDat5X, dat5XMask[1]) ;
 Mask #(11) U_HighDat7XMask(iBoothSel[1][3], iDat7X, dat7XMask[1]) ;

 wire [ 9:0] highDat1X3X  = {{2{dat1XMask[1][$high(dat1XMask[1])]}},dat1XMask[1]} | dat3XMask[1] ;
 wire [10:0] highBoothDat = {highDat1X3X[$high(highDat1X3X)],highDat1X3X} | dat5XMask[1] | dat7XMask[1] ;

 //highbit combin
 logic  [ 3:0][10:0] HighdatTmp  ;
 Mask #( 11) HighshiftMask0(iShiftSel[1][0], highBoothDat, HighdatTmp[0]);
 Mask #( 11) HighshiftMask1(iShiftSel[1][1], highBoothDat, HighdatTmp[1]);
 Mask #( 11) HighshiftMask2(iShiftSel[1][2], highBoothDat, HighdatTmp[2]);
 Mask #( 11) HighshiftMask3(iShiftSel[1][3], highBoothDat, HighdatTmp[3]);
 
 wire   HighdatTmpoDat0  = HighdatTmp[0][ 0] ;
 wire   HighdatTmpoDat1  = HighdatTmp[0][ 1] | HighdatTmp[1][ 0] ;
 wire   HighdatTmpoDat2  = HighdatTmp[0][ 2] | HighdatTmp[1][ 1] | HighdatTmp[2][ 0] ;
 wire   HighdatTmpoDat3  = HighdatTmp[0][ 3] | HighdatTmp[1][ 2] | HighdatTmp[2][ 1] | HighdatTmp[3][ 0] ;
 wire   HighdatTmpoDat4  = HighdatTmp[0][ 4] | HighdatTmp[1][ 3] | HighdatTmp[2][ 2] | HighdatTmp[3][ 1] ;
 wire   HighdatTmpoDat5  = HighdatTmp[0][ 5] | HighdatTmp[1][ 4] | HighdatTmp[2][ 3] | HighdatTmp[3][ 2] ;
 wire   HighdatTmpoDat6  = HighdatTmp[0][ 6] | HighdatTmp[1][ 5] | HighdatTmp[2][ 4] | HighdatTmp[3][ 3] ;
 wire   HighdatTmpoDat7  = HighdatTmp[0][ 7] | HighdatTmp[1][ 6] | HighdatTmp[2][ 5] | HighdatTmp[3][ 4] ;
 wire   HighdatTmpoDat8  = HighdatTmp[0][ 8] | HighdatTmp[1][ 7] | HighdatTmp[2][ 6] | HighdatTmp[3][ 5] ;
 wire   HighdatTmpoDat9  = HighdatTmp[0][ 9] | HighdatTmp[1][ 8] | HighdatTmp[2][ 7] | HighdatTmp[3][ 6] ;
 wire   HighdatTmpoDat10 = HighdatTmp[0][10] | HighdatTmp[1][ 9] | HighdatTmp[2][ 8] | HighdatTmp[3][ 7] ;
 wire   HighdatTmpoDat11 = HighdatTmp[0][10] | HighdatTmp[1][10] | HighdatTmp[2][ 9] | HighdatTmp[3][ 8] ;
// wire   HighdatTmpoDat12 = HighdatTmp[0][10] | HighdatTmp[1][10] | HighdatTmp[2][10] | HighdatTmp[3][ 9] ;
// wire   HighdatTmpoDat13 = HighdatTmp[0][10] | HighdatTmp[1][10] | HighdatTmp[2][10] | HighdatTmp[3][10] ;
 
 wire [11:0] highBoothRslt = {HighdatTmpoDat11,HighdatTmpoDat10,HighdatTmpoDat9,HighdatTmpoDat8,HighdatTmpoDat7,HighdatTmpoDat6,HighdatTmpoDat5,HighdatTmpoDat4,HighdatTmpoDat3,HighdatTmpoDat2,HighdatTmpoDat1,HighdatTmpoDat0}; 
 //SignedShiftLeft #(11,3) U_HighDatShift(iShiftSel[1], highBoothDat, highBoothRslt_1);

 //wire [11:0] highBoothRslt = highBoothRslt_1[$high(highBoothRslt)-:$size(highBoothRslt)];

 wire [11:0] highNegative = {$size(highNegative){iNegative[1]}};
 wire [11:0] highRsltDat  = (highBoothRslt ^ highNegative) + iNegative[1];   

 wire [11:0] rsltHigh = highRsltDat + lowRsltDatHighBit + lowRsltDatLow4Bit[$high(lowRsltDatLow4Bit)] ; 
 assign oDat = {rsltHigh, lowRsltDatLow4Bit[3:0]};

endmodule : ComputeUnit
