
module SignedShiftLeft
#(DATA_WIDTH = 4,
  MAX_SHIFT_BIT = 2,
localparam 
  OUT_DATA_WIDTH = DATA_WIDTH + MAX_SHIFT_BIT
)(
  input        [MAX_SHIFT_BIT    :0] iShiftSel,
  input        [DATA_WIDTH     -1:0] iDat,
  output logic [OUT_DATA_WIDTH -1:0] oDat
);

  logic [MAX_SHIFT_BIT:0][DATA_WIDTH-1:0] datTmp;
  for(genvar i=0; i<MAX_SHIFT_BIT+1; i=i+1) begin : Gen_ShiftDatMask
    Mask #(DATA_WIDTH) U_DatMask(iShiftSel[i], iDat, datTmp[i]);
  end

  for(genvar i=0; i<MAX_SHIFT_BIT; i=i+1) begin : Gen_LowBitOutputDat
    always_comb begin
        oDat[i] = 1'b0;
      for(int j=0; j<=i; j=j+1) begin
        oDat[i] = oDat[i] | datTmp[j][i-j];
      end
    end
  end

  for(genvar i=MAX_SHIFT_BIT; i<DATA_WIDTH; i=i+1) begin : Gen_MidBitOutputDat 
    always_comb begin
        oDat[i] = 1'b0;
      for(int j=0; j<MAX_SHIFT_BIT+1; j=j+1) begin
        oDat[i] = oDat[i] | datTmp[j][i-j];
      end
    end
  end

  for(genvar i=DATA_WIDTH; i<OUT_DATA_WIDTH; i=i+1) begin : Gen_HighBitOutputDat 
    always_comb begin
        oDat[i] = 1'b0;
      for(int j=MAX_SHIFT_BIT; j>(MAX_SHIFT_BIT-(OUT_DATA_WIDTH-i)); j=j-1) begin
        oDat[i] = oDat[i] | datTmp[j][i-j];
      end
      for(int j=(MAX_SHIFT_BIT-(OUT_DATA_WIDTH-i)); j>=0; j=j-1) begin
        oDat[i] = oDat[i] | datTmp[j][$high(datTmp[j])];
      end
    end
  end

endmodule : SignedShiftLeft
