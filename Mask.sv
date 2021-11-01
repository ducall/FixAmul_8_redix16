
module Mask
#(P_WIDTH = 8)
(
  input                iEn,   //if iEn equal to 1 oDat = iDat fix one
  input  [P_WIDTH-1:0] iDat,
  output [P_WIDTH-1:0] oDat
);

  assign oDat = iDat & {P_WIDTH{iEn}};

endmodule : Mask
