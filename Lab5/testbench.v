// Define top-level testbench
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Top level has no inputs or outputs
// It only needs to instantiate CPU, Drive the inputs to CPU (clock, reset)
// and monitor the outputs. This is what all testbenches do
`timescale 1ns/1ps
`define clock_period 5

module cpu_tb;

reg [3 : 0]op;
wire       zero;
wire  [31 : 0] outwire;
reg       clock, reset;    // Clock and reset signals
reg   [4:0] raA, raB, wa;
reg         wen;
reg   [31:0] wd;
wire  [31:0] rdA, rdB;
integer i;

// Instantiate regfile module

RegFile regs( rdA, rdB,clock, reset, raA, raB, wa, wen, outwire);
ALU alu(outwire, zero,rdA,rdB,op);	

initial 
begin 
  $monitor($time,"ns - regA address : %d, regA value : %d,regB address : %d, regB value : %d,operation : %d, out address : %d, out value : %d , zero : %d",raA,rdA,raB,rdB,op,wa,outwire,zero); 
  
   // Initialize the module 
   clock = 1'b0;       
   reset = 1'b0;  // Apply reset for a few cycles
   #(4.25*`clock_period) reset = 1'b1;
   
   // Initialize Register File with "random" numbers
   for (i = 0; i < 32; i = i+1)
      regs.data[i] = i;   // Note that R0 = 0 in MIPS 
      
  // AND operation testing
   raA = 32'h1; raB = 32'h13; op = 4'b0000;
   #(2*`clock_period)  
   wen = 1'b1; wa = 32'h02;
   #(2*`clock_period)
   $display("(right value = 1)AND operation 1 AND 13 = %d",regs.data[2]);	


   //OR Operation Testing	
   #(2*`clock_period)
   raA = 32'h06; raB = 32'h09;  op = 4'b0001;
   #(2*`clock_period)
   wen = 1'b1; wa = 32'h02;
   $display("(right value = 15)OR operation 6 OR 9 = %d",regs.data[2]);	

   //ADD Operation Testing	
   #(2*`clock_period)
   raA = 32'h08; raB = 32'h07;  op = 4'b0010;
   #(2*`clock_period)
   wen = 1'b1; wa = 32'h02;
   $display("(right value = 15)ADD operation 8 ADD 7 = %d",regs.data[2]);	

   //SUB Operation Testing	
   #(2*`clock_period)
   raA = 32'h08; raB = 32'h08;  op = 4'b0110;
   #(2*`clock_period)
   wen = 1'b0; wa = 32'h02;
   #(2*`clock_period)
   wen = 1'b1;
   $display("(right value = 0)SUB operation 8 SUB 8 = %d, zero = %d",regs.data[2],zero);	
   #(2*`clock_period)
   raA = 32'h09; raB = 32'h08;  op = 4'b0110;

   #(2*`clock_period)
   $display("(right value = 1)SUB operation 9 SUB 8 = %d, zero = %d",regs.data[2],zero);	
   
   //SLT Operation Testing	
   #(2*`clock_period)
   raA = 32'h08; raB = 32'h07;  op = 4'b0111;
   #(2*`clock_period)
   $display("(right value = 0)SLT operation 8 SLT 7 = %d",regs.data[2]);	
   

   //SLT Operation Testing	
   #(2*`clock_period)
   raA = 32'h07; raB = 32'h08;  op = 4'b0111;
   #(2*`clock_period)
   $display("(right value = 1)SLT operation 7 SLT 8 = %d",regs.data[2]);	
   
   //NOR Operation Testing	
  #(2*`clock_period)
   raA = 32'h03; raB = 32'h04;  op = 4'b1100;
   #(2*`clock_period)
$display("(right value = 4294967288)NOR operation 3 NOR 4 = %d",regs.data[2]);	
    
  //UNDEFINED Operation Testing	
  #(2*`clock_period)
  raA = 32'h03; raB = 32'h04;  op = 4'b1111;
  #(2*`clock_period)
  $display("(right value = X)UNDEF operation 3 UNDEF 4 = %d",regs.data[2]);	
    

   //Reset Testing	
   #(2*`clock_period)
   reset = 1'b0;
   #(2*`clock_period) 
   raA = 32'h03; raB = 32'h04;  op = 4'b0010;
   #(2*`clock_period)
   $display("(right value = 0)ADD operation 3 NOR 4 = %d while RESET Enabled",outwire);

   
end 

// Generate clock by inverting the signal every half of clock period
always 
   #(`clock_period / 2) clock = ~clock;  
   
endmodule

