//xrhsh 2 flip-flops se seira 
//to 1o pianei to asygxrono shma 
//kai to deytero to statheropoiei

module ResetSync(clk, reset, synchr_reset);
    input clk, reset;
    output synchr_reset;

    reg [1:0] ff; //2 flip-flops 
                  //ff[0]=ejodos 1ou flip-flop ff[1]=ejodos 2ou flip-flop

    always @(posedge clk or posedge reset) begin
      if (reset == 1) begin //energo
        ff <= 2'b11;        //energa flip-flops
      end
      else begin            //apenergopoihmeno reset
        ff <= {ff[0], 1'b0}; //dhladh prwta ff=10 kai meta ff=00 
      end                    //wste to reset na mh ginei amesws mhden alla meta apo enan kyklo
    end                      

    assign synchr_reset = ff[1]; //to neo reset pairnei thn ejodo tou 2ou flip-flop (pio statherou)

endmodule