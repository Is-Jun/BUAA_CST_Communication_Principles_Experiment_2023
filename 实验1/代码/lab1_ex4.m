clear;

N = 1024; % 采样数
t = linspace(0,0.6,N); % 时域范围
m = 0.1*cos(15*pi*t)+1.5*sin(25*pi*t)+0.5*cos(40*pi*t); % 调制信号m(t)
c = cos(250*pi*t); % 载波c(t)
A = 3; % 直流分量
SNR_dB = 10; % 接收端输入信噪比
SNR = 10^(SNR_dB/10);


% 进入信道前
s_AM = (A+m).*c; % AM方式调制
[f,S_AM] = T2F(t,s_AM); % 频域

Pst = sum(abs(s_AM).^2)/length(s_AM); % 信号的发送功率
Pni = SNR/Pst; % 求出噪声功率
u = sqrt(Pni)*randn(1,N); % 噪声信号

subplot(321)
plot(t,s_AM);
xlabel('t');
ylabel('s_{AM}');
title('经过AWGN信道前的已调信号时域波形图');
grid on;

subplot(322);
plot(f,abs(S_AM));
xlabel('\omega');
ylabel('S_{AM}');
title('经过AWGN信道前的已调信号频谱');
grid on;

% 经过信道后

% 不考虑解调器
s_AM_ = s_AM+u; % 经过AWGN后的信号
[f, S_AM_] = T2F(t, s_AM_);

subplot(323)
plot(t, s_AM_);
xlabel('t');
ylabel('s_{AM}''');
title('经过AWGN信道后的已调信号时域波形图（不考虑解调器）');
grid on;

subplot(324)
plot(f,abs(S_AM_));
xlabel('\omega');
ylabel('S_{AM}''');
title('经过AWGN信道后的已调信号频谱（不考虑解调器）');
grid on;

% 考虑解调器
% 根据公式求解n0
B = 40;
n0 = (sum(abs(s_AM).^2)/length(s_AM))/(SNR*B);
% 根据公式求解白噪声标准差
fs = 1/(t(2)-t(1));
sigma = sqrt(n0*fs/2);
u = sigma*randn(1,N); % 噪声
s_AM_ = s_AM+u; % 接受的信号
[f,S_AM_] = T2F(t,s_AM_);

subplot(325)
plot(t, s_AM_);
xlabel('t');
ylabel('s_{AM}''');
title('经过AWGN信道后的已调信号时域波形图（考虑解调器）');
grid on;

subplot(326)
plot(f,abs(S_AM_));
xlabel('\omega');
ylabel('S_{AM}''');
title('经过AWGN信道后的已调信号频谱（考虑解调器）');
grid on;

