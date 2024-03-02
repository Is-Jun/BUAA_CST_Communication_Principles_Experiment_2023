clear;

N = 256; % 产生码元数
Ts = 1; % 码元持续时间
A = 1; % 载波幅值
fc = 20; % 载波频率
d = 0; % 判决门限
L = 1000; % 每个码元的采样点数
dt = Ts/L; % 采样间隔
T = N*Ts; % 总时间
t = 0:dt:T-dt; % 时间
t_ = 0:dt:N/2-dt;

% 生成调制信号
b = randi([0,1],1,N); % 二进制随机码
s = signal_expand(b,L); % 调制信号
s1_ = zeros(1,N/2); % _0和_1
s2_ = zeros(1,N/2); % 0_和1_
for i = 2:2:N % 串并转换
    if b(i-1)==0
        s1_(round(i/2)) = -1;
    else
        s1_(round(i/2)) = 1;
    end
    
    if b(i)==0
        s2_(round(i/2)) = -1;
    else
        s2_(round(i/2)) = 1;
    end
end
s1 = signal_expand(s1_,L); 
s2 = signal_expand(s2_,L);

subplot(511)
plot(t,s);
title('调制信号');
xlabel('t');
ylabel('幅度');
axis([0,10,0,1.2]);
grid on;

% QPSK
c1 = A*cos(2*pi*fc*t_); % 载波1
c2 = -A*sin(2*pi*fc*t_); % 载波2
s_QPSK = s1.*c1+s2.*c2;

subplot(512)
plot(t_,s_QPSK);
title('QPSK已调信号');
xlabel('t');
ylabel('幅度');
axis([0,10,-1.5,1.5]);

% 噪声
SNRdb = 0; % 信噪比
SNR = 10^(SNRdb/10);
B = 2; % 基带带宽
B_bpf = 2*(B+fc); % 理想带通滤波器带宽
P = (norm(s_QPSK(1:L)).^2)./length(s_QPSK(1:L)); % 平均功率
n0 = (P/SNR)/B_bpf; % 噪声功率谱密度
u = sqrt(n0*L*fc/2)*randn(1,L*N/2); % 噪声
s_QPSK_u = s_QPSK+u; % 经过信道的已调信号

% 滤波器
[f,S_QPSK_u] = T2F(t_,s_QPSK_u); % 频域
S_QPSK_u_BPF = BPF(f,-(fc+B),fc+B,1).*S_QPSK_u; % 经过带通滤波器
[~,s_QPSK_u_BPF] = F2T(f,S_QPSK_u_BPF); % 时域
s1_QPSK_u_BPF_c = s_QPSK_u_BPF.*c1; % 与载波相乘
s2_QPSK_u_BPF_c = s_QPSK_u_BPF.*c2;
[~,S1_QPSK_u_BPF_c] = T2F(t_,s1_QPSK_u_BPF_c); % 频域
[~,S2_QPSK_u_BPF_c] = T2F(t_,s2_QPSK_u_BPF_c);
S1_QPSK_u_BPF_c_LPF = LPF(B,f,2).*(S1_QPSK_u_BPF_c); % 经过低通滤波器
S2_QPSK_u_BPF_c_LPF = LPF(B,f,2).*(S2_QPSK_u_BPF_c);
[~,s1_QPSK_u_BPF_c_LPF] = F2T(f,S1_QPSK_u_BPF_c_LPF); % 时域
[~,s2_QPSK_u_BPF_c_LPF] = F2T(f,S2_QPSK_u_BPF_c_LPF);

subplot(513)
plot(t_,s1_QPSK_u_BPF_c_LPF);
hold on;
plot(t_,s2_QPSK_u_BPF_c_LPF);
title('低通滤波器输出信号');
xlabel('t');
ylabel('幅度');
legend('同向分量','正交分量');
axis([0,10,-4,4]);
grid on;

% 解调
s1_QPSK = QPSK_SJ(s1_QPSK_u_BPF_c_LPF,L,d); % 抽样判决
s2_QPSK = QPSK_SJ(s2_QPSK_u_BPF_c_LPF,L,d);
s_ = zeros(1,N); % 初始化
for i = 1:1:round(N/2) % 串并转换
    s_(2*i-1:2*i) = [s1_QPSK(i),s2_QPSK(i)];
end
s = signal_expand(s_,L);

subplot(514)
plot(t,s);
title('解调信号');
xlabel('t');
ylabel('幅度');
axis([0,10,0,1.2]);

% 信噪比
SNR1 = -15; % 最小信噪比
SNR2 = 5; % 最大信噪比
T = 30; % 次数
n = SNR1:SNR2; % 信噪比横轴
Pe_theory = 0.5*erfc(sqrt(10.^(n/10)/2)); % 理论误码率
Pe_practice = zeros(1,length(n)); % 实际误码率
for SNR = SNR1:SNR2
    for i = 1:T
        b = randi([0,1],1,N); % 二进制随机码
        out = QPSK(N,t_,b,A,fc,L,d,B,SNR);  % 进行调制解调
        out = out - b;  % 信号差
        Pe_practice(-SNR1+SNR+1) = Pe_practice(-SNR1+SNR+1) + (sum(abs(out),'double')/N);  % 误码累计
    end
    Pe_practice(-SNR1+SNR+1)=Pe_practice(-SNR1+SNR+1)/T; % 平均误码率
end

subplot(515)
semilogy(n,Pe_theory);
hold on;
semilogy(n,Pe_practice);
legend('理论误码率','实际误码率');
title('误码率曲线');
xlabel('信噪比');
ylabel('误码率');
axis([-15 5 0.001 1]);
