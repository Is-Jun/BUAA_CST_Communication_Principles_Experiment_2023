clear;

B = 10; % 调制信号带宽
T = 1/B; % 信号周期
N = 1024; % 采样点数
t = linspace(0,5*T,N);
dt = t(2)-t(1); % 时域微分
P_m = 1; % m(t)功率
A = sqrt(2*P_m); % 振幅
m = A*cos(2*pi*B*t); % 余弦信源


f_c = 100; % 载波频率
c = cos(2*pi*f_c*t); % 载波

% （1）
s_DSB = m.*c; % DSB已调信号

subplot(411)
plot(t,s_DSB);
xlabel('t');
ylabel('s_{DSB}');
title('DSB已调信号的时域波形');
grid on;

% （2）
% 求功率谱密度
[f,p] = PSD(t,s_DSB);

subplot(412)
plot(f,p);
xlabel('f');
ylabel('功率谱密度');
title('已调信号的功率谱密度');
axis([-150 150 0 0.15]);
grid on;

[f,S_DSB] = T2F(t,s_DSB); % 频谱

subplot(413)
plot(f,abs(S_DSB));
xlabel('f');
ylabel('S_{DSB}');
title('DSB已调信号的频谱');
axis([-150 150 0 0.5]);
grid on;

% （3）
n0 = 0.001; % 噪声单边功率谱密度
sigma = sqrt(n0*(1/dt)/2);
u = sigma*randn(1,N); % 噪声

s_DSB_ = s_DSB + u; % 经过信道的已调信号

[f,S_DSB_] = T2F(t,s_DSB_); % 频谱

% 经过带通滤波器
bpf = BPF(f,-(B+f_c),B+f_c,1); % 带通滤波器
S_DSB_BPF = bpf.*S_DSB_;
[t,s_DSB_BPF] = F2T(f,S_DSB_BPF); % 求时域

% 相干解调
s_DSB_c = s_DSB_BPF.*c; % 与载波相乘
[f,S_DSB_c] = T2F(t,s_DSB_c);
lpf = LPF(B,f,2); % 低通滤波器
S_DSB = lpf.*S_DSB_c;
[t,m_] = F2T(f,S_DSB);

subplot(414)
plot(t,m_);
xlabel('t');
ylabel('m''');
title('相干解调后的信号波形');
grid on;

