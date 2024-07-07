//in: four 8-bit segment codes; 2-bit selector
//out: one of those four, chosen by the selector

/*module letter_mux(  input [6:0] digit_0,
                    input [6:0] digit_1,
                    input [6:0] digit_2,
                    input [6:0] digit_3,
                    input [1:0] sel,
                   output [6:0] choice*/
 
 module letter_mux( input [27:0] word,
                    input [1:0] sel,
                   output reg [6:0] choice,
                   output reg [3:0] anode);

always @ (sel) begin
    case(sel)
        3: begin
             anode = 4'b0111;
             choice = word[6:0]; 
        end
        2: begin
            anode = 4'b1011;
            choice = word[13:7];
        end
        1: begin 
             anode = 4'b1101;
             choice = word[20:14];
        end
        0: begin
             anode = 4'b1110;
             choice = word[27:21];
        end
    endcase
end


endmodule