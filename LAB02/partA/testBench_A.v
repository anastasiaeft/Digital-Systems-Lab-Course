module merosA_tb;

reg reset, clk;  //inputs
reg [2:0] baud_select;
wire sample_ENABLE; //outputs

baud_controller dut_control(.reset(reset), .clk(clk), .baud_select(baud_select), .sample_ENABLE(sample_ENABLE));

always begin

    #10 clk <= ~clk;
end

initial begin
    
    clk = 0;
    reset = 0;

    #10
    reset = 1;

    #20
    reset = 0;

    for (integer i=0; i<8; i=i+1) begin
        baud_select = i;
        #1000
        $display ("baud_sel = %b || sample_En = %b", baud_select, sample_ENABLE);
    end

    #1000000000 $finish;
end
endmodule;