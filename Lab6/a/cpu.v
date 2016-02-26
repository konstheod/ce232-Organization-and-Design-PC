module CPU( input clock,
		input reset);
	wire [3:0]op;
	wire zero;
	wire [31:0]instr;
	wire wen;
	wire [31:0]rdA,rdB;
	wire [31:0]wd;
	wire wen_mem;
	wire ren_mem;	
	reg [31 : 0] pc;
	wire [31 : 0] next_pc;
	parameter STEP = 4;


	//Read next instruction from memory
	Memory cpu_IMem(instr,1'b1,1'b0,pc,'bx);

	//Control Unit 
	Control fsm(op,wen,instr[31:26],instr[5:0]);

	//Register File where registers are stored
	RegFile cpu_regs(rdA,rdB,clock,reset,instr[25:21],instr[20:16],instr[15:11],wen,wd);

	//ALU module to do the operation instructed
	ALU main_alu(wd,zero,rdA,rdB,op);

	ALU pc_alu(next_pc, zero, pc, 32'h04, 4'b0010);

always @(negedge clock)
begin
	pc <= next_pc;
end
endmodule