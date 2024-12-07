module prompt_rom (
	input [1:0] selection,
	input [11:0] letter_index,
	output [6:0] letter_out
);

	 (* romstyle = "M4K" *)	// Infer BRAM
	
	 reg [6:0] main_prompt [0:191];
	 reg [6:0] title [0:25];
	 reg [6:0] initial_prompt [0:21];
	 reg [6:0] final_prompt [0:21];
	 
	 initial begin
	 
	 main_prompt = '{7'h41, 7'h50, 7'h50, 7'h4C, 7'h45, 7'h20, 7'h42, 7'h41, 7'h4E, 7'h41, 7'h4E, 7'h41, 7'h20, 
	 7'h43, 7'h48, 7'h45, 7'h52, 7'h52, 7'h59, 7'h20, 7'h44, 7'h41, 7'h54, 7'h45, 7'h53, 7'h20, 7'h4D, 7'h45, 
	 7'h4C, 7'h4F, 7'h4E, 7'h20, 7'h47, 7'h52, 7'h41, 7'h50, 7'h45, 7'h20, 7'h48, 7'h4F, 7'h4E, 7'h45, 7'h59, 
	 7'h44, 7'h45, 7'h57, 7'h20, 7'h4B, 7'h49, 7'h57, 7'h49, 7'h20, 7'h4C, 7'h45, 7'h4D, 7'h4F, 7'h4E, 7'h20, 
	 7'h4D, 7'h41, 7'h4E, 7'h47, 7'h4F, 7'h20, 7'h4E, 7'h45, 7'h43, 7'h54, 7'h41, 7'h52, 7'h49, 7'h4E, 7'h45, 
	 7'h20, 7'h4F, 7'h52, 7'h41, 7'h4E, 7'h47, 7'h45, 7'h20, 7'h50, 7'h41, 7'h50, 7'h41, 7'h59, 7'h41, 7'h20, 
	 7'h4C, 7'h49, 7'h4D, 7'h45, 7'h20, 7'h52, 7'h41, 7'h53, 7'h50, 7'h42, 7'h45, 7'h52, 7'h52, 7'h59, 7'h20, 
	 7'h42, 7'h4C, 7'h55, 7'h45, 7'h42, 7'h45, 7'h52, 7'h52, 7'h59, 7'h20, 7'h54, 7'h41, 7'h4E, 7'h47, 7'h45, 
	 7'h52, 7'h49, 7'h4E, 7'h45, 7'h20, 7'h50, 7'h45, 7'h41, 7'h52, 7'h20, 7'h41, 7'h56, 7'h4F, 7'h43, 7'h41, 
	 7'h44, 7'h4F, 7'h20, 7'h57, 7'h41, 7'h54, 7'h45, 7'h52, 7'h4D, 7'h45, 7'h4C, 7'h4F, 7'h4E, 7'h20, 7'h53, 
	 7'h54, 7'h52, 7'h41, 7'h57, 7'h42, 7'h45, 7'h52, 7'h52, 7'h59, 7'h20, 7'h59, 7'h55, 7'h5A, 7'h55, 7'h20, 
	 7'h50, 7'h45, 7'h41, 7'h43, 7'h48, 7'h20, 7'h41, 7'h50, 7'h52, 7'h49, 7'h43, 7'h4F, 7'h54, 7'h20, 7'h5A, 
	 7'h55, 7'h43, 7'h43, 7'h48, 7'h49, 7'h4E, 7'h49, 7'h20, 7'h54, 7'h4F, 7'h4D, 7'h41, 7'h54, 7'h4F};
	 
	 title = '{7'h49, 7'h4E, 7'h54, 7'h45, 7'h52, 7'h41, 7'h43, 7'h54, 7'h49, 7'h56, 7'h45, 7'h20, 7'h54, 
	 7'h59, 7'h50, 7'h49, 7'h4E, 7'h47, 7'h20, 7'h54, 7'h52, 7'h41, 7'h49, 7'h4E, 7'h45, 7'h52};
	 
	 initial_prompt = '{7'h50, 7'h52, 7'h45, 7'h53, 7'h53, 7'h20, 7'h41, 7'h4E, 7'h59, 7'h20, 7'h4B, 7'h45, 
	 7'h59, 7'h20, 7'h54, 7'h4F, 7'h20, 7'h53, 7'h54, 7'h41, 7'h52, 7'h54};
	 
	 final_prompt = '{7'h20, 7'h20, 7'h20, 7'h20, 7'h20, 7'h57, 7'h45, 7'h4C, 7'h4C, 7'h20, 7'h44, 
	 7'h4F, 7'h4E, 7'h45, 7'h21, 7'h20, 7'h01, 7'h20, 7'h20, 7'h20, 7'h20, 7'h20};
	 
	 end
	 
	 always @* begin
		case (selection)
		
		0: letter_out = title[letter_index];
		1: letter_out = main_prompt[letter_index];
		2: letter_out = initial_prompt[letter_index];
		3: letter_out = final_prompt[letter_index];
		
		endcase
	 end

endmodule