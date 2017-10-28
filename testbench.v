

module pic();
	reg master_clk, reset;
	reg [11:0]pc;
	wire clk_pc, clk_instruction_memory, clk_alu, clk_registers;

	wire [13:0] current_instruction;
	wire [5:0] full_opcode;
	wire[1:0] type_opcode, op_type;
	wire [3:0] opcode;
	wire inmediate_enable;
	wire [6:0] register_address;
	wire enable_instr_reg;
	wire [11:0] instruction_reg_out;
	wire [7:0] registers_out;
	wire [7:0] w_reg_out;
	wire [7:0] inmediate_value;
  	wire [7:0] alu_out, alu_in;
  	wire [10:0] inmediate_goto;
  	wire enable_nop;
  	wire return_enable;
  	wire [11:0] return_value;
  	wire enable_goto;
  	wire call_enable;
  	wire return_opcode_value;
	
	pc pc_pic (
		clk_pc,
		enable_goto,
		inmediate_goto,
		return_enable,
		return_value,
		reset,
		pc);

	flash_program_memory instruction_memory (
		clk_instruction_memory,
		enable_nop,
		pc,
		current_instruction);

	// El instruction register hace forward de la instruccion 
	instruction_register instruction_register(
		clk_instruction_memory,
		current_instruction,
		full_opcode, 
		register_address,
		inmediate_value,
		op_type,
		enable_instr_reg,
		inmediate_goto,
		inmediate_enable);
	 
 
  	w_register w_register (
		clk_registers,
		~enable_instr_reg,
		op_type,
		return_opcode_value,
		alu_out,
		w_reg_out);

    registers registers(
		clk_registers,
		enable_instr_reg,
		op_type,
		register_address,
		alu_out,
		registers_out);

    mux_inmediate mux_inmediate(
		inmediate_enable,
		inmediate_value,
		registers_out,
		alu_in);
  	
  	decode decode(
		full_opcode,
		type_opcode,
		opcode);

  	alu_version_1 alu (
		clk_alu,
		opcode, 
		type_opcode,  
		w_reg_out, 
		alu_in,
		alu_out);

  	stack stack(
  		call_enable,
  		pc,
  		return_enable,
  		return_value);

  	assign call_enable = (type_opcode==2&&opcode[3]==0);
	assign enable_goto = type_opcode[1] && ~type_opcode[0];
	assign return_opcode_value = current_instruction[7:0] == 8;
	/*Se ejecuta un NOP solo si:
		LA ALU regresa un  0 y ademas el opcode es 11 o 15 (DECFSZ / INCFSZ)

	*/
	assign enable_nop = ((alu_out == 0) &&
						(type_opcode==0&&opcode==11||
						 type_opcode==0&&opcode==15)) ;

	assign return_enable = ( (full_opcode==0 && register_address==8) || (type_opcode==3&&opcode[3]==0&&opcode[2]==1) );
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
 	 #1000 $finish;
  

	always
		#5	master_clk = !master_clk;

  initial begin
    $display ("   \t\tCLK0\tCLK1\tCLK2\tCLK3\tPC\tCURRENT\tTYPEOP\tOPCODE\tINMEDIATE\tF-ADDR\tW-REG\tF-REGS\tALU-OUT");
    $monitor("   \t\t%b\t%b\t%b\t%b\t%d\t%h\t%d\t%d\t%d\t%d\t%d\t%d", clk_pc, 
    	clk_instruction_memory, 
    	clk_alu, 
    	clk_registers,
    	pc, 
    	current_instruction,
    	type_opcode,
        opcode,
        inmediate_value,
        register_address,
    	w_reg_out,
    	registers_out,
    	alu_out);


    // $display ("   \t\tPC\tCURRENT\tTYPEOP\tOPCODE\tINMEDIATE\tF-ADDR\tALUIN\t\tW-REG\tF-REGS\tALU-OUT");
    // $monitor("   \t\t%d\t%h\t%d\t%d\t%d\t%d\t%d\t%d\t%d", 
    // 	pc, 
    // 	current_instruction,
    // 	type_opcode,
    //     opcode,
    //     inmediate_value,
    //     register_address,
    //     alu_in,
    // 	w_reg_out,
    // 	registers_out,
    // 	alu_out);
    //Monitor Clocks
    //$display ("   CLK0\tCLK1\tCLK2\tCLK3");
    //$monitor("   %b\t%b\t%b\t%b", clk_pc, clk_instruction_memory, clk_alu, clk_registers);
  end

endmodule 

