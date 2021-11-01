`define SDF_FILE  "../setuptime_output/ChipTop_cmax.sdf"
module tb();
//initial $sdf_annotate(`SDF_FILE, tb.U_CnnInt8Mult, ,"sdf.log");
logic clk,rst;
// logic Start;
logic signed [7:0]  A;
logic signed [7:0]  B;
logic [15:0] P;
logic [15:0] test;
logic EnA,EnB;

logic [7:0]count;
logic [7:0]MemA[100000:0];
logic [7:0]MemB[100000:0];
logic [100000:0] A_adder;
logic [100000:0] B_adder;

//initial begin   
//    $readmemb("/home/train/2019chengqiao/mul8_new/sim/dat_actv_dat0.frpt", MemA);
//end
//initial begin   
//    $readmemb("/home/train/2019chengqiao/mul8_new/sim/wt_actv_data02.frpt", MemB);
//end
// initial begin
//     EnA = 1'b1;
// end
// assign EnB = (A == -128) ;
initial begin
    EnA = 1'b1;
end
assign EnB = (count == 0) ;
always_ff @(posedge clk, negedge rst) begin
    if(!rst) begin
        count <= 8'b0000_0000;
    end else if(count == 127) begin
        count <= 'b0;
    end else begin
        count <= count+1;
    end
end
always_ff @(posedge clk, negedge rst) begin
    if(!rst) begin
        A_adder <= 'b0;
    end else begin
        A_adder <= A_adder+1;
    end
end

always_ff @(posedge clk, negedge rst) begin
    if(!rst) begin
        B_adder <= 'b0;
    end else if(count == 127) begin
        B_adder <= B_adder+1;
    end else begin
        B_adder <= B_adder;
    end
end
assign A = MemA[A_adder];
assign B = MemB[B_adder];
// always_ff @(posedge clk, negedge rst) begin
//     if(!rst) begin
//         A <= -128;
//     end else if(A == 127) begin
//         A <= -128;
//     end else begin
//         A <= A+1;
//     end
// end

// always_ff @(posedge clk, negedge rst) begin
//     if(!rst) begin
//         B <= -128;
//     end else if(A == 127) begin
//         B <= B+1;
//     end else begin
//         B <= B;
//     end
// end

assign test = $signed(A) * $signed(B);
logic [15:0] test_r1,test_r2,test_r3;
always_ff @(posedge clk or negedge rst) begin
    if(!rst) begin
        {test_r3,test_r2,test_r1} <= 1'b0;
    end else begin
        {test_r3,test_r2,test_r1}  <= {test_r2,test_r1,test};
    end
end
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

CnnInt8Mul U_CnnInt8Mult(
    clk,
    rst,
    EnA,
    EnB,
    A,
    B,
    P
);

logic error;
always_comb begin
   if ((P == test_r2))
       error = 0;
   else
       error = 1;
end

// initial begin
// forever @ (posedge clk) begin
//   if(B == 127) begin
//     $finish;  
//   end
// end
// end
initial begin
forever @ (posedge clk) begin
  if(B_adder == 100) begin
    $finish;  
  end
end
end

//initial begin
//$fsdbDumpfile("tb.fsdb");
//$fsdbDumpvars();
//end
//
//
//
//initial begin
//$dumpfile("tb.vcd");
//$dumpvars();
//end
//
endmodule
