clear;
% 求解ex4中基带带宽
N = 1024; % 采样数
t = linspace(0,0.6,N); % 时域范围
m = 0.1*cos(15*pi*t)+1.5*sin(25*pi*t)+0.5*cos(40*pi*t); % 调制信号m(t)

[f,M] = T2F(t,m); % 频域

plot(f,abs(M));
xlabel('\omega');
ylabel('M(\omega)');
title('调制信号频谱');
axis([-40 40 0 0.6]);