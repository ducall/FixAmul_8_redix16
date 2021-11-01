module EnReg
#(DATA_WIDTH = 64
)(
  input                         clk,
  input                         rst,
  input                         iEn,
  input        [DATA_WIDTH-1:0] iDat,
  output logic [DATA_WIDTH-1:0] oDat
);

  always_ff @(posedge clk, negedge rst) begin
    if(!rst) begin
      oDat <= '0;
    end else begin
      if (iEn) begin
        oDat <= iDat;
      end else begin
        oDat <= oDat;
    end
  end

  end
endmodule