clear;

N = 256; % 产生码元数
Ts = 1; % 码元持续时间
A = 1; % 载波幅值
fc = 20; % 载波频率
d = 0; % 判决门限
L = 200; % 每个码元的采样点数
dt = Ts/L; % 采样间隔
T = N*Ts; % 总时间
t = 0:dt:T-dt; % 时间

% 生成调制信号
b = randi([0,1],1,N); % 二进制随机码
s = signal_expand(b,L); % 调制信号

subplot(511)
plot(t,s);
title('调制信号');
xlabel('t');
ylabel('幅度');
axis([0,10,0,1.2]);
grid on;

% BPSK
c = A*cos(2*pi*fc*t); % 载波
s_BPSK = c.*(2*s-1);

subplot(512)
plot(t,s_BPSK);
title('BPSK已调信号');
xlabel('t');
ylabel('幅度');
axis([0,10,-1.2,1.2]);

% 噪声
SNRdb = 0; % 信噪比
SNR = 10^(SNRdb/10);
B = 1; % 基带带宽
B_bpf = 2*(B+fc); % 理想带通滤波器带宽
P = (norm(s_BPSK(1:L)).^2)./length(s_BPSK(1:L)); % 平均功率
n0 = (P/SNR)/B_bpf; % 噪声功率谱密度
u = sqrt(n0*L*fc/2)*randn(1,L*N); % 噪声
s_BPSK_u = s_BPSK+u; % 经过信道的已调信号

% 滤波器
[f,S_BPSK_u] = T2F(t,s_BPSK_u); % 频域
S_BPSK_u_BPF = BPF(f,-(fc+B),fc+B,1).*S_BPSK_u; % 经过带通滤波器
[t,s_BPSK_u_BPF] = F2T(f,S_BPSK_u_BPF); % 时域
s_BPSK_u_BPF_c = s_BPSK_u_BPF.*c; % 与载波相乘
[f,S_BPSK_u_BPF_c] = T2F(t,s_BPSK_u_BPF_c); % 频域
S_BPSK_u_BPF_c_LPF = LPF(B,f,1).*(S_BPSK_u_BPF_c); % 经过低通滤波器
[t,s_BPSK_u_BPF_c_LPF] = F2T(f,S_BPSK_u_BPF_c_LPF); % 时域

subplot(513)
plot(t,s_BPSK_u_BPF_c_LPF);
title('低通滤波器输出信号');
xlabel('t');
ylabel('幅度');
axis([0,10,-1.5,1.5]);
grid on;

% 解调
s_BPSK = BPSK_SJ(s_BPSK_u_BPF_c_LPF,L,d); % 抽样判决

subplot(514)
plot(t,s_BPSK);
title('解调信号');
xlabel('t');
ylabel('幅度');
axis([0,10,0,1.2]);

% 信噪比
SNR1 = -15; % 最小信噪比
SNR2 = 5; % 最大信噪比
T = 30; % 次数
n = SNR1:SNR2; % 信噪比横轴
Pe_theory = 0.5*erfc(sqrt(10.^(n/10))); % 理论误码率
Pe_practice = zeros(1,length(n)); % 实际误码率
for SNR = SNR1:SNR2
    for i = 1:T
        b = randi([0,1],1,N); % 二进制随机码
        s = signal_expand(b,L); % 调制信号
        out = BPSK(t,s,A,fc,L,d,B,SNR);  % 进行调制解调
        out = out - s;  % 信号差
        Pe_practice(-SNR1+SNR+1) = Pe_practice(-SNR1+SNR+1) + (sum(abs(out),'double')/L/N);  % 误码累计
    end
    Pe_practice(-SNR1+SNR+1)=Pe_practice(-SNR1+SNR+1)/T; % 平均误码率
end

subplot(515)
plot(n,Pe_theory);
hold on;
plot(n,Pe_practice);
legend('理论误码率','实际误码率');
title('误码率曲线');
xlabel('信噪比');
ylabel('误码率');