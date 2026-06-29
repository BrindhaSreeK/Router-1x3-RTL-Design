module router_fsm (
          input clock,resetn,pkt_valid,parity_done,
	     input soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,
	     input fifo_empty_0,fifo_empty_1,fifo_empty_2,low_pkt_valid,
	     input [1:0] data_in,
	     output busy,detect_add,ld_state,laf_state,full_state,
	     output write_enb_reg,rst_int_reg,lfd_state
		 );
		 
		   parameter   DECODE_ADDRESS = 3'b000,
		               LOAD_FIRST_DATA = 3'b001,
					   LOAD_DATA = 3'b010,
					   LOAD_PARITY = 3'b011,
					   CHECK_PARITY_ERROR = 3'b100,
					   FIFO_FULL_STATE = 3'b101,
					   LOAD_AFTER_FULL = 3'b110,
					   WAIT_TILL_EMPTY = 3'b111;
					   
	    reg [1:0] addr;
		reg [2:0] present_state,next_state;
		
		always@(posedge clock)
		begin 
		   if(!resetn)
		       addr <= 2'b00;
			  
			 else if(detect_add)
			       addr <= data_in;
		end 
		
		always@(posedge clock)
		   begin 
		      if(!resetn)
			    present_state <= DECODE_ADDRESS;
				
			  else if( ((soft_reset_0) && (data_in == 2'b00)) || ((soft_reset_1) && (data_in == 2'b01)) || ((soft_reset_2) && (data_in == 2'b10)))
			     present_state <= DECODE_ADDRESS;
				 
			  else 
			     present_state <= next_state;
				 
			end 
			
			
			
		always@(*)
		  begin 
		     case(present_state)
			        
	                 DECODE_ADDRESS : begin 
					                     if ( (pkt_valid && data_in[1:0]==2'b00 && fifo_empty_0)||
									        (pkt_valid && data_in[1:0]==2'b01 && fifo_empty_1)||
										    (pkt_valid && data_in[1:0]==2'b10 && fifo_empty_2))
										  
										       next_state = LOAD_FIRST_DATA;
										    
									     else if ((pkt_valid) && (data_in[1:0]==2'b00) && (!fifo_empty_0)||
									               (pkt_valid) &&(data_in[1:0]==2'b01) && (!fifo_empty_1)||
										           (pkt_valid)&&(data_in[1:0]==2'b10) && (!fifo_empty_2))
										  
										                next_state = WAIT_TILL_EMPTY;
														
									      else 
									                next_state = DECODE_ADDRESS;
													
										end 
										
					  LOAD_FIRST_DATA : begin 
					               
								          next_state = LOAD_DATA;
										end 
										
					  LOAD_DATA : begin 
					                   if(!fifo_full && !pkt_valid)
									      
										  next_state = LOAD_PARITY;
										  
										else if(fifo_full)
										  next_state = FIFO_FULL_STATE;
										  
										else 
										   next_state = LOAD_DATA;
									end 
									
					  LOAD_PARITY :   begin 
						               next_state = CHECK_PARITY_ERROR;
									   end 
									   
					CHECK_PARITY_ERROR : begin 
						                      if(fifo_full)
											        next_state = FIFO_FULL_STATE;
											   
											  else if(!fifo_full)
											        next_state = DECODE_ADDRESS;
											   
											  
										  end 
										  
					FIFO_FULL_STATE : begin 
					                        if(!fifo_full)
											   next_state = LOAD_AFTER_FULL;
											   
											else if(fifo_full)
											       next_state = FIFO_FULL_STATE;
												   
										    else 
											     next_state = FIFO_FULL_STATE;
									    end 
										
					LOAD_AFTER_FULL : begin 
					                        if(parity_done)
											    next_state = DECODE_ADDRESS;
												
											else if(!parity_done && low_pkt_valid)
											   next_state = LOAD_PARITY;
											   
											else if(!parity_done && !low_pkt_valid)
											   next_state = LOAD_DATA;
											   
											else 
											   next_state = LOAD_AFTER_FULL;
									    end 
										
					WAIT_TILL_EMPTY : begin 
					                    if((fifo_empty_0 && addr == 2'b00) || (fifo_empty_1 && addr == 2'b01)
										   || (fifo_empty_2 && addr == 2'b10))
										   
										   next_state = LOAD_FIRST_DATA;
										else
										  next_state = WAIT_TILL_EMPTY;
									 end 
									 
							default : next_state = DECODE_ADDRESS;
					endcase 
									 
		    end 
			
    assign busy = (( present_state == LOAD_FIRST_DATA) || (present_state== LOAD_PARITY) ||
	              (present_state == FIFO_FULL_STATE) || (present_state==LOAD_AFTER_FULL)||
				  (present_state == WAIT_TILL_EMPTY) || (present_state== CHECK_PARITY_ERROR));
				  
	assign detect_add = (present_state==DECODE_ADDRESS);
	assign lfd_state = (present_state == LOAD_FIRST_DATA);
	assign ld_state = (present_state== LOAD_DATA);
	assign write_enb_reg = (present_state == LOAD_DATA) || (present_state==LOAD_AFTER_FULL)||
	                       (present_state == LOAD_PARITY);
	assign full_state = (present_state == FIFO_FULL_STATE);
	assign laf_state = (present_state==LOAD_AFTER_FULL);
	assign rst_int_reg = (present_state== CHECK_PARITY_ERROR);
	
endmodule 
											   
											   
											  
												
										   
										   
										  