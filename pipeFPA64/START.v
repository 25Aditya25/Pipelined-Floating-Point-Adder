module START(bigreg,smallreg,bigshift,smallshift,resultsign,rst,number1,number2);

input [63:0] number1,number2;
input rst;
output reg [53:0]bigreg,smallreg;
output reg [10:0] bigshift,smallshift;
output reg resultsign;


always@(number1,number2)
begin
	//if(rst)
	//begin	
		if (number1[63] != number2[63]) //numbers with different sign
			if (number1[62:52] > number2[62:52]) //exponent num1 > num2 
			begin 
				bigreg <={1'd0,1'b1,number1[51:0]}; //  {6bits,1,(52bits mantissa),6bits}
				bigshift <= number1[62:52] - 10'b1111111111;
				resultsign <= number1[63];
				smallreg <={1'd0,1'b1,number2[51:0]};
				smallshift <= number2[62:52] - 10'b1111111111;
			
			end
			else if (number2[62:52] > number1[62:52])  //num2 > num1
			begin 
				bigreg <={1'd0,1'b1,number2[51:0]}; //  {6bits,1,(52bits mantissa),6bits}
				bigshift <= number2[62:52] - 10'b1111111111;
				resultsign <= number2[63];
				smallreg <={1'd0,1'b1,number1[51:0]};
				smallshift <= number1[62:52] - 10'b1111111111;
				
			end
			else 											//same exponent		
			begin
				if (number1[51:0] > number2[51:0]) 				//number 1 mantissa bigger
				begin 
					bigreg <={1'd0,1'b1,number1[51:0]};
					bigshift <= number1[62:52] - 10'b1111111111;   //subtract the bias and get the real exponent
					resultsign <= number1[63];
					smallreg <={1'd0,1'b1,number2[51:0]};
					smallshift <= number2[62:52] - 10'b1111111111;

				end
				else //if (number2[51:0] > number1[51:0])			//number 2 mantissa bigger or equal
				begin 
					bigreg <={1'd0,1'b1,number2[51:0]}; //  {6bits,1,(52bits mantissa),6bits}
					bigshift <= number2[62:52] - 10'b1111111111;
					if(number2[51:0] > number1[51:0]) 
						resultsign <= number2[63]; //unequal numbers being subtracted
					else 
						resultsign <= 1'b0; //Equal numbers being subtracted 
					smallreg <={1'd0,1'b1,number1[51:0]};
					smallshift <= number1[62:52] - 10'b1111111111;
				end

			end	
		
		else 	//same sign
		begin 
			bigreg <={1'd0,1'b1,number1[51:0]};
			bigshift <= number1[62:52] - 10'b1111111111;
			resultsign <= number1[63];				//sign of result same as input
			smallreg <={1'd0,1'b1,number2[51:0]};
			smallshift <= number2[62:52] - 10'b1111111111;
			
		end

end
endmodule