module tb_router_fsm;
         reg clock,resetn,pkt_valid,parity_done;
	     reg soft_reset_0,soft_reset_1,soft_reset_2,fifo_full;
	     reg fifo_empty_0,fifo_empty_1,fifo_empty_2,low_pkt_valid;
	     reg [1:0] data_in;
		 wire busy,detect_add,ld_state,laf_state,full_state;
	     wire write_enb_reg,rst_int_reg,lfd_state;
		 
		 router_fsm dut (
		 
		                 .clock(clock),
						 .resetn(resetn),
						 .pkt_valid(pkt_valid),
						 .parity_done(parity_done),
						 .soft_reset_0(soft_reset_0),
						 .soft_reset_1(soft_reset_1),
						 .soft_reset_2(soft_reset_2),
						 .fifo_full(fifo_full),
						 .fifo_empty_0(fifo_empty_0),
						 .fifo_empty_1(fifo_empty_1),
						 .fifo_empty_2(fifo_empty_2),
						 .low_pkt_valid(low_pkt_valid),
						 .data_in(data_in),
						 .busy(busy),
						 .detect_add(detect_add),
						 .ld_state(ld_state),
						 .laf_state(laf_state),
						 .full_state(full_state),
						 .write_enb_reg(write_enb_reg),
						 .rst_int_reg(rst_int_reg),
						 .lfd_state(lfd_state)
						 );
						 
	    initial begin 
		   clock = 1'b0;
		   end 
		   
		   always #10 clock = ~clock;
		   
		   task initialize;
		        begin 
				    {resetn,pkt_valid,parity_done} = 3'b0;
					{soft_reset_0,soft_reset_1,soft_reset_2,fifo_full}= 4'b0;
					{fifo_empty_0,fifo_empty_1,fifo_empty_2,low_pkt_valid}= 4'b0;
					  data_in = 2'b00;
				end 
			endtask 
			
			task reset;
			  begin 
			      @(negedge clock)
				      resetn = 1'b1;
				end 
			endtask 
			
			 // less than 14 
			task first;
			 begin 
			    @(negedge clock)
				   pkt_valid = 1'b1;
				   data_in = 2'b10;
				   fifo_empty_2 = 1'b1;
				@(negedge clock);
				@(negedge clock)
				   fifo_full = 1'b0;
				   pkt_valid = 1'b0;
				@(negedge clock);
				@(negedge clock)
				  fifo_full = 1'b0;
			 end 
			endtask 
			
			  // equal to 14 
			
			task second;
			  begin 
			    @(negedge clock)
				   pkt_valid = 1'b1;
				   data_in = 2'b10;
				   fifo_empty_2 = 1'b1;
				@(negedge clock);
				@(negedge clock)
				  fifo_full = 1'b0;
				  pkt_valid = 1'b0;
				@(negedge clock);
				@(negedge clock)
				  fifo_full = 1'b1;
				@(negedge clock)
				  fifo_full = 1'b0;
				@(negedge clock)
				  parity_done = 1'b1;
			  end 
			endtask 
			
			   // greater than 14
			   
			task third;
			  begin 
			  
			     @(negedge clock)
				   pkt_valid = 1'b1;
				   data_in = 2'b10;
				   fifo_empty_2 = 1'b1;
			    @(negedge clock);
				@(negedge clock)
				  fifo_full = 1'b1;
				@(negedge clock)
				  fifo_full = 1'b0;
				@(negedge clock)
				  parity_done = 1'b0;
				  low_pkt_valid = 1'b0;
				@(negedge clock)
				   fifo_full= 1'b0;
				   pkt_valid = 1'b0;
				@(negedge clock);
				@(negedge clock)
				  fifo_full = 1'b0;
			  end 
			endtask 
			
			task fourth;
			  begin 
			  
			     @(negedge clock)
				   pkt_valid = 1'b1;
				   data_in = 2'b10;
				   fifo_empty_2 = 1'b1;
			    @(negedge clock);
				@(negedge clock)
				  fifo_full = 1'b1;
				@(negedge clock)
				  fifo_full = 1'b0;
				@(negedge clock)
				  parity_done = 1'b0;
				  low_pkt_valid = 1'b1;
				@(negedge clock);
				@(negedge clock)
				  fifo_full = 1'b0;
				end 
			endtask 
			
	initial begin 
	   
	         initialize;
			 reset;
			 //first;
			 //second;
			// third;
			 fourth;
			 
			 #100; $finish;
			end 
			
endmodule 
			 
			 
				   
			    
				  
				
			      
			   
				
				  
			  
			     
				  
				
					
						 
						 
		             
		 