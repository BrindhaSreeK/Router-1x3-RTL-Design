 module tb_router_sync;
        reg detect_add,clock,resetn,write_enb_reg;
		reg read_enb_0,read_enb_1,read_enb_2;
        reg [1:0] data_in;
        reg  empty_0,empty_1,empty_2;
        reg  full_0,full_1,full_2;
        wire soft_reset_0,soft_reset_1,soft_reset_2;
		wire  [2:0] write_enb;
		wire fifo_full;
		wire vld_out_0,vld_out_1,vld_out_2;
		
		router_sync dut (
		                 .detect_add(detect_add),
						 .clock(clock),
						 .resetn(resetn),
						 .write_enb_reg(write_enb_reg),
						 .read_enb_0(read_enb_0),
						 .read_enb_1(read_enb_1),
						 .read_enb_2(read_enb_2),
						 .data_in(data_in),
						 .empty_0(empty_0),
						 .empty_1(empty_1),
						 .empty_2(empty_2),
						 .full_0(full_0),
						 .full_1(full_1),
						 .full_2(full_2),
						 .soft_reset_0(soft_reset_0),
						 .soft_reset_1(soft_reset_1),
						 .soft_reset_2(soft_reset_2),
						 .write_enb(write_enb),
						 .fifo_full(fifo_full),
						 .vld_out_0(vld_out_0),
						 .vld_out_1(vld_out_1),
						 .vld_out_2(vld_out_2)
						);
		initial
		  begin 
		      clock = 1'b0;
			 end 
		always #10 clock = ~clock;
		
		
		
		task initialize;
		  begin 
		 {detect_add,clock,resetn,write_enb_reg,read_enb_0,read_enb_1,read_enb_2} = 7'b0;
		 {data_in,full_0,full_1,full_2} = 8'b0;
		 {empty_0,empty_1,empty_2}= 3'b111;
		 end 
		
		endtask 
		
		task resetnn;
		  begin 
		     @(negedge clock)
			    resetn = 1'b1;
			end 
		endtask 
		
		task  address;
		 input [1:0]k;
		 input z;
		 begin 
		     @(negedge clock)
                        begin 
			   data_in = k;
			   detect_add = z;
                         end 
		 end 
		endtask
		
		
		task write;
		 input l;
		 begin 
		     @(negedge clock)
			   write_enb_reg = l;
		 end 
		endtask 
		
		task read;
		input a,b,c;
		begin 
		   @(negedge clock)
		     {read_enb_0,read_enb_1,read_enb_2} = { a,b,c};
		end 
		endtask
		
		task emptyy;
		 input e,f,g;
		 begin 
		    @(negedge clock)
			  {empty_0,empty_1,empty_2} = {e,f,g};
		  end 
		endtask 
		
		task fulll;
		input h,i,j;
		  begin 
		     @(negedge clock)
			  {full_0,full_1,full_2} = {h,i,j};
		  end 
		endtask 
		task wait_cycle;
		  input integer n;
		  integer p;
		  begin 
		    for(p=0;p<n;p=p+1)
			      @(negedge clock);
		  end 
		endtask
		
		initial begin 
		   initialize;
		   resetnn;
		   address(2'b00,1'b1);
		   address(2'b00,1'b0);
		   write(1'b1);
		   emptyy( 1'b0,1'b0,1'b0);
		   wait_cycle(30);
		   read(1'b1,1'b1,1'b1);
		   fulll(1'b1,1'b0,1'b0);
		   fulll(1'b0,1'b0,1'b0);
		   write(0);
		   wait_cycle(3);
		   
		   address (2'b01,1'b1);
		   address (2'b01,1'b0);
		   write(1'b1);
		   fulll(1'b0,1'b1,1'b0);
		   wait_cycle(2);
		   fulll(1'b0,1'b0,1'b0);
		   
		   wait_cycle(2);
		   address (2'b10,1'b1);
		   address (2'b10,1'b0);
		   write(1);
		   fulll(1'b0,1'b0,1'b1);
		   wait_cycle(2);
		   fulll(1'b0,1'b0,1'b0);
		    #100; $finish;
		end 
endmodule 
