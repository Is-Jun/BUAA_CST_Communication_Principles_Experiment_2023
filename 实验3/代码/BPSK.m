function out = BPSK(t,s,A,fc,L,d,B,SNRdb)
% bpsk调制解调
%------------------------输入参数 
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
%%  BPSK调制
c = A*cos(2*pi*fc*t);  % 载波
s_BPSK = c.*(s*2-1);
%% 经过噪声
SNR = 10^(SNRdb/10);  % 信噪比
B_bpf = 2*fc+2*B;  % 理想带通滤波器带宽
P = (norm(s_BPSK(1:L)).^2)./length(s_BPSK(1:L));  % 求解平均功率
n0 = P/SNR/B_bpf;
u = sqrt(n0*L*fc/2)*randn(1,length(s));  % 噪声
s_BPSK_u = s_BPSK+u;  % 信号与加性噪声
%% 滤波器接收
[f,S_BPSK_u] = T2F(t,s_BPSK_u);   % 转换到频域
S_BPSK_u_BPF = BPF(f,-(fc+B),fc+B,1).*S_BPSK_u;  % 经过带通滤波器后
[t,s_BPSK_u_BPF] = F2T(f,S_BPSK_u_BPF);  % 变换为时域
s_BPSK_u_BPF_c = s_BPSK_u_BPF.*c ;  % 乘上载波
[f,S_BPSK_u_BPF_c] = T2F(t,s_BPSK_u_BPF_c) ;  % 变换到频域
S_BPSK_u_BPF_c_LPF = LPF(B,f,1).*(S_BPSK_u_BPF_c);  % 经过低通滤波器
%% 解调信号——LPF对输出信号进行抽样判决
[~,s] = F2T(f,S_BPSK_u_BPF_c_LPF);  % 变换到时域
out = BPSK_SJ(s,L,d);
end