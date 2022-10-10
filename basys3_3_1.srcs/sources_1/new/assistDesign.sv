`timescale 1ns / 1ps

module assistDesign(
            input logic [15:0] x,
            input logic Cin,
            input logic Cout,
            input logic clk,
            input logic clr,
            output logic [7:0] a2g,
            output logic [3:0] AN           //�����ʹ��
        );
    
    logic [1:0] s;                          //ѡ���ĸ������
    logic [7:0] digit;
    logic [19:0] clkdiv;
    
    assign s = clkdiv[19:18];               // count every 10.4ms        
    
    //4������� 4ѡ1 (MUX44)
    always_comb
        case(s)
            0: begin
                if(Cout==0) digit=x[3:0];   //�����F
                else digit=x[3:0]+'h10;     //��λ��־
            end
            1: digit='hff;                  //��ʾ�Ⱥ�
            2: begin
                if(Cin==0) digit=x[11:8];   //�����B
                else digit=x[11:8]+'h10;    //��λ��־
            end
            3: digit=x[15:12];              //�����A
            default: digit=x[3:0];
        endcase
    
    //4���������������
    always_comb
        case(s)
            0: AN=4'b1110;
            1: AN=4'b1101;
            2: AN=4'b1011;
            3: AN=4'b0111;
            default: AN=4'b1110;
        endcase
        
    //ʱ�ӷ�Ƶ����20λ�����Ƽ�������
    always @(posedge clk, posedge clr)
      if(clr == 1) clkdiv <= 0;
      else         clkdiv <= clkdiv + 1;
    
    //ʵ���� 7�������
    Dec7Seg s7(.x(digit),.a2g(a2g));    
endmodule

