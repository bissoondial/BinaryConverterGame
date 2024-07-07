
`timescale 1ns / 1ps

`define TEST 2'b00
`define WAIT_CORRECT 2'b01
`define WAIT_WRONG 2'b10
`define RESET 2'b11

//0100001_1100010_1100010_1000010
//1000100_1100010_1100011_1101010
//                   |G      |o      |o      |d
`define STR_GOOD  28'b0100001_1100010_1100010_1000010
//                   |Y      |o      |u      |r
`define STR_YOUR  28'b1000100_1100010_1100011_1101110
//                   |S      |c      |o      |r
`define STR_SCORE 28'b0100100_1110010_1100010_1111010
//                   |F      |A      |I      |L
`define STR_FAIL  28'b0111000_0001000_1111001_1110001
//                   |r      |E      |S      |E.   
`define STR_RESET 28'b1111010_0110000_0100100_0110000            
//                   |Y      |o      |u      |<blank>
`define STR_YOU   28'b1000100_1100010_1100011_1111111
//                   |S      |A      |I      |d
`define STR_SAID  28'b0100100_0001000_1111001_1000010

module main (input [7:0] sw, input clk, input enter_button, input home_button, output [6:0] seg, output [3:0] an, output [7:0] led);

reg [7:0] rand_num;
reg [7:0] score = 0;
reg [7:0] num_in;


reg [1:0] state = `RESET;

reg [7:0] wrong_answer;

reg [27:0] word; // 8 * 4 values â€" the four digits and the dot
wire [27:0] num_out; // always the output of the number converter

wire [3:0] mux_out;
wire [1:0] counter_out;
wire [7:0] random_out;

reg [30:0] counterA = 0;
reg [30:0] counterB = 0;

reg [7:0] blinker_in = 0;

reg [0:0] entered = 0;

number_to_7seg num_converter(num_in, num_out); //converts the inputted 4-digit number into a segments code
slowclock u2(clk, clk_out);
counter u3(clk_out, counter_out); //cycles 0, 1, 2, 3, 0...

letter_mux word_mux(word, counter_out, seg, an); //outputs a digit/letter from the counter and sets AN

lightblinker blinker(clk_out, blinker_in, led);

Random random_gen(clk_out, random_out);



always @ (posedge clk_out) begin
    if(state == `RESET) begin
        if(counterA == 0) begin 
            blinker_in <= 0; //disable light-blinking
            rand_num <= random_out; //set random value
        end
        else if(counterA == 'd10) begin
            num_in <= rand_num; //feed the number into the number to 7seg converter
        end
        else if(counterA == 'd10) begin
            word <= num_out; //set display to show output of 7seg converter
        end
        if(counterA >= 'd10 && enter_button) begin
            counterA <= 0;
            state <= `TEST; //move to TEST state
        end
        counterA <= (counterA + 1);
    end
    else if(state == `TEST) begin
            if(sw == rand_num) begin //if user is right: increment score. say "good", "score", and display score, then go to wait state
                score <= score + 1;
                word <= `STR_GOOD;
                num_in <= score; //put score into number to 7seg converter
                state <= `WAIT_CORRECT;                              
            end
            else begin //if user is wrong: reset score. say "fail", "score", and display score then go to wait state
                wrong_answer <= sw;
                score = 0;
                blinker_in <= rand_num;
                word <= `STR_FAIL;
                num_in <= wrong_answer;
                state <= `WAIT_WRONG; 
           end
    end
    else if(state == `WAIT_CORRECT) begin
        
        if(counterB == 'd10) begin
            counterB <= 0;
            state <= `RESET;
        end 
        counterB <= (counterB + 1);
    end
    else if(state == `WAIT_WRONG) begin
        if(counterB == 'd10) begin
            counterB <= 0;
            state <= `RESET;
        end 
        counterB <= (counterB + 1);
    end
    
end

endmodule
   