module OP(resultreg,bigreg,smallreg,number1,number2);

input [53:0] bigreg,smallreg;
input [63:0] number1,number2;
output reg [53:0] resultreg;

always@(bigreg,smallreg,number1,number2)
begin	
	if (number1[63] != number2[63]) 
		resultreg = bigreg - smallreg;
	else 
		resultreg = bigreg + smallreg;
end		
endmodule