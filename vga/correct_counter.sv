module correct_counter (
	input clk,
	input reset,
	input signal,  // correct letter typed
	output correct // signal to increment correct letter index
);

	// correct letter edge deterction
	logic correct_prev; // correct letter typed value
	logic correct_ff;	  // current correct letter typed value
	
	always @(posedge clk) begin
		if (reset) begin
			correct_prev <= 0;
			correct_ff <= 0;
		end else begin
			correct_prev <= correct_ff;
			correct_ff <= signal;
		end
	end
	
	assign correct = correct_ff && ~correct_prev;  // send correct signal for 1 cycle 
	                                               // at correct letter typed edge
	
endmodule