//in: 8-bit 1-digit segment code
//out: 8-digit 1-digit display (with periods)

module segment_displayer(input [6:0] choice_word,
                        output [6:0] display);

assign display = choice_word;

endmodule