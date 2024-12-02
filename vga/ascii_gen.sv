`timescale 1ns / 1ps

module ascii_gen(
    input clk,
    input video_on,
	 input [31:0] correct_index_x, correct_index_y,
    input [9:0] x, y,
    output reg [7:0] rgb_r, rgb_g, rgb_b
    );
    
    // signal declarations
    wire [10:0] rom_addr;           // 11-bit text ROM address
    wire [6:0] ascii_char;          // 7-bit ASCII character code
    wire [3:0] char_row;            // 4-bit row of ASCII character
    wire [2:0] bit_addr;            // column number of ROM data
    wire [7:0] rom_data;            // 8-bit row data from text ROM
	 wire [11:0] letter_index;
    wire ascii_bit, ascii_bit_on;   // ROM bit and status signal
	 wire selection;                 // prompt selection 
	 
	
    // instantiate ASCII ROM
    ascii_rom rom0(.clk(clk), .addr(rom_addr), .data(rom_data));
	 // instantiate prompt ROM
	 prompt_rom rom1(.selection(selection), .letter_index(letter_index), .letter_out(ascii_char));
      
    // ASCII ROM interface
    assign rom_addr = {ascii_char, char_row};   // ROM address is ascii code + row
    assign ascii_bit = rom_data[~bit_addr];     // reverse bit order

    assign char_row = y[3:0];               // row number of ascii character rom
    assign bit_addr = x[2:0];               // column number of ascii character rom
    
    // bit on/off and letter index
	 always @* begin
		if (y < 208) begin 
		   // title
			ascii_bit_on = ((x >= 360 && x < 568) && (y >= 112 && y < 128)) ? ascii_bit : 1'b0;
			letter_index = ((x-360) >> 3);
			selection = 0;
		end else begin     
		   // main prompt
			ascii_bit_on = ((x >= 208 && x < 720) && (y >= 208 && y < 288)) ? ascii_bit : 1'b0;
			letter_index = ((x-208) >> 3) + (((y-208) & 8'hF0) << 2);
			selection = 1;
		end
	 end
	 
	 // rgb multiplexing circuit
    always @* begin
			if(~video_on) begin
            // blank
				rgb_r = 0;
				rgb_g = 0;
				rgb_b = 0;
			end else begin
            if(ascii_bit_on) begin
					 if (y < 208) begin
					 		 rgb_r = 8'hFF;	// orange letters
							 rgb_g = 8'h9F;
							 rgb_b = 8'h00;						
					 end else if (((y-208) >> 4) == correct_index_y) begin 
						 if (((x-208) >> 3) >= correct_index_x) begin
							 rgb_r = 8'hFF;	// white letters
							 rgb_g = 8'hFF;
							 rgb_b = 8'hFF;
						 end else begin
							 rgb_r = 8'h00;	// green letters
							 rgb_g = 8'hFF;
							 rgb_b = 8'h00;
						 end
					 end else if (((y-208) >> 4) < correct_index_y) begin
							 rgb_r = 8'h00;	// green letters
							 rgb_g = 8'hFF;
							 rgb_b = 8'h00;					 
					 end else begin
					 		 rgb_r = 8'hFF;	// white letters
							 rgb_g = 8'hFF;
							 rgb_b = 8'hFF;
					 end
            end else begin
                rgb_r = 8'h4F;  // grey background
					 rgb_g = 8'h4F;
					 rgb_b = 8'h4F;
				end
			end
	 end
   
endmodule
