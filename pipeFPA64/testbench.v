`timescale 10ns/10ps
module testbench();


reg clk=1'b0;
//wire [3:0] ocount;
wire correct,Done;
//wire [3:0]count;
wire mistake;
//wire [63:0] result, expected_result;

checker2 c(clk,Done,correct);




initial
begin
#40 $finish; //5
end

always
begin
	clk=#1 !clk;
end


endmodule