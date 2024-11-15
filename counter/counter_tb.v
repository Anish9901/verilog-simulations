module test;
    reg reset = 0;
    initial begin
        $dumpfile("counter.vcd");
        $dumpvars(0, test);
        #17 reset = 1;
        #11 reset = 0;
        #29 reset = 1;
        #11 reset = 0;
        #100 $stop;
    end

    reg clk = 0;
    always #5 clk = !clk;

    wire [7:0] value;
    counter c1 (value, clk, reset);
    initial
        $monitor("At time %t, value = %h (%0d)",
                $time, value, value);
endmodule