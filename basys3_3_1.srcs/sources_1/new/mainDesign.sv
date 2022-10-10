`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: �Ϻ��ƾ���ѧ ��Ϣ�����빤��ѧԺ
// Engineer: ������ 2022111899
// 
// Create Date: 2022/10/07 21:59:47
// Design Name: ALU
// Module Name: mainDesign

//////////////////////////////////////////////////////////////////////////////////


module mainDesign(
        input logic [1:0] S,    //���㹦�ܿ�����
        input logic [3:0] A,    //A����
        input logic [3:0] B,    //B����
        input logic M,          //�߼�or��������ѡ����
        input logic Cin,        //��λ�����ź�
        input  logic CLK100MHZ, //ʱ��Ƶ��
        output logic [1:0] SL,  //SW����LED�������ͬ
        output logic [3:0] AL,
        output logic [3:0] BL,
        output logic ML,
        output logic CinL,
        output logic [7:0] a2g, //��λ�����-����
        output logic [3:0] AN   //��λ�����-����
    );

    logic [4:0] temp;           //��ʱ���������� 
    logic nf;                   //������־
    logic zf;                   //���־
    logic cf;                   //��λ��־
    logic ovf;                  //�����־
    logic Cout;                 //��λ����ź�
    logic [3:0] F;              //����������ֵ
    logic [15:0] x;             //ģ�鷵��ֵ

    //ALUģ��-���㲿��
    always_comb begin
        cf=0;
        ovf=0;
        temp=5'b00000;
        case(M)
            1'b0: begin //M=0 �߼�����
                case(S)
                    2'b00: F= ~A; //F= not A
                    2'b01: F=A&B; //F= A and B
                    2'b10: F=A|B; //F= A or B
                    2'b11: F=A^B; //F= A xor B
                    default: F=A;
                endcase
            end
            1'b1: begin //M=1 ��������
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

    //LEDģ��-�����źſ���LED�Ƶ���
    assign AL=A;
    assign BL=B;
    assign SL=S;
    assign ML=M;
    assign CinL=Cin;

    //����ģ��-���������ظ����ģ��
    assign x[15:12]=A;  
    assign x[11:8]=B;
    assign x[3:0]=F;
    assign Cout=cf;
    assistDesign X7(.x(x),.Cin(Cin),.clk(CLK100MHZ),.a2g(a2g),.AN(AN),.Cout(Cout));
endmodule
