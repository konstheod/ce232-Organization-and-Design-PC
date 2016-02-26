// Register File. Read ports: address raA, data rdA
//                            address raB, data rdB
//                Write port: address wa, data wd, enable wen.
//Parameters		N = size of regs
//			R = log2(nof regs)
module RegFile #(parameter N = 32, R = 5)
		( output reg[N-1 : 0] rdA,
		  output reg[N-1 : 0] rdB,
		  input clock, 
		  input reset,
		  input [R-1 : 0] raA,
		  input [R-1 : 0] raB,
		  input [R-1 : 0] wa,
		  input wen, 
		  input [N-1 : 0] wd);

//our registers
reg [N-1 : 0]data[N-1 : 0];
//for loops
integer i;


//RESET
always @(negedge reset)
begin
	for (i = 0; i < N; i = i + 1)  data[i] = 0;
	rdA = 0;
	rdB = 0;
end

//READ
always @(raA, raB)
begin 
	rdA <= data[raA];	
	rdB <= data[raB];		
end

//WRITE
always @(negedge clock)
begin
	//if reset is set all regs to zero
	if (reset && wen) data[wa] <= wa? wd : 0;	
end

endmodule

