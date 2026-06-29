module router_fifo(
input clock,resetn,write_enb,read_enb,lfd_state,soft_reset,
input [7:0] data_in,
output reg [7:0] data_out,
output empty,full
);

integer i;

reg [8:0] mem[0:15];

reg [4:0] wr_pointer;
reg [4:0] rd_pointer;

reg [6:0] count;

assign empty = (wr_pointer == rd_pointer);

assign full = (wr_pointer[4] != rd_pointer[4]) &&
              (wr_pointer[3:0] == rd_pointer[3:0]);

// write logic

always @(posedge clock)
begin
    if(!resetn)
    begin
        wr_pointer <= 5'd0;

        for(i=0;i<16;i=i+1)
            mem[i] <= 9'd0;
    end

    else if(soft_reset)
    begin
        wr_pointer <= 5'd0;

        for(i=0;i<16;i=i+1)
            mem[i] <= 9'd0;
    end

    else if(write_enb && !full)
    begin
        mem[wr_pointer[3:0]] <= {lfd_state,data_in};
        wr_pointer <= wr_pointer + 1'b1;
    end
end

// read logic

always @(posedge clock)
begin
    if(!resetn)
    begin
        data_out <= 8'd0;
        rd_pointer <= 5'd0;
    end

    else if(soft_reset)
    begin
        data_out <= 8'bz;
        rd_pointer <= 5'd0;
    end

    else if(read_enb && !empty)
		begin
			data_out <= mem[rd_pointer[3:0]][7:0];
			rd_pointer <= rd_pointer + 1'b1;
		end
	else if(count==0)
				data_out <= 8'bz;
		 
	
end

// packet counter

always @(posedge clock)
begin
    if(!resetn)
        count <= 7'd0;

    else if(soft_reset)
        count <= 7'd0;

  //  else 

    else if(read_enb && !empty)
		if(mem[rd_pointer[3:0]][8] == 1'b1)
        count <= mem[rd_pointer[3:0]][7:2] + 7'd1;
		else
        count <= count - 7'd1;
end

endmodule
