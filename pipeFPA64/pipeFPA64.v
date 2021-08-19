module pipeFPA64(clk,rst,number1,number2,result,ready);

input clk;
input rst;
input [63:0] number1;
input [63:0] number2;
output [63:0] result;
output ready;

/*Registers between stage 1 and stage 2*/
wire [53:0] s1_s2_bigreg,s1_s2_smallreg;
wire [10:0] s1_s2_bigshift,s1_s2_smallshift;
wire s1_s2_resultsign;

reg reg_s1_s2_resultfound;
reg [53:0] reg_s1_s2_bigreg,reg_s1_s2_smallreg;
reg [10:0] reg_s1_s2_bigshift,reg_s1_s2_smallshift;
reg reg_s1_s2_resultsign;
reg [63:0] reg_s1_s2_number1,reg_s1_s2_number2;

/*Registers between stage 2 and stage 3*/
wire [53:0] s2_s3_bigreg,s2_s3_smallreg;
wire [63:0] s2_s3_number1,s2_s3_number2;

reg [53:0] reg_s2_s3_bigreg,reg_s2_s3_smallreg;
reg [63:0] reg_s2_s3_number1,reg_s2_s3_number2;
reg [63:0] reg_s2_s3_result;
reg reg_s2_s3_resultsign;
reg reg_s2_s3_resultfound;
reg [10:0] reg_s2_s3_bigshift,reg_s2_s3_smallshift;

/*Registers between stage 3 and stage 4*/
wire [53:0] s3_s4_resultreg;
wire s3_s4_resultsign;

reg [53:0] reg_s3_s4_resultreg;
reg reg_s3_s4_resultsign;
reg reg_s3_s4_resultfound;
reg [63:0] reg_s3_s4_result;
reg [10:0] reg_s3_s4_bigshift,reg_s3_s4_smallshift;
/*Registers between stage 4 and stage 5*/
wire [11:0] s4_s5_pos;
wire s4_s5_resultsign;
wire [53:0]s4_s5_resultreg;

reg [11:0] reg_s4_s5_pos;
reg reg_s4_s5_resultsign;
reg [53:0]reg_s4_s5_resultreg;
reg [63:0] reg_s4_s5_result;
reg reg_s4_s5_resultfound;

wire [63:0] s5_result;

START s1(s1_s2_bigreg,s1_s2_smallreg,s1_s2_bigshift,s1_s2_smallshift,s1_s2_resultsign, rst,number1,number2);
			
NEGPOS s2(s2_s3_bigreg,s2_s3_smallreg, reg_s1_s2_bigreg,reg_s1_s2_smallreg,reg_s1_s2_bigshift,reg_s1_s2_smallshift);

OP s3(s3_s4_resultreg, reg_s2_s3_bigreg,reg_s2_s3_smallreg,reg_s2_s3_number1,reg_s2_s3_number2);

SHIFT s4(s5_result, reg_s3_s4_resultsign,reg_s3_s4_bigshift,reg_s3_s4_smallshift,reg_s3_s4_resultreg);


/*Stage 1 to Stage 2*/
always@(posedge clk)
begin
	if(rst==1'b1)
	begin
		reg_s1_s2_bigreg<=s1_s2_bigreg;
		reg_s1_s2_smallreg<=s1_s2_smallreg;
		reg_s1_s2_bigshift<=s1_s2_bigshift;
		reg_s1_s2_smallshift<=s1_s2_smallshift;
		reg_s1_s2_resultsign<=s1_s2_resultsign;
		reg_s1_s2_number1 <= number1;
		reg_s1_s2_number2 <= number2;
	end
	else
	begin
		reg_s1_s2_bigreg<=0;
		reg_s1_s2_smallreg<=0;
		reg_s1_s2_bigshift<=0;
		reg_s1_s2_smallshift<=0;
		reg_s1_s2_resultsign<=0;
		reg_s1_s2_number1 <=0;
		reg_s1_s2_number2 <=0;
	end
	
end

/*Stage 2 to Stage 3*/
always@(posedge clk)
begin
	if(rst==1'b1)
	begin
		reg_s2_s3_bigreg<=s2_s3_bigreg;
		reg_s2_s3_smallreg<=s2_s3_smallreg;
		reg_s2_s3_resultsign <= reg_s1_s2_resultsign;
		reg_s2_s3_number1<=reg_s1_s2_number1;
		reg_s2_s3_number2<=reg_s1_s2_number2;
		reg_s2_s3_bigshift<=reg_s1_s2_bigshift;
		reg_s2_s3_smallshift<=reg_s1_s2_smallshift;
	end
	else
	begin
		reg_s2_s3_bigreg<=0;
		reg_s2_s3_smallreg<=0;
		reg_s2_s3_resultsign <=0;
		reg_s2_s3_number1<=0;
		reg_s2_s3_number2<=0;
		reg_s2_s3_bigshift<=0;
		reg_s2_s3_smallshift<=0;
	end
end

/*Stage 3 to Stage 4*/
always@(posedge clk)
begin
	if(rst==1'b1)
	begin
		reg_s3_s4_resultreg <= s3_s4_resultreg;
		reg_s3_s4_resultsign <= reg_s2_s3_resultsign;
		reg_s3_s4_bigshift<=reg_s2_s3_bigshift;
		reg_s3_s4_smallshift<=reg_s2_s3_smallshift;
	end
	else
	begin
		reg_s3_s4_resultreg <=0;
		reg_s3_s4_resultsign <=0;
		reg_s3_s4_bigshift<=0;
		reg_s3_s4_smallshift<=0;
	end
end




assign result =  s5_result;


endmodule