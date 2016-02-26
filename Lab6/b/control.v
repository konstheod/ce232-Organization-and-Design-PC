// Small control unitM
//     Inputs: opcode, func
//     Output: op, wen
// Operations: formatR

module Control #(parameter R=6,P=4)(	output reg MemRead,
					output reg MemWrite,
					output reg RegWrite,
					output reg Branch,
					output reg RegDst,
					output reg ALUSrc,
					output reg [1:0]ALUOp,
					output reg MemToReg,
					output reg NotOp,
					//output reg [1:0]sizeMem,
				 	input [R-1:0]opcode);

parameter 	format_R = 0;
parameter   		LW		= 6'h23,
			SW		= 6'h2b,
			BEQ		= 6'h04,
			BNE		= 6'h05,
			ADDI	= 6'h08;


always @(*)
begin
	case(opcode)
		format_R :
		begin	
			
			RegDst 		= 1;
			ALUSrc  	= 0;
			MemToReg 	= 0;
			RegWrite	= 1;
			MemRead		= 0;
			MemWrite	= 0;
			Branch		= 0;
			ALUOp		= 2'b10;
			NotOp		= 0;

		end	
		LW		 : 	
		begin 
			RegDst 		= 0;
			ALUSrc  	= 1;
			MemToReg 	= 1;
			RegWrite	= 1;
			MemRead		= 1;
			MemWrite	= 0;
			Branch		= 0;
			ALUOp		= 0;
			NotOp		= 0;
		end
		SW 		: 
		begin
			RegDst 		= 'bx;
			ALUSrc  	= 1;
			MemToReg 	= 'bx;
			RegWrite	= 0;
			MemRead		= 0;
			MemWrite	= 1;
			Branch		= 0;
			ALUOp		= 0;
			NotOp		= 0;
		end
		BEQ		:
		begin
			RegDst 		= 'bx;
			ALUSrc  	= 0;
			MemToReg 	= 'bx;
			RegWrite	= 0;
			MemRead		= 0;
			MemWrite	= 0;
			Branch		= 1;
			ALUOp		= 1;
			NotOp		= 0;	
		end	
		BNE		:
		begin
			RegDst 		= 'bx;
			ALUSrc  	= 0;
			MemToReg 	= 'bx;
			RegWrite	= 0;
			MemRead		= 0;
			MemWrite	= 0;
			Branch		= 1;
			ALUOp		= 1;
			NotOp		= 1;		
		end	
		ADDI		:
		begin
			RegDst 		= 0;
			ALUSrc  	= 1;
			MemToReg 	= 0;
			RegWrite	= 0;
			MemRead		= 0;
			MemWrite	= 1;
			Branch		= 0;
			ALUOp		= 0;
			NotOp		= 0;		
		end		

			
	endcase
	
end

endmodule