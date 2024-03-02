clear;

f = 1000; % 频率
dt = 1/f; % 时间间隔
t = -10:dt:10; % 时域

x = cos(0.15*pi*t)+sin(2.5*pi*t)+cos(4*pi*t); % 低通信号
fx = 4*pi/(2*pi); % 最高信号频率

subplot(311)
plot(t,x);
title('低通信号的波形');
xlabel('t');
ylabel('幅度');
grid on;

subplot(312)
fs = 4; % 抽样频率
x_s = Sample(t,f,x,fs); % 对信号进行抽样
plot(t,x_s);
title('抽样序列');
xlabel('t');
ylabel('幅度');

subplot(313)
t_ = -20:dt:20; % 卷积所需时域
Sa = sinc(fs*t); % 恢复信号
x_ = conv(Sa,x_s);
plot(t_,x_);
hold on;
plot(t,x);
title('恢复的信号与原信号比较');
legend('恢复信号','原信号');
xlabel('t');
ylabel('幅度');
axis([-10,10,-4,4])