module Clock_divider_E1(clock_in,clock_out
    );
input clock_in;
output reg clock_out;
reg[27:0] count=28'd0;
parameter DIVISOR = 28'd50000000;

always @(posedge clock_in)
begin
 count <= count + 28'd1;
 if(count>=(DIVISOR-1))
  count <= 28'd0;
 clock_out <= (count<DIVISOR/2)?1'b1:1'b0;
end
endmodule
