`timescale 1ns / 1ps

// vga controller

////////////////////////////////////////////////////////////////////////
module vga_controller (
	input CLOCK_50,           // 50 MHz
	input [1:0] KEY,
	input [1:0] GPIO,
	output VGA_HS,      // horizontal sync
	output VGA_VS,	     // vertical sync
	output [7:0] VGA_R,
	output [7:0] VGA_B,
	output [7:0] VGA_G,
	output VGA_CLK,
	output VGA_BLANK_N,
	output VGA_SYNC_N
);

	reg [9:0] counter_x = 0;  // horizontal counter
	reg [9:0] counter_y = 0;  // vertical counter
	
	reg clk25MHz;
	
	// IO signals
	wire reset;
	wire correct;
	integer correct_index_x;
	integer correct_index_y;
	// end IO signals

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// clk divider 50 MHz to 25 MHz
	always @(posedge CLOCK_50) begin
		if (reset) begin
			clk25MHz <= 0;
			correct_index_x <= 0;
			correct_index_y <= 0;
		end else begin
			clk25MHz <= ~clk25MHz;
			correct_index_x <= correct ? ((correct_index_x == 63) ? 0 : (correct_index_x + 1)) : correct_index_x;
			correct_index_y <= correct ? ((correct_index_x == 63) ? (correct_index_y + 1) : correct_index_y) : correct_index_y;
		end
	end
	// end clk divider 50 MHz to 25 MHz

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// counter and sync generation
	always @(posedge clk25MHz) begin // horizontal counter

			if (counter_x < 799) begin
			
				counter_x <= counter_x + 1;  // horizontal counter (including off-screen horizontal 160 pixels) total of 800 pixels 
				
			end else if (counter_x == 799) begin // only counts up 1 count after horizontal finishes 800 counts
				
					if (counter_y < 525) begin // vertical counter (including off-screen vertical 45 pixels) total of 525 pixels
						counter_y <= counter_y + 1;
					end else begin
						counter_y <= 0;              
					end
					
					counter_x <= 0;
					
			end else begin
			
				counter_x <= 0; 
				counter_y <= 0;
				
			end
		
	end
	// end counter and sync generation  

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// hsync and vsync output assignments
	
	assign VGA_HS = (counter_x >= 0 && counter_x < 96) ? 1:0;  // hsync high for 96 counts                                                 
	assign VGA_VS = (counter_y >= 0 && counter_y < 2) ? 1:0;   // vsync high for 2 counts
	
	// end hsync and vsync output assignments

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// pattern generate
	wire [7:0] rgb_r, rgb_g, rgb_b;
	ascii_gen at(.clk(CLOCK_50), .video_on(1), .correct_index_x(correct_index_x), .correct_index_y(correct_index_y), 
	.x(counter_x), .y(counter_y), .rgb_r(rgb_r), .rgb_g(rgb_g), .rgb_b(rgb_b));							
	// end pattern generate
	
	// correct letter counter instantiation
	correct_counter count(.clk(CLOCK_50), .reset(reset), .signal(~KEY[1]), .correct(correct));
	// end correct letter counter instantiation

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// color output assignments
	// only output the colors if the counters are within the adressable video time constraints
	assign VGA_R = (counter_x > 144 && counter_x <= 783 && counter_y > 35 && counter_y <= 514) ? rgb_r : 8'h0;
	assign VGA_G = (counter_x > 144 && counter_x <= 783 && counter_y > 35 && counter_y <= 514) ? rgb_g : 8'h0;
	assign VGA_B = (counter_x > 144 && counter_x <= 783 && counter_y > 35 && counter_y <= 514) ? rgb_b : 8'h0;
	// end color output assignments
	// VGA signal assignments
	assign VGA_CLK = clk25MHz;
	assign VGA_BLANK_N = 1;
	assign VGA_SYNC_N = 1;
	// end VGA signal assignments
	// IO assignments
	assign reset = ~KEY[0];
	// end IO assignments
	
	
endmodule
