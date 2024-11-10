`timescale 1us/1us
`include "uart.v"

module uart_tb;
    reg reset = 0;
    initial begin
        $dumpfile("uart.vcd");
        $dumpvars(0, uart_tb);
        #10 reset = 1;
        #10 reset = 0;
        #5000000 $stop;
    end

    reg baud_tick = 0;
    always #52 baud_tick = !baud_tick;

    reg [7:0] tx_data_IN = 8'b10011011; // data to transmit goes here
    wire tx_data_OUT;
    wire rx_data_OUT;
    uart_tx tx (tx_data_IN, tx_data_OUT, baud_tick, reset);
    uart_rx rx (tx_data_OUT, rx_data_OUT, baud_tick);
endmodule