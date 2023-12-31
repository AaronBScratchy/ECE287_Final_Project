module debounce (
input clk,
input rst,
input SW, 
output reg SW_db
);

reg [7:0]count;
parameter CALMING_WINDOW = 8'd100;

reg [2:0]S;
reg [2:0]NS;
parameter
	START = 3'd0,
	ONE = 3'd1,
	MAYBE_ONE = 3'd2,
	ZERO = 3'd3,
	MAYBE_ZERO = 3'd4,
	ERROR = 3'hF;

always @(posedge clk or negedge rst)
begin
	if (rst == 1'b0)
		S <= START;
	else
		S <= NS;
end

always @(*)
begin
	case (S)
		START: NS = ZERO; // typically switches are off
		ONE: 
			if (SW == 1'b0)
				NS = MAYBE_ZERO;
			else
				NS = ONE;
		MAYBE_ONE:
			if (SW == 1'b1 && count > 8'd100)
				NS = ONE;
			else if (SW == 1'b1)
				NS = MAYBE_ONE;
			else
				NS = ZERO;
		ZERO:
			if (SW == 1'b1)
				NS = MAYBE_ONE;
			else
				NS = ZERO;
		MAYBE_ZERO:
			if (SW == 1'b0 && count > 8'd100)
				NS = ONE;
			else if (SW == 1'b0)
				NS = MAYBE_ZERO;
			else
				NS = ONE;
		default: NS = ERROR;
	endcase
end

	
always @(posedge clk or negedge rst)
begin
	if (rst == 1'b0)
		count <= 8'd0;
	else
		case (S)
			START:
			begin
				count <= 8'd0;
			end
			ONE: 
			begin
				count <= 8'd0;
				SW_db <= 1'b1;
			end
			MAYBE_ONE:
			begin
				count <= count + 1'b1;
				SW_db <= 1'b0;
			end
			ZERO:
			begin
				count <= 8'd0;				
				SW_db <= 1'b0;
			end
			MAYBE_ZERO:
			begin
				count <= count + 1'b1;
				SW_db <= 1'b1;
			end
		endcase
end

endmodule
