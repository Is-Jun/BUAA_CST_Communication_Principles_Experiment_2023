function out = QAM(N,t,b,A,fc,L,B,SNRdb)
% bpsk调制解调
%------------------------输入参数 
% N：产生码元数
% t：时间
% b：原始信号
% A：载波幅度
% fc：载波频率
% L：每个码元的采样点数
% B：信号带宽
% SNRdb：信噪比
%% 基带信号与载波
I = zeros(1,N/4); 
Q = zeros(1,N/4); 
for i = 4:4:N  % 串并转换 和 2-4电平转换
    if b(i-3)==0 && b(i-1)==0
        I(round(i/4)) = -3;
    elseif b(i-3)==0 && b(i-1)==1
        I(round(i/4)) = -1;
    elseif b(i-3)==1 && b(i-1)==0
        I(round(i/4)) = 1;
    else
        I(round(i/4)) = 3;
    end
    
    if b(i-2)==0 && b(i)==0
        Q(round(i/4)) = -3;
    elseif b(i-2)==0 && b(i)==1
        Q(round(i/4)) = -1;
    elseif b(i-2)==1 && b(i)==0
        Q(round(i/4)) = 1;
    else
        Q(round(i/4)) = 3;
    end
end

I = signal_expand(I,L);
Q = signal_expand(Q,L);
%% QAM调制
c1 = A*cos(2*pi*fc*t);  % 载波1
c2 = -A*sin(2*pi*fc*t);  % 载波2
s_QAM = I.*c1+Q.*c2;
%% 噪声
SNR = 10^(SNRdb/10);
B_bpf = 2*(B+fc); % 理想带通滤波器带宽
P = (norm(s_QAM(1:L)).^2)./length(s_QAM(1:L)); % 平均功率
n0 = (P/SNR)/B_bpf; % 噪声功率谱密度
u = sqrt(n0*L*fc/2)*randn(1,L*N/4); % 噪声
s_QAM_u = s_QAM+u; % 经过信道的已调信号
%% 滤波器接收
[f,S_QAM_u] = T2F(t,s_QAM_u); % 频域
S_QAM_u_BPF = BPF(f,-(fc+B),fc+B,1).*S_QAM_u; % 经过带通滤波器
[~,s_QAM_u_BPF] = F2T(f,S_QAM_u_BPF); % 时域
s1_QAM_u_BPF_c = s_QAM_u_BPF.*c1; % 与载波相乘
s2_QAM_u_BPF_c = s_QAM_u_BPF.*c2;
[~,S1_QAM_u_BPF_c] = T2F(t,s1_QAM_u_BPF_c); % 频域
[~,S2_QAM_u_BPF_c] = T2F(t,s2_QAM_u_BPF_c);
S1_QAM_u_BPF_c_LPF = LPF(B,f,2).*(S1_QAM_u_BPF_c); % 经过低通滤波器
S2_QAM_u_BPF_c_LPF = LPF(B,f,2).*(S2_QAM_u_BPF_c);
[~,s1_QAM_u_BPF_c_LPF] = F2T(f,S1_QAM_u_BPF_c_LPF); % 时域
[~,s2_QAM_u_BPF_c_LPF] = F2T(f,S2_QAM_u_BPF_c_LPF);
%% 解调
s1_QAM = QAM_SJ(s1_QAM_u_BPF_c_LPF,L); % 抽样判决
s2_QAM = QAM_SJ(s2_QAM_u_BPF_c_LPF,L);
out = zeros(1,N);  % 初始化
for i = 1:1:round(N/4)  % 串并转换
    if s1_QAM(i) == -3
        out(4*i-3) = 0;
        out(4*i-1) = 0;
    elseif s1_QAM(i) == -1
        out(4*i-3) = 0;
        out(4*i-1) = 1;
    elseif s1_QAM(i) == 1
        out(4*i-3) = 1;
        out(4*i-1) = 0;
    else
        out(4*i-3) = 1;
        out(4*i-1) = 1;
    end
    
    if s2_QAM(i) == -3
        out(4*i-2) = 0;
        out(4*i) = 0;
    elseif s2_QAM(i) == -1
        out(4*i-2) = 0;
        out(4*i) = 1;
    elseif s2_QAM(i) == 1
        out(4*i-2) = 1;
        out(4*i) = 0;
    else
        out(4*i-2) = 1;
        out(4*i) = 1;
    end
end
end
