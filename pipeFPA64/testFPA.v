`timescale 10ns/1ns
module testFPA();

	
	reg [63:0] number1,number2;
	wire [63:0] result;
	wire ready;
	reg rst=1'b1;
	reg [191:0] test [0:7];
	reg [63:0] expected_result;
	reg clk;
	reg Done;
	reg [2:0] icount=3'b000;
	reg [3:0] ocount=4'b0000;
	reg mistake;
	wire correct;
	
	initial
	begin
		
		//Test cases
		clk=1'b0;
		test[0]={64'h4056800000000000, 64'h4056800000000000, 64'h4066800000000000};//90 + 90 = 180
		test[1]={64'h4049000000000000, 64'h4034000000000000, 64'h4051800000000000};//50 + 20 = 70
		test[2]={64'h4056800000000000, 64'h4056800000000000, 64'h4066800000000000};//90 + 90 = 180
		test[3]={64'h4049000000000000, 64'h4034000000000000, 64'h4051800000000000};//50 + 20 = 70
		test[4]={64'h4056800000000000, 64'h4056800000000000, 64'h4066800000000000};//90 + 90 = 180
		test[5]={64'h4049000000000000, 64'h4034000000000000, 64'h4051800000000000};//50 + 20 = 70
		test[6]={64'h4056800000000000, 64'h4056800000000000, 64'h4066800000000000};//90 + 90 = 180
		test[7]={64'h4049000000000000, 64'h4034000000000000, 64'h4051800000000000};//50 + 20 = 70
		ocount=4'b0000;
		
		Done=1'b0;
		number1=test[0][191:128];
		number2=test[0][127:64];
		expected_result=test[0][63:0];
		mistake=1'b0;
		
		#100 $finish;
	end
	
	pipeFPA32 p(clk,rst,number1,number2,result,ready);
	
	always@(posedge clk) //Data input 
	begin
		if(icount<5)
		begin
			number1<=test[icount][191:128];
			number2<=test[icount][127:64];
			icount<=icount+1;
		end
		
	end
	
	always@(posedge clk)
	begin
		if(icount>=3)
		begin
			if(expected_result!=result) 
				mistake = Done ? mistake : 1'b1;
			expected_result<=test[ocount-1][63:0];
			if(ocount<=3)ocount<=ocount+1;
			else Done<=1'b1;
		end
		else	//acts as reset
		begin
			ocount<=4'b0001;
			expected_result=test[0][63:0];
			mistake=1'b0;
			Done<=1'b0;
		end
	end
	
	assign correct=(Done)?(~mistake):1'b0;
	
	always
	begin
		#5 clk<=!clk;
	end
	
endmodule