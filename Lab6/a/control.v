// Small control unitM
//     Inputs: opcode, func
//     Output: op, wen
// Operations: formatR

module Control #(parameter F=6,R=6,P=4)(	output reg [P-1:0]op,
										    output reg wen,
										    input [R-1:0]opcode,
										    input [F-1:0]func);

parameter 	format_R = 0,
		 	 R_ADD   = 6'h20,
			 R_SUB	= 6'h22,
			 R_AND	= 6'h24,
			 R_OR	= 6'h25,
			 R_SLT	= 6'h2a;

always @(*)
begin
	case(opcode)
		format_R :
			case(func)
			R_ADD : op = 4'b0010;
			R_SUB : op = 4'b0110;
			R_AND : op = 4'b0000;
			R_OR  : op = 4'b0001;
			R_SLT : op = 4'b0111;
			default:op = 'bx;
			endcase
		default:  op = 'bx; 
	endcase
	
	if(op == 'bx) wen = 1'b0;
	else wen = 1'b1;
end

endmodule