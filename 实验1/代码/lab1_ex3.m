clear;
t = linspace(0,0.6,1024); % 时域范围
x = 0.4*sin(100*pi*t)+0.4*sin(640*pi*t); % 信号x(t)
u = randn(1, 1024); % 均值为0，方差为1的高斯噪声信号u(n)
y = x+u; % 二者叠加

[f, Y] = T2F(t,y);

subplot(211)
plot(t,y);
xlabel('t');
ylabel('x(t)+u(n)');
title('x(t)与u(n)叠加图像');
grid on;

subplot(212)
plot(f, abs(Y));
xlabel('频率(Hz)');
title('频谱');
grid on;


