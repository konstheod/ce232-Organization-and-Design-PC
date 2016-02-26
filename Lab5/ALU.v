
`timescale 1ns/1ps


// Small ALU. Inputs: inA, inB. Output: out. 
// Operations: bitwise and (op = 0)
//             bitwise or  (op = 1)
//             addition (op = 2)
//             subtraction (op = 6)
//             slt  (op = 7)
//             nor (op = 12)
module ALU #(parameter N=32)( output reg [N-1 : 0]out,
			      output reg zero,
			      input [N-1 : 0]inA,
			      input [N-1 : 0]inB,
			      input [3 : 0]op );
parameter AND_OP = 4'b0000 ,
 	  OR_OP  = 4'b0001 ,
 	  ADD_OP = 4'b0010 ,
  	  SUB_OP = 4'b0110 ,
       	  SLT_OP = 4'b0111 ,
 	  NOR_OP = 4'b1100 ;




always @(inA, inB, op)
	begin
		case(op)
			AND_OP  : out = inA & inB;
			OR_OP   : out = inA | inB;
			ADD_OP  : out = inA + inB;
			SUB_OP  : out = inA - inB;
			SLT_OP  : out = ((inA < inB)? 1 : 0);
			NOR_OP  : out = ~(inA | inB);
			default : out = 'bx;
		endcase
	
		if (out == 0) zero = 1'b1;
		else	      zero = 1'b0;

	end
endmodule