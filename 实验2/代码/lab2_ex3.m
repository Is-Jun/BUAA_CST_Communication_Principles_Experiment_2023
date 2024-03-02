clear;

B = 20; % 调制信号带宽
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
[f,S_DSB] = T2F(t,s_DSB);
% 用带通滤波器过滤上边带
bpf_LSB = BPF(f,-f_c,f_c,1);
S_SSB = bpf_LSB.*S_DSB; % 保留了下边带
[t,s_SSB] = F2T(f,S_SSB);

subplot(411)
plot(t,s_SSB);
xlabel('t');
ylabel('s_{SSB}');
title('SSB已调信号（下边带）的时域波形');
grid on;

% （2）
S_LSB = S_SSB;
S_USB = S_DSB-S_LSB;

subplot(412)
plot(f,abs(S_LSB));
xlabel('f');
ylabel('S_{LSB}');
title('已调信号的下边带调制频谱');
axis([-150 150 0 0.5]);
grid on;


subplot(413)
plot(f,abs(S_USB));
xlabel('f');
ylabel('S_{USB}');
title('已调信号的上边带调制频谱');
axis([-150 150 0 0.5]);
grid on;

% （3）
n0 = 0.001; % 噪声单边功率谱密度
sigma = sqrt(n0*(1/dt)/2);
u = sigma*randn(1,N); % 噪声

s_SSB_ = s_SSB + u; % 经过信道的已调信号

[f,S_SSB_] = T2F(t,s_SSB_); % 频谱

% 经过带通滤波器
bpf = BPF(f,-f_c,f_c,1); % 带通滤波器
S_SSB_BPF = bpf.*S_SSB_;
[t,s_SSB_BPF] = F2T(f,S_SSB_BPF); % 求时域

% 相干解调
s_SSB_c = s_SSB_BPF.*c; % 与载波相乘
[f,S_SSB_c] = T2F(t,s_SSB_c);
lpf = LPF(B,f,4); % 低通滤波器
S_SSB = lpf.*S_SSB_c;
[t,m_] = F2T(f,S_SSB);

subplot(414)
plot(t,m_);
xlabel('t');
ylabel('m''');
title('相干解调后的信号波形');
grid on;

