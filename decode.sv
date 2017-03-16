


module decode(
	input clock,
	input reset,
	input [15:0]	npc_in,
	input enable_decode,
	input [15:0]	instr_dout,
	input [2:0]	psr,
	output logic [15:0]	IR,
	output logic [5:0]	E_control,
	output logic [15:0]npc_out,
	output logic Mem_Control,
	output logic [1:0]	W_Control
);

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

	//W_Control
	case(Instr_dout[15:12])
	0001	:	
	0101	:
	1001	:
	
end

endmodule