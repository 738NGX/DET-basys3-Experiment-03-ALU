# 上海财经大学 信息管理与工程学院 数字电子技术课 实验03
## 实验目的
熟悉用算术、逻辑的Verilog编程，练习多模块自顶向下编程方法。  
## 实验内容
### 1) 设计一个4位算术逻辑单元
输入信号为：  
两组4位数据输入信号（A3—A0，B3—B0），一个进位输入信号Cin；  
数据输出信号为：4 位数据信号（F3—F0）, 一个进位输出信号Cout。  
以上数据均为无符号正整数。功能控制信号有：S1、S0、M。  
当 M=0 时为逻辑运算，M=1 时为算术运算。  
### 2) 在BASYS3开发板上实现上述设计，SW 选择可以自己确定。
例如，SW[15]对应：M，  
SW[14:13]对应：S1 和 S0，  
SW[12]、SW[3:0]、SW[7:4]分别对应：Cin、A[3:0]、B[3:0]，  
左侧第 2 个七段数码管的小数点表示 Cin，最右侧的小数点表示 Cout。  
当 SW 为 1 时，其上面的 LED 点亮，否则熄灭。  
开发板上的 4 个七段数码管用于显示十六进制的输入数据和输出数据。  
