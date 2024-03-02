clear;
x = 0:0.01:2*pi; % 时域信号的范围
y1 = 2*exp(-0.5*x); % 函数1
y2 = cos(4*pi*x); % 函数2

plot(x,y1); % 绘图
hold on; % 图形保持
plot(x,y2);

xlabel('x');
ylabel('y');
title('y1和y2的函数图像');
legend('y1=2e^{-0.5x}','y2=cos(4\pix)');
