//in: 2-bit counter
//out: 4-bits, with the relevant one from the counter turned on

module decoder2to4 (input [1:0] counter,
                   output [3:0] anode);

assign anode = (counter==2'b00)?4'b1110 : (counter==2'b01)?4'b1101 : (counter==2'b10)?4'b1011: 4'b0111;

endmodule