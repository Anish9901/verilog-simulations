module uart_tx (tx_data_IN, tx_data_OUT, baud_tick, reset);
    input baud_tick;
    input reset;
    input [7:0] tx_data_IN;
    output reg tx_data_OUT;
    
    reg start_bit = 0;
    reg [7:0] tx_data_IN_shift;
    always @(posedge reset) begin
        if(reset) begin
            tx_data_IN_shift <= tx_data_IN;
            $display("%d, %d", tx_data_IN_shift, tx_data_IN);
        end
    end

    reg start = 0;
    always @(posedge baud_tick) begin
        // $display("%d", tx_data_IN_shift);
        if (start == 0) begin
            start <= 1;
            tx_data_OUT <= start_bit;
        end
        else begin
            tx_data_OUT <= tx_data_IN_shift[0];
            tx_data_IN_shift <= tx_data_IN_shift >> 1;
            // $display("%0d, %0d", tx_data_OUT, tx_data_IN_shift);
        end
    end
endmodule


module uart_rx (rx_data_IN, rx_data_OUT, baud_tick);
    input baud_tick;
    input rx_data_IN;
    output reg rx_data_OUT = 1;

    reg start = 0;
    always @(negedge rx_data_IN) begin
        if (start == 0) begin
            start <= 1;
            rx_data_OUT <= 0;
        end
        else begin
            rx_data_OUT <= 1; // output remains high when no data is received
        end
    end

    reg [3:0] ctr = 0;
    always @(posedge baud_tick) begin
        if (start && ctr != 8) begin
            #1; // start sampling for data after 1us after the baud_tick is detected. 
            rx_data_OUT <= rx_data_IN;
            ctr <= ctr + 1;
        end
        if (ctr == 8) begin
            rx_data_OUT <= 1; // output remains high when no data is received
        end
    end  
endmodule