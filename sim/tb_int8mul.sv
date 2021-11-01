module tb_int8mul ();
logic clk,rst;
logic signed [7:0]  A;
logic signed [7:0]  B;
logic [15:0] P;
logic [15:0] test;
logic EnA;

//TODO-1 creat enable and A_mul and B_mul signal
  always_ff @(posedge clk, negedge rst) begin : enable_signal
      EnA <= 1'b1;
  end
  
  always_ff @(posedge clk, negedge rst) begin : mul_B 
          if(!rst) begin
               B <= -128;
           end else if(B == 127) begin
               B <= -128;
           end else begin
               B <= B+1;
           end
  end

   always_ff @(posedge clk, negedge rst) begin : mul_A
          if(!rst) begin
                A <= -128;
            end else if(B == 127) begin
                A <= A+1;
            end else begin
                 A <= A;
   end
 end
  assign test = $signed(A) * $signed(B);
  logic [15:0] test_r1,test_r2,test_r3;
  logic [ 7:0] A_r1,A_r2,A_r3 ;
  logic [ 7:0] B_r1,B_r2,B_r3;
  always_ff @(posedge clk or negedge rst) begin
      if(!rst) begin
          {test_r3,test_r2,test_r1} <= 16'b0;
          {A_r1,A_r2,A_r3 } <= 8'b0;
          {B_r1,B_r2,B_r3 } <= 8'b0;
      end else begin
          {test_r3,test_r2,test_r1}  <= {test_r2,test_r1,test};    
          {A_r3,A_r2,A_r1}                 <= {A_r2,A_r1,A} ;
          {B_r3,B_r2,B_r1}                 <= {B_r2,B_r1,B} ;
     
      end
  end


//TODO-2   clock and reset signal 
initial begin
    clk = 1'b0;
    forever begin
        #50 clk = ~clk;
    end
end
initial begin
    rst = 1'b1;
    #30 rst = 1'b0;
    #200 rst = 1'b1;
end

//TODO-3 instance
int8Mul 
#(
    .B_NUM ( 1 )
)
u_int8Mul(
    .clk   (clk   ),
    .rst   (rst   ),
    .iAEn  (EnA  ),
    .iA    (A    ),
    .iB    (B   ),
    .oRslt (P )
);

//TODO-4 checker

logic error;
always_comb begin
   if ((P == test_r3))
       error = 0;
   else
       error = 1;
end

//TODO-5 dump
/* 
  initial begin
  forever @ (posedge clk) begin
    if(A == 127) begin
      $finish;  
    end
  end
  end
 
  initial begin
  $fsdbDumpfile("tb_int8mul.fsdb");
  $fsdbDumpvars();
  end
  
  
  
  initial begin
  $dumpfile("tb_int8mul.vcd");
  $dumpvars();
  end
*/  

endmodule