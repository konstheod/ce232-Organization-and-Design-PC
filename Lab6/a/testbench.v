`define clock_period 5
//`include "constants.h"    // Header file with opcodes
`timescale 1ns/1ps

module cpu_tb;
integer   i;
reg       clock, reset;    // Clock and reset signals


CPU cpu0(clock,reset);

initial 
    begin  

    $monitor( "We are at inst.address[%d] with opcode %d reg[%d] = %d, reg[%d] = %d, result reg[%d]= %d",cpu0.pc,cpu0.op,cpu0.cpu_regs.raA, cpu0.cpu_regs.rdA, cpu0.cpu_regs.raB,cpu0.cpu_regs.rdB,cpu0.cpu_regs.wa,cpu0.cpu_regs.wd);
    reset = 1;	
    clock = 0;		   
    #(`clock_period*2)
 
    #(`clock_period*2)
    for (i = 0; i < 32; i = i+1)
	 cpu0.cpu_regs.data[i] = i;   // Note that R0 = 0 in MIPS 

    #(`clock_period*2)
    $readmemb("program.bin", cpu0.cpu_IMem.data);
    cpu0.pc = 32'h0;

end  // initial 


// Generate clock by inverting the signal every half of clock period
always 
   #(`clock_period / 2) clock = ~clock;  
   
endmodule

