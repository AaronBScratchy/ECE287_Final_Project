module Clock_divider(clock_in,clock_out
    );
input clock_in; // input clock on FPGA
output reg clock_out; // output clock after dividing the input clock by divisor
reg[27:0] count=28'd0;
parameter DIVISOR = 28'd2;

always @(posedge clock_in)
begin
 count <= count + 28'd1;
 if(count>=(DIVISOR-1))
  count <= 28'd0;
 clock_out <= (count<DIVISOR/2)?1'b1:1'b0;
end
endmodule
