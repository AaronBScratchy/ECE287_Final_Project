module frogger (
input clock, reset,
	 input [17:0]SW,
    output [7:0] red,     // RED (to resistor DAC VGA connector)
    output [7:0] green,   // GREEN (to resistor DAC to VGA connector)
    output [7:0] blue,    // BLUE (to resistor DAC to VGA connector)
	 output sync,          // SYNC to VGA connector
    output clk,           // CLK to VGA connector
    output blank,          // BLANK to VGA connector
	 output hsync,    // HSYNC (to VGA connector)
    output vsync   // VSYNC (to VGA connctor)
);
reg [7:0]color_in;
wire [9:0]next_x;
wire [9:0]next_y;
reg [9:0]frog_location;

wire rev_reset = ~reset;

wire clk_25;
wire clk_5;
Clock_divider clk_25_MHz(clock, clk_25);



vga_driver driver(clk_25, rev_reset, color_in, next_x, next_y, hsync, vsync, red, green, blue, sync, clk, blank);

// SM parameters

parameter START = 4'b0000;
parameter MOVE1 = 4'b0001;
parameter MOVE2 = 4'b0010;
parameter MOVE3 = 4'b0011;
parameter MOVE4 = 4'b0100;
parameter MOVE5 = 4'b0101;
parameter MOVE6 = 4'b0110;
parameter MOVE7 = 4'b0111;
parameter MOVE8 = 4'b1000;
parameter DONE = 4'b1001;


reg [3:0]s;
reg [3:0]ns;

parameter E1M1 = 5'd1;
parameter E1M2 = 5'd2;
parameter E1M3 = 5'd3;
parameter E1M4 = 5'd4;
parameter E1M5 = 5'd5;
parameter E1M6 = 5'd6;
parameter E1M7 = 5'd7;
parameter E1M8 = 5'd8;
parameter E1M9 = 5'd9;
parameter E1M10 = 5'd10;
parameter E1M11 = 5'd11;
parameter E1M12 = 5'd12;
parameter E1M13 = 5'd13;
parameter E1M14 = 5'd14;
parameter E1M15 = 5'd15;
parameter E1M16 = 5'd16;
parameter E1M17 = 5'd17;
parameter E1M18 = 5'd18;
parameter E1M19 = 5'd19;
parameter E1M20 = 5'd20;

reg [5:0]E1s;
reg [5:0]E1ns;

wire E1_clk;
Clock_divider_E1 clk_E1(clock,E1_clk);

reg [9:0]E1_x;


/*
module vga_driver (
    input wire clock,     // 25 MHz
    input wire reset,     // Active high
    input [7:0] color_in, // Pixel color data (RRRGGGBB)
    output [9:0] next_x,  // x-coordinate of NEXT pixel that will be drawn
    output [9:0] next_y,  // y-coordinate of NEXT pixel that will be drawn
    output wire hsync,    // HSYNC (to VGA connector)
    output wire vsync,    // VSYNC (to VGA connctor)
    output [7:0] red,     // RED (to resistor DAC VGA connector)
    output [7:0] green,   // GREEN (to resistor DAC to VGA connector)
    output [7:0] blue,    // BLUE (to resistor DAC to VGA connector)
    output sync,          // SYNC to VGA connector
    output clk,           // CLK to VGA connector
    output blank          // BLANK to VGA connector
);
*/



