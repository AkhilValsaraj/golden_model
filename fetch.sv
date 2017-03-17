module fetch(
	input clock,
	input reset,
	input enable_updatePC,
	input enable_fetch,
	input [15:0] taddr,
	input br_taken,
	output logic [15:0] npc,
	output logic [15:0] pc,
	output logic instrmem_rd
);

logic [15:0] next_addr, next_pc;

assign npc = pc + 1;	//asynchronous npc

always@(posedge clock)
begin
	if(!reset)	//reset synchronously
		pc = 0;
	else
		pc = next_pc;
end

always@(*)
begin
	next_addr = (br_taken)? taddr: npc;	// choose branch
	next_pc = (enable_updatePC)? next_addr: pc;		//choose to update
end

endmodule