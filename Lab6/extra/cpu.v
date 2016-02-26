module CPU( input clock,
		input reset);
	//PC registers
	reg  [31 : 0] pc;
	wire [31 : 0] final_pc;
	wire [31 : 0] next_pc_1;
	wire [31 : 0] next_pc_2;	
	wire isBranch;
	wire zero_step;
	wire zero_branch;
	wire jump;
	wire [31 : 0]final_pc_1;
	wire [31 : 0]final_pc_2;
	//PC registers END

	//Control Wires 
	wire MemRead;//Read From Data Memory
    	wire MemWrite;//Write to Data Memory
    	wire RegWrite;//Write to Register File
    	wire Branch;  //If Branch 
    	wire RegDst;  //Specify where to write to reg2-reg3(Reg File)
    	wire ALUSrc;  //Specify if second Alu Arg is constant or register
    	wire [1:0]ALUOp;   //Specify operation to be executed in ALU
    	wire MemToReg; //Read From Memory or ALU
		wire NotOp;
    wire [31 : 0]instr;

    //Wires for regFile
    wire [ 4 : 0]wa_reg;
    wire [31 : 0]rdA;
    wire [31 : 0]rdB;
    wire [31 : 0]wd_reg;

    //ALU todo wires
    wire [31 : 0]ext_val;
    wire [31 : 0]alu_val;
    wire [3  : 0] op;
    wire zero;
    wire zero_final;
    wire zero_f_branch;
    wire [31 : 0]alu_out;

    //MEM todo wires
    wire [31 : 0] mem_out;
    wire [1 : 0]  sizeMem;

    ///////INSTRUCTION OPERATIONS//////////

	//Get next Instruction
	Memory cpu_IMem(instr,1'b1,1'b0,2'b10,pc,'bx);
	
	//Next step is reading from control
	Control mainCtrl(MemRead,MemWrite,RegWrite,Branch,RegDst,ALUSrc,ALUOp,MemToReg,NotOp,sizeMem,jump,instr[31 : 26]);

	////////////////////////////////////////

	//////REG FILE OPS/////////

	//define where to write
	defparam reg_mux.N = 5;
	MUX reg_mux(wa_reg, RegDst, instr[20 : 16], instr[15:11]);

	//Read and Write from register file
	RegFile cpu_regs(rdA,rdB, clock,reset,instr[25:21],instr[20:16], wa_reg, RegWrite,wd_reg);

	///////////////////////////

	//////DO ALU OPERATIONS///////

	//Now do the sign extension
	sign_extend s_ext(ext_val, instr[15 : 0]);

	//Decide what to ALU
	defparam alu_mux.N = 32;
	MUX alu_mux(alu_val,ALUSrc,rdB,ext_val);

	//Decide ALU op
	ControlALU aluCtrl(op,ALUOp,instr[5:0]);

	//Finally do the operation in ALU
	ALU alu(alu_out,zero,rdA, alu_val,op);

	///////////////////////////

	////DO RAM OPERATIONS/////

	//If need be read from memory
	Memory RAM_mem(mem_out,MemRead,MemWrite,sizeMem,alu_out,rdB);

	//Check what to write to RegFile
	defparam ram_mux.N = 32;
	MUX ram_mux(wd_reg,MemToReg,alu_out,mem_out);

	///////////////////////////////////


	////////FIND NEXT PC/////////

	//find normal step
	ALU do_step(next_pc_1,zero_step,pc,4,4'b0010);

	//Check where to go next
	ALU branch_step(next_pc_2,zero_branch,next_pc_1,4*ext_val,4'b0010);
	
	//check if not operation
	defparam zero_mux.N = 1;
	MUX zero_mux(zero_final,NotOp,zero,!zero);

	//Decide if branch
	AND_PORT andP(isBranch, Branch, zero_final);	

	//Choose next_pc
	defparam pc_mux.N = 32;
	MUX pc_mux(final_pc_1,isBranch,next_pc_1,next_pc_2);

	///////////////////////////////////

	
	//Choose final_pc
	defparam f_pc_mux.N = 32;
	MUX f_pc_mux(final_pc,jump,final_pc_1,4*instr[25 : 0]);




always @(negedge clock)
begin
	pc 	= final_pc; 
	

end
endmodule


