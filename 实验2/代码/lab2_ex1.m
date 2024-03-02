clear;

T = 1; % 信号周期
N = 1024; % 采样点数
t = linspace(0,5*T,N);
dt = t(2)-t(1); % 时域微分
A = 2; % 直流分量
m = cos(2*pi*t); % 调制信号
B = 1; % 调制信号带宽

f_c = 10; % 载波频率
c = cos(2*pi*f_c*t); % 载波

% （1）
s_AM = (A+m).*c; % AM已调信号

subplot(311)
plot(t,s_AM);
xlabel('t');
ylabel('s_{AM}');
title('AM已调信号的时域波形');
grid on;

% （2）
[f,S_AM] = T2F(t,s_AM); % 频谱

subplot(312)
plot(f,abs(S_AM));
xlabel('f');
ylabel('S_{AM}');
title('AM已调信号的频谱');
grid on;

% （3）
n0 = 0.01; % 噪声单边功率谱密度
sigma = sqrt(n0*(1/dt)/2);
u = sigma*randn(1,N); % 噪声

s_AM_ = s_AM + u; % 经过信道的已调信号

[f,S_AM_] = T2F(t,s_AM_); % 频谱

% 经过带通滤波器
bpf = BPF(f,-(B+f_c),B+f_c,1); % 带通滤波器
S_AM_BPF = bpf.*S_AM_;
[t,s_AM_BPF] = F2T(f,S_AM_BPF); % 求时域

% 相干解调
s_AM_c = s_AM_BPF.*c; % 与载波相乘
[f,S_AM_c] = T2F(t,s_AM_c);
lpf = LPF(B,f,2); % 低通滤波器
S_AM = lpf.*S_AM_c;
[t,s_AM] = F2T(f,S_AM);
m_ = s_AM - A; % 减去直流分量

subplot(313)
plot(t,m_);
xlabel('t');
ylabel('m''');
title('相干解调后的信号波形');
grid on;


