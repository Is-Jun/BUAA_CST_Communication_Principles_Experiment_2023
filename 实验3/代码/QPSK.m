function out = QPSK(N,t,s,A,fc,L,d,B,SNRdb)
% bpsk调制解调
%------------------------输入参数 
% N：产生码元数
% t：时间
% s：原始信号
% A：载波幅度
% fc：载波频率
% L：每个码元的采样点数
% d：判决门限
% B：信号带宽
% SNRdb：信噪比
%---------------------输出(返回)参数
% out：输出信号
%% 产生调制信号
s1_ = zeros(1,N/2); % _0和_1
s2_ = zeros(1,N/2); % 0_和1_
for i = 2:2:N % 串并转换
    if s(i-1)==0
        s1_(round(i/2)) = -1;
    else
        s1_(round(i/2)) = 1;
    end
    
    if s(i)==0
        s2_(round(i/2)) = -1;
    else
        s2_(round(i/2)) = 1;
    end
end
s1 = signal_expand(s1_,L);
s2 = signal_expand(s2_,L);
%% QPSK调制
c1 = A*cos(2*pi*fc*t);  % 载波
c2 = -A*sin(2*pi*fc*t);
s_QPSK = c1.*s1+c2.*s2;
%% 经过噪声
SNR = 10^(SNRdb/10);  % 信噪比
B_bpf = 2*fc+2*B;  % 理想带通滤波器带宽
P = (norm(s_QPSK(1:L)).^2)./length(s_QPSK(1:L));  % 求解平均功率
n0 = P/SNR/B_bpf;
u = sqrt(n0*L*fc/2)*randn(1,L*N/2);  % 噪声
s_QPSK_u = s_QPSK+u;  % 信号与加性噪声
%% 滤波器接收
[f,S_QPSK_u] = T2F(t,s_QPSK_u); % 频域
S_QPSK_u_BPF = BPF(f,-(fc+B),fc+B,1).*S_QPSK_u; % 经过带通滤波器
[~,s_QPSK_u_BPF] = F2T(f,S_QPSK_u_BPF); % 时域
s1_QPSK_u_BPF_c = s_QPSK_u_BPF.*c1; % 与载波相乘
s2_QPSK_u_BPF_c = s_QPSK_u_BPF.*c2;
[~,S1_QPSK_u_BPF_c] = T2F(t,s1_QPSK_u_BPF_c); % 频域
[~,S2_QPSK_u_BPF_c] = T2F(t,s2_QPSK_u_BPF_c);
S1_QPSK_u_BPF_c_LPF = LPF(B,f,2).*(S1_QPSK_u_BPF_c); % 经过低通滤波器
S2_QPSK_u_BPF_c_LPF = LPF(B,f,2).*(S2_QPSK_u_BPF_c);
[~,s1_QPSK_u_BPF_c_LPF] = F2T(f,S1_QPSK_u_BPF_c_LPF); % 时域
[~,s2_QPSK_u_BPF_c_LPF] = F2T(f,S2_QPSK_u_BPF_c_LPF);
%% 解调信号——LPF对输出信号进行抽样判决
s1_QPSK = QPSK_SJ(s1_QPSK_u_BPF_c_LPF,L,d); % 抽样判决
s2_QPSK = QPSK_SJ(s2_QPSK_u_BPF_c_LPF,L,d);
out = zeros(1,N); % 初始化
for i = 1:1:round(N/2) % 串并转换
    out(2*i-1:2*i) = [s1_QPSK(i),s2_QPSK(i)];
end
end