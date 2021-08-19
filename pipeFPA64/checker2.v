/*
Self Checking wrapper module for 64 bit floating point Adder designed in Verilog
Author: Aditya Wani
Email: waniaditya2525@gmail.com
*/

module checker2(input clk,output reg Done,output correct);
	reg rst;
	reg [63:0] number1,number2;
	wire [63:0] result;
	
	
	reg [191:0] test [0:7];
	reg [63:0] expected_result;
	
	//reg [2:0] state= RDY;
	reg [2:0] icount=3'b000;
	reg [3:0] ocount=4'b0000;
	reg mistake;
	
	initial
	begin
		rst=1'b1;
		//Test cases
		test[0]={64'h4056800000000000, 64'h4056800000000000, 64'h4066800000000000};//90 + 90 = 180
		test[7]={64'hBFF0000000000000, 64'hC000000000000000, 64'hC008000000000000};//-1 + -2 = -3
		test[6]={64'hBFF0000000000000, 64'h3FF0000000000000, 64'h0000000000000000};//-1 + 1 = 0
		test[3]={64'h4049000000000000, 64'h4034000000000000, 64'h4051800000000000};//50 + 20 = 70
		test[4]={64'h4056800000000000, 64'h4056800000000000, 64'h4066800000000000};//90 + 90 = 180
		test[5]={64'h4049000000000000, 64'h4034000000000000, 64'h4051800000000000};//50 + 20 = 70
		test[1]={64'h4056800000000000, 64'h4056800000000000, 64'h4066800000000000};//90 + 90 = 180
		test[2]={64'h4049000000000000, 64'h4034000000000000, 64'h4051800000000000};//50 + 20 = 70
		ocount=4'b0000;
		
		//Done=1'b0;
		number1=test[0][191:128];
		number2=test[0][127:64];
		expected_result=test[0][63:0];
		mistake=1'b0;
		//correct=1'b0;
		
	end
	
	pipeFPA64 fpa(clk,rst,number1,number2,result);
	
	always@(posedge clk) //Data input 
	begin
		rst=1'b1;
		if(icount<5)
		begin
			number1<=test[icount][191:128];
			number2<=test[icount][127:64];
			icount<=icount+1;
		end
		
	end

	always@(posedge clk)
	begin
		if(ocount<3)
		begin
			Done<=1'b0;
			ocount<=ocount+4'b0001;
			expected_result<=test[0][63:0];
			mistake<=1'b0;
		end
		else
		begin
			expected_result<=test[ocount-3][63:0];
			if(result!=expected_result)
		     mistake = Done ? mistake : 1'b1;		
			if(ocount==8)
			begin				
				Done<=1'b1;
				ocount<=4'b1000;	
			end
			else
			begin
				ocount<=ocount+4'b0001;
				Done<=1'b0;
			end	
		end
	end
	
	assign correct=(Done)?(~mistake):1'b0;
	
	
endmodule