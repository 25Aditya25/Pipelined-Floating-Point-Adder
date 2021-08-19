module SHIFT(result, resultsign,bigshift,smallshift,resultreg);

//reg [11:0] i;
input [53:0]resultreg;
output [63:0]result;
input [10:0] bigshift,smallshift;
input resultsign;

integer i;
reg [5:0] pos;
reg found=1'b0;
reg [51:0] resMantissa;
reg [10:0] resExp;
reg resSign;
reg [51:0]zeros=52'd0;
//reg found=1'b0;
reg [51:0]tempresultreg=0;
reg [10:0]tempbigshift;
/*always@(resultreg)
begin
	for(i=63;i>0;i=i-1)begin
			if(resultreg[i] == 1'b1 && found==1'b0)begin
				found=1'b1;
				pos=i;
			end
		end
		if(found==1'b0) pos=i;
end
endmodule*/

always@(resultsign,bigshift,smallshift,resultreg)
begin
	if(resultreg[53]==1'b1)
	begin
		resMantissa=resultreg[52:1];
		resExp=bigshift+11'b10000000000; //increase exponent by one and add bias
	end	
	else if(resultreg[53]==1'b0 && resultreg[52]==1'b1)
	begin
		resMantissa=resultreg[51:0];
		resExp=bigshift+10'b1111111111;  //add bias to bigshift
	end
	else if(resultreg[53]==1'b0 && resultreg[52]==1'b0)
	begin
		tempbigshift=bigshift;
		tempresultreg=resultreg[51:0];
		for(i=51;i>0;i=i-1)begin	
			if(resultreg[i] == 1'b1 && found==1'b0)
			begin
				found=1'b1;
				pos=i;
				tempresultreg=tempresultreg<<1;
				tempbigshift=tempbigshift-1;
			end
			else if(found==1'd0)
			begin
				tempresultreg=tempresultreg<<1;
				tempbigshift=tempbigshift-1;
			end
		end
		
		
		if(found==1'b0)
		begin
			resMantissa=52'd0;
			resExp=11'd0;
		end
		else
		begin
			resMantissa=tempresultreg;
			resExp=tempbigshift+10'b1111111111;  //add bias to bigshift
		end
	end
	
	
	
end

assign result={resultsign,resExp,resMantissa};
endmodule