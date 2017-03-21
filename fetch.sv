//TO DO: check the task calling and fork join and posedge

class Fetch_sb;

	// //declaring inputs
	// logic		enable_updatePC;
	// logic		enable_fetch;
	// logic	[15:0]	taddr;
	// logic		br_taken;

	//declaring outputs
	logic		instrmem_rd;
	logic	[15:0]	pc;
	logic	[15:0]	npc;

	virtual LC3_io top_io;
	virtual dut_Probe_if fetch_if;

	function new(virtual LC3_io top_io, virtual dut_Probe_if fetch_if);
		this.top_io = top_io;
		this.fetch_if = fetch_if;	
	endfunction

	task reset;
		pc = 16'h3000;
		npc = pc + 1;
		instrmem_rd = 1'b1;
	endtask : reset

	task run_fetch;
		if(top_io.reset)
		begin
			reset();
		end : if reset

		else
		begin
			if(fetch_if.fetch_enable_fetch)
			begin
				instrmem_rd = 1'b1;
			end
			else
			begin
				instrmem_rd = 1'b0;
			end
			if(fetch_if.fetch_enable_updatePC)
			begin
				if(fetch_if.fetch_br_taken)
				begin
					pc = fetch_if.fetch_taddr;
				end
				else
				begin
					pc = pc+1;
				end
			end
			npc = pc+1;
		end : else block
	endtask : run_fetch

	task check_fetch;
	//@(posedge top_io.clock)
       		 if(instrmem_rd !== fetch_if.fetch_instrmem_rd)
       			 $display($time,"BUG IN FETCH DUT instrmem_rd_DUT = %h | instrmem_rd = %h\n",fetch_if.fetch_instrmem_rd,instrmem_rd);	
       		 if(pc !== fetch_if.fetch_pc)
       			 $display($time,"BUG IN FETCH DUT pc_DUT = %h | pc = %h\n",fetch_if.fetch_pc,pc);	
       		 if(npc !== fetch_if.fetch_npc)
       			 $display($time,"BUG IN FETCH DUT npc_DUT = %h | npc = %h\n",fetch_if.fetch_npc,npc);	
	endtask : check_fetch

endclass
