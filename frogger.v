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

reg [31:0]count;



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
parameter E1M1 = 5'b00000;
parameter E1M2 = 5'b00001;
parameter E1M3 = 5'b00010;
parameter E1M4 = 5'b00011;
parameter E1M5 = 5'b00100;
parameter E1M6 = 5'b00101;
parameter E1M7 = 5'b00110;
parameter E1M8 = 5'b00111;
parameter E1M9 = 5'b01000;
parameter E1M10 =5'b01001;
parameter E1M11 = 5'b01010;
parameter E1M12 = 5'b01011;
parameter E1M13 = 5'b01100;
parameter E1M14 = 5'b01101;
parameter E1M15 = 5'b01110;
parameter E1M16 = 5'b01111;
parameter E1M17 = 5'b10000;
parameter E1M18 = 5'b10001;
parameter E1M19 = 5'b10010;
parameter E1M20 = 5'b10011;


reg [4:0]E1s;
reg [4:0]E1ns;

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
reg move;
always @(*) begin
	if(E1s == E1M4)
		move = 1'b1;
	else
		move = 1'b0;
end



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

always@(*) begin
		case(E1s)
			E1M1: begin
				if(E1_clk == 1'b1)
					E1ns = E1M2;
				else
					E1ns = E1M1;
			end
			E1M2: begin
				if(E1_clk == 1'b0)
					E1ns = E1M3;
				else
					E1ns = E1M2;
			end
			E1M3: begin
				if(E1_clk == 1'b1)
					E1ns = E1M4;
				else
					E1ns = E1M3;
			end
			E1M4: begin
				if(E1_clk == 1'b0)
					E1ns = E1M5;
				else
					E1ns = E1M4;
			end
			E1M5: begin
				if(E1_clk == 1'b1)
					E1ns = E1M6;
				else
					E1ns = E1M5;
			end
			E1M6: begin
				if(E1_clk == 1'b0)
					E1ns = E1M1;
				else
					E1ns = E1M6;
			end/*
			E1M7: begin
				if(E1_clk == 1'b1) 
					E1ns = E1M8;
				else
					E1ns = E1M7;
			end
			E1M8: begin
				if(E1_clk == 1'b0)
					E1ns = E1M1;
				else
					E1ns = E1M8;
			end
			
			E1M9: begin
				if(E1_clk == 1'b1)
					E1ns = E1M10;
				else
					E1ns = E1M9;
			end
			E1M10: begin
				if(E1_clk == 1'b0)
					E1ns = E1M11;
				else
					E1ns = E1M10;
			end
			E1M11: begin
				if(E1_clk == 1'b1)
					E1ns = E1M12;
				else
					E1ns = E1M11;
			end
			E1M12: begin
				if(E1_clk == 1'b0)
					E1ns = E1M13;
				else
					E1ns = E1M12;
			end
			E1M13: begin
				if(E1_clk == 1'b1)
					E1ns = E1M14;
				else
					E1ns = E1M13;
			end
			E1M14: begin
				if(E1_clk == 1'b0)
					E1ns = E1M15;
				else
					E1ns = E1M14;
			end
			E1M15: begin
				if(E1_clk == 1'b1)
					E1ns = E1M16;
				else
					E1ns = E1M15;
			end
			E1M16: begin
				if(E1_clk == 1'b0)
					E1ns = E1M17;
				else
					E1ns = E1M16;
			end
			E1M17: begin
				if(E1_clk == 1'b1)
					E1ns = E1M18;
				else
					E1ns = E1M17;
			end
			E1M18: begin
				if(E1_clk == 1'b0)
					E1ns = E1M19;
				else
					E1ns = E1M18;
			end
			E1M19: begin
				if(E1_clk == 1'b1)
					E1ns = E1M20;
				else
					E1ns = E1M19;
			end
			E1M20: begin
				if(E1_clk == 1'b0)
					E1ns = E1M1;
				else
					E1ns = E1M20;
			end*/
			default: E1ns = E1M1;
		endcase
end


always@(posedge clock or negedge rev_reset) begin
if(rev_reset == 1'b0)begin
if(next_x < 10'd336 & next_x > 10'd304)begin
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
		case(E1s)
		E1M1: begin
			if(next_x < 10'd32 && next_x > 10'd0)
				color_in <= 8'b00011100;
			else
				color_in <= 8'b00000000;
			end
		E1M2: begin
			if(next_x < 10'd64 & next_x > 10'd32)
				color_in <= 8'b00011100;
			else
				color_in <= 8'b00000000;
			end
		E1M3: begin
			if(next_x > 10'd64 & next_x < 10'd96)
				color_in <= 8'b00011100;
			else
				color_in <= 8'b00000000;
			end
		E1M4: begin
			if(next_x < 10'd128 & next_x > 10'd96)
				color_in <= 8'b11100000;
			else
				color_in <= 8'b00000000;
			end
		E1M5: begin
			if(next_x < 10'd160 & next_x > 10'd128)
				color_in <= 8'b00011100;
			else
				color_in <= 8'b00000000;
			end
		E1M6: begin
			if(next_x < 10'd192 & next_x > 10'd160)
				color_in <= 8'b00011100;
			else
				color_in <= 8'b00000000;
			end
		E1M7: begin
			if(next_x < 10'd224 & next_x > 10'd192)
				color_in <= 8'b00011100;
			else
				color_in <= 8'b00000000;
			end
		E1M8: begin
			if(next_x < 10'd256 & next_x > 10'd224)
				color_in <= 8'b00011100;
			else
				color_in <= 8'b00000000;
			end
		E1M9: begin
			if(next_x < 10'd288 & next_x > 10'd256)
				color_in <= 8'b00011100;
			else
				color_in <= 8'b00000000;
			end
		E1M10: begin
			if(next_x < 10'd320 & next_x > 10'd288)
				color_in <= 8'b00011100;
			else
				color_in <= 8'b00000000;
			end
		E1M11: begin
			if(next_x < 10'd352 & next_x > 10'd320)
				color_in <= 8'b00011100;
			else
				color_in <= 8'b00000000;
			end
		E1M12: begin
			if(next_x < 10'd384 & next_x > 10'd352)
				color_in <= 8'b00011100;
			else
				color_in <= 8'b00000000;
			end
		E1M13: begin
			if(next_x < 10'd416 & next_x > 10'd384)
				color_in <= 8'b00011100;
			else
				color_in <= 8'b00000000;
			end
		E1M14: begin
			if(next_x < 10'd448 & next_x > 10'd416)
				color_in <= 8'b00011100;
			else
				color_in <= 8'b00000000;
			end
		E1M15: begin
			if(next_x < 10'd480 & next_x > 10'd448)
				color_in <= 8'b00011100;
			else
				color_in <= 8'b00000000;
			end
		E1M16: begin
			if(next_x < 10'd512 & next_x > 10'd480)
				color_in <= 8'b00011100;
			else
				color_in <= 8'b00000000;
			end
		E1M17: begin
			if(next_x < 10'd544 & next_x > 10'd512)
				color_in <= 8'b00011100;
			else
				color_in <= 8'b00000000;
			end
		E1M18: begin
			if(next_x < 10'd576 & next_x > 10'd544)
				color_in <= 8'b00011100;
			else
				color_in <= 8'b00000000;
			end
		E1M19: begin
			if(next_x < 10'd608 & next_x > 10'd576)
				color_in <= 8'b00011100;
			else
				color_in <= 8'b00000000;
			end
		E1M20: begin
			if(next_x < 10'd640 & next_x > 10'd608)
				color_in <= 8'b00011100;
			else
				color_in <= 8'b00000000;
			end
		default: begin
			color_in <= 8'd0;
		end
	endcase
end
end else begin
	color_in <= 8'd0;
	end
end




/*always@(posedge clock or negedge rev_reset) begin
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
end*/


always@(posedge clock or negedge rev_reset) begin
	if(rev_reset == 1'b0) begin
		   if(E1s != E1M4 & s != ns)
				s <= START;
			else
				s <= ns;
	end else begin
		s <= START;
	end
end


always@(posedge clock or negedge rev_reset) begin
	if(rev_reset == 1'b0)
		E1s <= E1ns;
	else
		E1s <= E1M1;
end

/*if((SW[17] == 1'd1) & E1s == E1M4) begin*/

endmodule
