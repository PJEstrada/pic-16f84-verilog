module pc(input clk,input reset, output[11:0] pc);
  /*
  	PROGRAM COUNTER: este modulo incrementa el pc en uno cada vez
  	que cambie el reloj. Y lo setea a 0 cuando recibe la señal de 
  	reset.
  */
  reg [11:0] pc;
  always @(posedge clk ) begin
    if (reset) begin
      pc <= 0;
    end 
   	else begin
    	pc <= pc + 1;
      end
  end
endmodule


module flash_program_memory(
  input clk,
  input [11:0] addr,
  output [11:0]instruction
);
	/*
		Este modulo se encarga de leer una nueva instruccion de la memoria
		en cada cambio de reloj y lo coloca en el output instruction.
	*/
	reg [11:0] instruction;
    reg [11:0] memory [0:1024]; // Este numero debe cambiar dependiendo el tamaño del archivo


	always @(posedge clk) begin
		instruction <= memory[addr];
	end


	initial begin
	$readmemh("test.asm", memory);
	end

endmodule

module alu_version_1(input clk, input[3:0] opcode,
 input[7:0] w_reg, input[7:0] f_reg, output[7:0] result);

	reg[7:0] result;
	always @(posedge clk) begin
		case (opcode)
		0: begin
		// MOVWF
			result <= w_reg;
		end
		1: begin
		// CLRF
			result <= 0;
		end
		2: begin
		// SUBWF
			result <= f_reg - w_reg; 
		end
		3: begin
		// DECF
			result <= f_reg - 1; 
		end
		4: begin
		// IORWF
			result <= f_reg || w_reg; 
		end
		5: begin
		// AND
			result <= f_reg && w_reg; 
		end
		6: begin
		// XORWF
			result <= f_reg ^ w_reg; 
		end
		7: begin
		// ADDWF
			result <= f_reg + w_reg; 
		end
		8: begin
		// MOVF
			result <= f_reg; 
		end
		9: begin
		// COMF
			result <= ~f_reg; 
		end
		10: begin
		// INCF
			result <= f_reg + 1; 
		end
		11: begin
		// MOVF
			//TODO: Pendiente el JUMP
			result <= f_reg - 1 ; 
		end
		12: begin
		// RLF
			//TODO: Tomar en cuenta la carry flag.
			result <=  f_reg << 0 ; 
		end
		13: begin
		// RRF
			result <= f_reg >> 0 ; 
		end
		14: begin
		// SWAPF
			result[3:0] <= f_reg[7:4];
			result[7:4] <= f_reg[3:0]; 
		end
		15: begin
		// INCFSZ
			//TODO: Pendiente la ejecucion del NOP (Doble ciclo)
			result <= f_reg + 1; 
		end													
        endcase
	end

endmodule

module instruction_register(input clk,
                            input [11:0]current_instr,
                            output [3:0] opcode,
                            output [6:0] register_address,
                            output enable);

	assign opcode = current_instr[11:8];

	// Usualmente son 7 bits para el register address porque hay uno para el bit "d".
	// TODO: Agregar logica para cuando las instrucciones
	//		no son con bit d. (Ejemplo: inmediatos)
	assign register_address = current_instr[6:0];
	
	assign enable = current_instr[7];

endmodule


module registers(input clk,
				 input save_data_enable,
				 input [6:0] address,
                 input [7:0] data_in,
				 output[7:0] reg_value);

	reg [7:0] registers_memory [0:128];
	wire [7:0] reg_value; 

  	assign reg_value = registers_memory[address];
  
  	always @ (posedge clk) begin
      	if(save_data_enable) begin
          registers_memory[address] <= data_in;
      	end
  	end
    // initialize
  	integer i;
  	initial begin
      for (i = 0; i < 128; i= i + 1) 
        registers_memory[i] = 0;
    end
endmodule


module w_register(input clk, input enable_write,
 input[7:0] indata, output [7:0] outdata );
	/*
		Este modulo se encarga de maneja la logica de escritura / lecture
		para el W Register.
	*/
	reg [7:0] outdata;

	always @(posedge clk) begin
		if (enable_write) begin
			outdata <= indata;
		end
	end
  	initial begin
    	outdata = 0;
    end
endmodule
/*
module mux_inmediate(input enable, input[7:0] inm, input[7:0] registers_out,
	output[7:0] out);
	if(enable)begin
		assign out = inm;
	end
	else begin
		assign out = registers_out;
	end
endmodule
*/
module clock_divisor(input clk,
                      output clk0_out,
                      output clk1_out,
                      output clk2_out,
                      output clk3_out);
	/*
		Este reloj retorna la señal contraria al reloj de input.
	*/
	reg clk0_out,clk1_out,clk2_out,clk3_out;
	always @(posedge clk) begin
		if(clk0_out == 1)begin
			clk0_out <= 0;
			clk1_out <= 1;
			clk2_out <= 0;
			clk3_out <= 0;
		end
		else if(clk1_out == 1)begin
			clk0_out <= 0;
			clk1_out <= 0;
			clk2_out <= 1;
			clk3_out <= 0;
		end
		else if(clk2_out == 1)begin
			clk0_out <= 0;
			clk1_out <= 0;
			clk2_out <= 0;
			clk3_out <= 1;
		end
		else if(clk3_out == 1)begin
			clk0_out <= 1;
			clk1_out <= 0;
			clk2_out <= 0;
			clk3_out <= 0;
		end
	end
	initial begin
		clk0_out = 1;
		clk1_out = 0;
		clk2_out = 0;
		clk3_out = 0;

	end

endmodule