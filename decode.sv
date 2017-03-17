`include "opcode.sv"

module decode(
	input clock,
	input reset,
	input [15:0] npc_in,
	input enable_decode,
	input [15:0] instr_dout,
	input [2:0]	psr,
	output logic [15:0]	IR,
	output logic [5:0] E_control,
	output logic [15:0] npc_out,
	output logic Mem_Control,
	output logic [1:0] W_Control
);

logic mem_control, pcselect2, op2select;
logic [1:0] w_control,  alu_control, pcselect1;
logic [5:0] e_control;

always@(posedge clock)
begin
	if(!reset)
		begin
		IR	<=	0;
		npc_out	<=	0;		
		Mem_Control	<=	0;
		W_Control	<=	0;
		E_control	<=	0;
		end
	else
		if(enable_decode)	//assign the decode logic
			begin
			IR <= Instr_dout;
			npc_out<=npc_in;
			Mem_Control	<=	mem_control;
			W_Control	<=	w_control;
			E_control	<=	e_control;
			end
end

always@(*)
begin
	w_control = 0;
	alu_control = 0; 
	pcselect1 = 0; 
	pcselect2 = 0; 
	op2select = 0;
	mem_control = 0;
	
	//W_Control
	case(Instr_dout[15:12])
		`LD		: w_control = 1;
		`LDR	: w_control = 1;
		`LDI	: w_control = 1;
		`LEA	: w_control = 2;
		`ST		: w_control = 1;
		`STR	: w_control = 1;
		`STI	: w_control = 1;
	endcase
	
	//E_Control
	case(Instr_dout[15:12])
		`ADD	:
				if(Instr_dout[5]) 
					op2select = 1;				
		`AND	: 
				if(Instr_dout[5]) 
					begin
					alu_control = 1; op2select = 1;
					end 
				else 
					begin
					alu_control = 1;
					end
		`NOT	: begin alu_control = 2; end
		`BR		: begin pcselect1 = 1; pcselect2 = 1; end
		`JMP	: begin pcselect1 = 3; end
		`LD		: begin pcselect1 = 1; pcselect2 = 1; end
		`LDR	: begin pcselect1 = 2; end
		`LDI	: begin pcselect1 = 1; pcselect2 = 1; end
		`LEA	: begin pcselect1 = 1; pcselect2 = 1; end
		`ST		: begin pcselect1 = 1; pcselect2 = 1; end
		`STR	: begin pcselect1 = 2; end
		`STI	: begin pcselect1 = 1; pcselect2 = 1; end
	endcase

	e_control ={alu_control,pcselect1,pcselect2,op2select};
	
	
	//Mem_Control
	case(Instr_dout[15:12])
		`LDI	: mem_control = 1;
		`STI	: mem_control = 1;
	endcase
	
end

endmodule