/*always @(posedge clk_25 or negedge rev_reset) begin
	if(rev_reset == 1'b0) begin
		if(SW[0] == 1'b1) begin
			if(next_y < 10'd96)
				color_in <= 8'b00011100;
			else
				color_in <= 8'b00000000;
		end else
			color_in <= 8'b00000000;
	end else
		color_in <= 8'b00000000;
			
end*/
//Player FSM
always@(*) begin
case(s)
	START: begin
				if(SW[17] == 1'd1)
					ns = MOVE1;
				else
					ns = START;
			 end
	MOVE1: begin
				if(SW[16] == 1'd1)
					ns = MOVE2;
				else
					ns = MOVE1;
			 end
	MOVE2: begin
				if(SW[15] == 1'd1)
					ns = MOVE3;
				else
					ns = MOVE2;
			 end
	MOVE3: begin
				if(SW[14] == 1'd1)
					ns = MOVE4;
				else
					ns = MOVE3;
			 end
	MOVE4: begin
				if(SW[13] == 1'd1)
					ns = MOVE5;
				else
					ns = MOVE4;
			 end
	MOVE5: begin
				if(SW[12] == 1'd1)
					ns = MOVE6;
				else
					ns = MOVE5;
			 end
	MOVE6: begin
				if(SW[11] == 1'd1)
					ns = MOVE7;
				else
					ns = MOVE6;
			 end
	MOVE7: begin
				if(SW[10] == 1'd1)
					ns = MOVE8;
				else
					ns = MOVE7;
			 end
	MOVE8: begin
				if(SW[9] == 1'd1)
					ns = DONE;
				else
					ns = MOVE8;
			 end
	DONE: ns = DONE;
	default: ns = START;
endcase
end

/*always@(*) begin
		case(E1s)
			E1M1: E1ns <= E1M2;
			E1M2: E1ns <= E1M3;
			E1M3: E1ns <= E1M4;
			E1M4: E1ns <= E1M5;
			E1M5: E1ns <= E1M6;
			E1M6: E1ns <= E1M7;
			E1M7: E1ns <= E1M8;
			E1M8: E1ns <= E1M9;
			E1M9: E1ns <= E1M10;
			E1M10: E1ns <= E1M11;
			E1M11: E1ns <= E1M12;
			E1M12: E1ns <= E1M13;
			E1M13: E1ns <= E1M14;
			E1M14: E1ns <= E1M15;
			E1M15: E1ns <= E1M16;
			E1M16: E1ns <= E1M17;
			E1M17: E1ns <= E1M18;
			E1M18: E1ns <= E1M19;
			E1M19: E1ns <= E1M20;
			E1M20: E1ns <= E1M1;
			default: E1ns <= E1M1;
		endcase
end*/

/*always@(posedge clock or negedge rev_reset) begin
if(rev_reset == 1'b0)begin
	case(s)
		E1M1: begin
			E1_x <= 10'd32;
		end
		E1M2: begin
			E1_x <= 10'd64;
		end
		E1M3: begin
			E1_x <= 10'd96;
		end
		E1M4: begin
			E1_x = 10'd128;
		end
		E1M5: begin
			E1_x <= 10'd160;
		end
		E1M6: begin
			E1_x <= 10'd192;
		end
		E1M7: begin
			E1_x <= 10'd224;
		end
		E1M8: begin
			E1_x <= 10'd256;
		end
		E1M9: begin
			E1_x <= 10'd288;
		end
		E1M10:begin
			E1_x <= 10'd320;
		end
		E1M11:begin
			E1_x <= 10'd352;
		end
		E1M12:begin
			E1_x <= 10'd384;
		end
		E1M13:begin
			E1_x <= 10'd416;
		end
		E1M14:begin
			E1_x <= 10'd448;
		end
		E1M15:begin
			E1_x <= 10'd480;
		end
		E1M16:begin
			E1_x <= 10'd512;
		end
		E1M17:begin
			E1_x <= 10'd544;
		end
		E1M18:begin
			E1_x <= 10'd576;
		end
		E1M19:begin
			E1_x <= 10'd608;
		end
		E1M20:begin
			E1_x <= 10'd640;
		end
		default: E1_x <= 10'd0;
	endcase
end else
	E1_x <= 10'd0;
end*/


always@(posedge clock or negedge rev_reset) begin
	if(rev_reset == 1'b0) begin
		case(s)
			START:begin
						if((next_y < 10'd48 & next_x < 10'd336 & next_x > 10'd304))
							color_in <= 8'b00011100;
						else
							color_in <= 8'b00000000;
					end
			MOVE1:begin
						if((next_y < 10'd96) & (next_y > 10'd48) & next_x < 10'd336 & next_x > 10'd304)
							color_in <= 8'b00011100;
						else
							color_in <= 8'b00000000;
					end
			MOVE2:begin
						if((next_y < 10'd144) & (next_y > 10'd96) & next_x < 10'd336 & next_x > 10'd304)
							color_in <= 8'b00011100;
						else
							color_in <= 8'b00000000;
					end
			MOVE3:begin
						if((next_y < 10'd192) & (next_y > 10'd144) & next_x < 10'd336 & next_x > 10'd304)
							color_in <= 8'b00011100;
						else
							color_in <= 8'b00000000;
					end
			MOVE4:begin
						if((next_y < 10'd240) & (next_y > 10'd192) & next_x < 10'd336 & next_x > 10'd304)
							color_in <= 8'b00011100;
						else
							color_in <= 8'b00000000;
					end
			MOVE5:begin
						if((next_y < 10'd288) & (next_y > 10'd240) & next_x < 10'd336 & next_x > 10'd304)
							color_in <= 8'b00011100;
						else
							color_in <= 8'b00000000;
					end
			MOVE6:begin
						if((next_y < 10'd336) & (next_y > 10'd288) & next_x < 10'd336 & next_x > 10'd304)
							color_in <= 8'b00011100;
						else
							color_in <= 8'b00000000;
					end
			MOVE7:begin
						if((next_y < 10'd384) & (next_y > 10'd336) & next_x < 10'd336 & next_x > 10'd304)
							color_in <= 8'b00011100;
						else
							color_in <= 8'b00000000;
					end
			MOVE8:begin
						if((next_y < 10'd432) & (next_y > 10'd384) & next_x < 10'd336 & next_x > 10'd304)
							color_in <= 8'b00011100;
						else
							color_in <= 8'b00000000;
					end
			DONE:begin
						if((next_y < 10'd480) & (next_y > 10'd432) & next_x < 10'd336 & next_x > 10'd304)
							color_in <= 8'b00011100;
						else
							color_in <= 8'b00000000;
					end
			default: color_in <= 8'b00000000;
		endcase
	end else begin
		color_in <= 8'b00000000;
	end
end


always@(posedge clock or negedge rev_reset) begin
	if(rev_reset == 1'b0) begin
		s <= ns;
	end else begin
		s <= START;
	end
end

/*always@(posedge clock or negedge rev_reset)
	if(rev_reset == 1'b0) begin
		E1s <= E1ns;
	end else begin
		E1s <= E1M1;
	end*/

endmodule
