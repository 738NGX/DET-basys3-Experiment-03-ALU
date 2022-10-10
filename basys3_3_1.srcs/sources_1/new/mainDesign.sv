`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 上海财经大学 信息管理与工程学院
// Engineer: 吉宁岳 2022111899
// 
// Create Date: 2022/10/07 21:59:47
// Design Name: ALU
// Module Name: mainDesign

//////////////////////////////////////////////////////////////////////////////////


module mainDesign(
        input logic [1:0] S,    //运算功能控制器
        input logic [3:0] A,    //A输入
        input logic [3:0] B,    //B输入
        input logic M,          //逻辑or算术运算选择器
        input logic Cin,        //进位输入信号
        input  logic CLK100MHZ, //时钟频率
        output logic [1:0] SL,  //SW开关LED输出，下同
        output logic [3:0] AL,
        output logic [3:0] BL,
        output logic ML,
        output logic CinL,
        output logic [7:0] a2g, //七位数码管-阴极
        output logic [3:0] AN   //七位数码管-阳极
    );

    logic [4:0] temp;           //临时运算结果储存 
    logic nf;                   //负数标志
    logic zf;                   //零标志
    logic cf;                   //进位标志
    logic ovf;                  //溢出标志
    logic Cout;                 //进位输出信号
    logic [3:0] F;              //运算结果返回值
    logic [15:0] x;             //模块返回值

    //ALU模块-运算部分
    always_comb begin
        cf=0;
        ovf=0;
        temp=5'b00000;
        case(M)
            1'b0: begin //M=0 逻辑运算
                case(S)
                    2'b00: F= ~A; //F= not A
                    2'b01: F=A&B; //F= A and B
                    2'b10: F=A|B; //F= A or B
                    2'b11: F=A^B; //F= A xor B
                    default: F=A;
                endcase
            end
            1'b1: begin //M=1 算术运算
                case(Cin)
                    1'b0: begin //Cin=0 
                        case(S)
                            2'b00: begin //F=A+B+0 
                                temp={1'b0,A}+{1'b0,B}+{1'b0,1'b0};
                                F=temp[3:0];
                                cf=temp[4];
                                ovf=F[3]^A[3]^B[3]^cf;
                            end
                            2'b01: begin //F=A-B-0
                                temp={1'b0,A}-{1'b0,B}-{1'b0,1'b0};
                                F=temp[3:0];
                                cf=temp[4];
                                ovf=F[3]^A[3]^B[3]^cf;
                            end
                        endcase
                    end
                    1'b1: begin //Cin=1
                        case(S)
                            2'b00: begin //F=A+B+1
                                temp={1'b0,A}+{1'b0,B}+{1'b0,1'b1};
                                F=temp[3:0];
                                cf=temp[4];
                                ovf=F[3]^A[3]^B[3]^cf;
                            end
                            2'b01: begin //F=A-B-1
                                temp={1'b0,A}-{1'b0,B}-{1'b0,1'b1};
                                F=temp[3:0];
                                cf=temp[4];
                                ovf=F[3]^A[3]^B[3]^cf;
                            end
                        endcase
                    end
                endcase
            end
        endcase
        nf=F[3];
        if(F==4'b0000) zf=1;
        else           zf=0;
    end

    //LED模块-开关信号控制LED灯点亮
    assign AL=A;
    assign BL=B;
    assign SL=S;
    assign ML=M;
    assign CinL=Cin;

    //返回模块-运算结果返回给输出模块
    assign x[15:12]=A;  
    assign x[11:8]=B;
    assign x[3:0]=F;
    assign Cout=cf;
    assistDesign X7(.x(x),.Cin(Cin),.clk(CLK100MHZ),.a2g(a2g),.AN(AN),.Cout(Cout));
endmodule
