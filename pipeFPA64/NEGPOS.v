module NEGPOS(out_bigreg,out_smallreg, in_bigreg,in_smallreg,bigshift,smallshift);


input [10:0] bigshift,smallshift;
output reg [53:0] out_bigreg,out_smallreg;	
input  [53:0] in_bigreg,in_smallreg;
		
always@(bigshift,smallshift,in_bigreg,in_smallreg)
begin	
	/*if (bigshift > 0) 		//i.e there was initial shifting 
		out_bigreg <= in_bigreg << bigshift;  //shift the bigreg to get it back to the original value in decimal
	else out_bigreg <= in_bigreg >> ((~bigshift)+1);
	if (smallshift > 0) 				//shift the smallreg to get it back to the original value in decimal
		out_smallreg <= in_smallreg << smallshift;
	else out_smallreg <= in_smallreg >> ((~smallshift)+1);*/
	
	if(bigshift>smallshift) 
	begin
		out_smallreg <= in_smallreg >> (bigshift-smallshift);
		out_bigreg <= in_bigreg;
	end
	else 
	begin
		out_bigreg <= in_bigreg;
		out_smallreg <= in_smallreg;
	end
end
endmodule