

module pic();
	reg master_clk, reset;
	reg [11:0]pc;
	wire clk_pc, clk_instruction_memory, clk_alu, clk_registers;

	wire [11:0] current_instruction;
	wire [3:0] opcode;
	wire [6:0] register_address;
	wire enable_instr_reg;
	wire [11:0] instruction_reg_out;
	wire [7:0] registers_out;
	wire [7:0] w_reg_out;
  	wire [7:0] alu_out;

	pc pc_pic (clk_pc, reset, pc);
	flash_program_memory instruction_memory (clk_instruction_memory, pc, current_instruction);
	// El instruction register hace forward de la instruccion 
  	instruction_register instruction_register(clk_instruction_memory, current_instruction, opcode, 
  		register_address , enable_instr_reg);
 
 
  	w_register w_register (clk_registers, ~enable_instr_reg, alu_out, w_reg_out);
    
    registers registers(clk_registers, enable_instr_reg, register_address, alu_out, registers_out);

  	alu_version_1 alu (clk_alu, opcode, w_reg_out, registers_out, alu_out);

	
	// Clock Management
	clock_divisor clock_divisor (master_clk,
								 clk_pc, 
								 clk_instruction_memory, 
								 clk_alu,
								 clk_registers);
    initial begin
      #1 reset =1;
      #1 master_clk = 1;
      #1 master_clk = 0;
      #1 master_clk = 1;
      #1 master_clk = 0;
      #1 master_clk = 1;
      #1 master_clk = 0;
      #1 master_clk = 1;
      #1 master_clk = 0;
      #1 master_clk = 1;
      #1 master_clk = 0;
      #1 master_clk = 1;
      #1 master_clk = 0;
      #1 reset = 0;
      //clk_instruction_memory = 0;
      //clk_alu = 0;
      //clk_registers = 0;
    end
  
	initial
 	 #500 $finish;
  

	always
		#5	master_clk = !master_clk;

  initial begin
    $display ("   \t\tCLK0\tCLK1\tCLK2\tCLK3\tPC\tCURRENT\tOPCODE\tF-ADDR\tW-REG\tF-REGS\tALU-OUT");
    $monitor("   \t\t%b\t%b\t%b\t%b\t%h\t%h\t%h\t%h\t%h\t%h\t%h", clk_pc, 
    	clk_instruction_memory, 
    	clk_alu, 
    	clk_registers,
    	pc, 
    	current_instruction,
    	opcode,
        register_address,
    	w_reg_out,
    	registers_out,
    	alu_out);

    //Monitor Clocks
    //$display ("   CLK0\tCLK1\tCLK2\tCLK3");
    //$monitor("   %b\t%b\t%b\t%b", clk_pc, clk_instruction_memory, clk_alu, clk_registers);
  end

endmodule 

