// Define top-level testbench
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Top level has no inputs or outputs
// It only needs to instantiate CPU, Drive the inputs to CPU (clock, reset)
// and monitor the outputs. This is what all testbenches do

`include "constants.h"
`timescale 1ns/1ps 

module cpu_tb;
integer   i;
reg       clock, reset;    // Clock and reset signals

// Instantiate CPU
cpu cpu0(clock, reset);

// Initialization and signal generation
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

initial  
  begin 
   clock = 1'b0;       
   reset = 1'b0;  // Apply reset for a few cycles
   #(4.25*`clock_period) reset = 1'b1;
  end
     
always 
   #(`clock_period / 2) clock = ~clock;  // Clock generation 


initial begin 

  for (i = 0; i < 32; i = i+1)
    cpu0.cpu_regs.data[i] = i; 
    
  $readmemb("program_complex.bin", cpu0.cpu_IMem.data);


end 

endmodule
