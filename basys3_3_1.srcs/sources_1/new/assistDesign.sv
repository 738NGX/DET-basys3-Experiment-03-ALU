`timescale 1ns / 1ps

module assistDesign(
            input logic [15:0] x,
            input logic Cin,
            input logic Cout,
            input logic clk,
            input logic clr,
            output logic [7:0] a2g,
            output logic [3:0] AN           //数码管使能
        );
    
    logic [1:0] s;                          //选择哪个数码管
    logic [7:0] digit;
    logic [19:0] clkdiv;
    
    assign s = clkdiv[19:18];               // count every 10.4ms        
    
    //4个数码管 4选1 (MUX44)
    always_comb
        case(s)
            0: begin
                if(Cout==0) digit=x[3:0];   //分配给F
                else digit=x[3:0]+'h10;     //进位标志
            end
            1: digit='hff;                  //显示等号
            2: begin
                if(Cin==0) digit=x[11:8];   //分配给B
                else digit=x[11:8]+'h10;    //进位标志
            end
            3: digit=x[15:12];              //分配给A
            default: digit=x[3:0];
        endcase
    
    //4个数码管轮流点亮
    always_comb
        case(s)
            0: AN=4'b1110;
            1: AN=4'b1101;
            2: AN=4'b1011;
            3: AN=4'b0111;
            default: AN=4'b1110;
        endcase
        
    //时钟分频器（20位二进制计数器）
    always @(posedge clk, posedge clr)
      if(clr == 1) clkdiv <= 0;
      else         clkdiv <= clkdiv + 1;
    
    //实例化 7段数码管
    Dec7Seg s7(.x(digit),.a2g(a2g));    
endmodule

