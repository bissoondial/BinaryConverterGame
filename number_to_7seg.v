//in: 8-bit (4-digit) number, 0-256
    //converts it to digits then converts each digit to 8-bit code
//out: 32-bit 4-digit segment code

module number_to_7seg(input [7:0] number,
                     output [27:0] code);

wire[3:0] ones, tens, hundreds;
wire[6:0] ones_digit;
wire[6:0] tens_digit;
wire[6:0] hundreds_digit;
wire[6:0] thousands_digit = 7'b1111111;

Binary2BCD bcd(number, ones, tens, hundreds);

BCD2Digit digit0(ones, ones_digit);
BCD2Digit digit1(tens, tens_digit);
BCD2Digit digit2(hundreds, hundreds_digit);

assign code = {thousands_digit, hundreds_digit, tens_digit, ones_digit};

endmodule