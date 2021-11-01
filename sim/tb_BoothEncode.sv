module tb_BoothEncode ();
    
logic  [4:0]   iDat;
logic          oNegative   ;
logic  [3:0]   oBoothSel   ;
logic  [3:0]   oShiftSel   ;

initial begin
    #20
    iDat = 5'b00000;
    #20
    iDat = 5'b11111;//
    #20
    iDat = 5'b00001;
    #20
    iDat = 5'b00010;//
    #20
    iDat = 5'b00011;
    #20
    iDat = 5'b00100;//
    #20
    iDat = 5'b00101;
    #20
    iDat = 5'b00110;//
    #20
    iDat = 5'b00111;
    #20
    iDat = 5'b01000;//
    #20
    iDat = 5'b01001;
    #20
    iDat = 5'b01010;//
    #20
    iDat = 5'b01011;
    #20
    iDat = 5'b01100;//
    #20
    iDat = 5'b01101;
    #20
    iDat = 5'b01110;//



    #20
    iDat = 5'b01111;//
    #20
    iDat = 5'b10000;
    #20
    iDat = 5'b10001;
    #20
    iDat = 5'b10010;//
    #20
    iDat = 5'b10011;
    #20
    iDat = 5'b10100;//
    #20
    iDat = 5'b10101;
    #20
    iDat = 5'b10110;//
    #20
    iDat = 5'b10111;
    #20
    iDat = 5'b11000;//
    #20
    iDat = 5'b11001;
    #20
    iDat = 5'b11010;//
    #20
    iDat = 5'b11011;
    #20
    iDat = 5'b11100;//
    #20
    iDat = 5'b11101;
    #20
    iDat = 5'b11110;


end


BoothEncode u_BoothEncode(
    .iDat      (iDat      ),
    .oNegative (oNegative ),
    .oBoothSel (oBoothSel ),
    .oShiftSel (oShiftSel )
);


endmodule