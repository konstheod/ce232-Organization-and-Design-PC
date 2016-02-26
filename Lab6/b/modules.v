// This file contains library modules to be used in your design. 
//`include "constants.h"
`timescale 1ns/1ps

// Small ALU. 
//     Inputs: inA, inB, op. 
//     Output: out, zero
// Operations: bitwise and (op = 0)
//             bitwise or  (op = 1)
//             addition (op = 2)
//             subtraction (op = 6)
//             slt  (op = 7)
//             nor (op = 12)
module ALU #(parameter N=32,O=4)( 	output reg [N-1 : 0]out,
					output reg zero,
					input [N-1 : 0]inA,
					input [N-1 : 0]inB,
					input [O-1 : 0]op );

parameter AND_OP = 0 ,
		OR_OP  = 1 ,
		ADD_OP = 2 ,
		SUB_OP = 6 ,
		SLT_OP = 7 ,
		NOR_OP = 12;

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

// Memory (active 1024 words, from 10 address lsbs).
// Read : enable ren, address addr, data dout
// Write: enable wen, address addr, data din.
module Memory #(parameter N=32)( output [N-1:0] dout,
		input ren,
		input wen,
  		input  [N-1:0] addr,
		input [N-1:0]din);


  reg [31:0] data[4095:0];


  always @(ren or wen)   // It does not correspond to hardware. Just for error detection
    if (ren & wen)
      $display ("\nMemory ERROR (time %0d): ren and wen both active!\n", $time);

  always @(posedge ren or posedge wen) begin // It does not correspond to hardware. Just for error detection
    if (addr[31:10] != 0)
      $display("Memory WARNING (time %0d): address msbs are not zero\n", $time);
  end  

  assign dout = ((wen==1'b0) && (ren==1'b1)) ? data[addr[9:0]] : 'bx;  

  always @(din or wen or ren or addr)
   begin
    if ((wen == 1'b1) && (ren==1'b0))
        data[addr[9:0]] = din;
   end

endmodule




// Register File. Read ports: address raA, data rdA
//                            address raB, data rdB
//                Write port: address wa, data wd, enable wen.
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




//A SIMPLE MUX
// WHEN sel = 0 res = ch_0
// WHEN sel = 1 res = ch_1
module MUX #(parameter N = 32)( output reg [N-1 : 0]res,
				input  sel,
				input  [N-1 : 0]ch_0,
				input  [N-1 : 0]ch_1);

always @(*)
begin
	case (sel)
		1'b0 : res = ch_0;
		1'b1 : res = ch_1;
endcase
end

endmodule



//THIS MODULE CONTROLS THE ALU
//AND DECIDES THE OPERATION THAT 
//WILL BE COMPLETED
module ControlALU #(parameter P=4, F = 6)(	output reg[P-1:0]op,
						input [1:0] ALUOp,
						input [F-1:0] func);

parameter FORMAT_R 	= 2,
		  ADD 	= 0,
		  SUB   	= 1;
		 
parameter	 R_ADD   = 6'h20,
		 R_SUB	= 6'h22,
		 R_AND	= 6'h24,
		 R_OR	= 6'h25,
		 R_SLT	= 6'h2a;

always @(*)
begin 
	case (ALUOp)
		FORMAT_R :
		begin
			case(func)
				R_ADD : op = 4'b0010;
				R_SUB : op = 4'b0110;
				R_AND : op = 4'b0000;
				R_OR  : op = 4'b0001;
				R_SLT : op = 4'b0111;
				default:op = 'bx;
			endcase
		end
		SUB :
			op = 4'b0110;
		ADD :
			op = 4'b0010;
		
	endcase
end
endmodule



module sign_extend #(parameter I=16,O=32)(	output reg [O-1:0]out,
											input [I-1:0] inp);



always @(inp)
begin
   
   out[O-1:0] = {{(O - I){inp[I - 1]}}, inp[I-1:0] };

end

endmodule



//A SIMPLE AND PORT
//res = inp_1 & inp_2
module AND_PORT(output reg res,
		input  inp_1,
		input  inp_2);

always @(*)
begin
	res = inp_1 & inp_2;	
end

endmodule




