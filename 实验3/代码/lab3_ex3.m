clear;

N = 256; % 产生码元数
Ts = 1; % 码元持续时间
A = 1; % 载波幅值
fc = 20; % 载波频率
L = 1000; % 每个码元的采样点数
dt = Ts/L; % 采样间隔
T = N*Ts; % 总时间
t = 0:dt:T-dt; % 时间
t_ = 0:dt:T/4-dt;

% 生成调制信号
b = randi([0,1],1,N); % 二进制随机码
s = signal_expand(b,L); 

subplot(321)
plot(t,s);
title('调制信号');
xlabel('t');
ylabel('幅度');
axis([0,6,0,1.2]);
grid on;

% QAM
% 产生I、Q路码元
I = zeros(1,N/4); 
Q = zeros(1,N/4); 
for i = 4:4:N % 串并转换和2-4电平转换
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
c1 = A*cos(2*pi*fc*t_); % 载波1
c2 = -A*sin(2*pi*fc*t_); % 载波2
s_QAM = I.*c1+Q.*c2;

subplot(323)
plot(t_,s_QAM);
title('QAM已调信号');
xlabel('t');
ylabel('幅度');
axis([0,6,-5,5]);

% 噪声
SNRdb = 0; % 信噪比
SNR = 10^(SNRdb/10);
B = 4; % 基带带宽
B_bpf = 2*(B+fc); % 理想带通滤波器带宽
P = (norm(s_QAM(1:L)).^2)./length(s_QAM(1:L)); % 平均功率
n0 = (P/SNR)/B_bpf; % 噪声功率谱密度
u = sqrt(n0*L*fc/2)*randn(1,L*N/4); % 噪声
s_QAM_u = s_QAM+u; % 经过信道的已调信号

% 滤波器
[f,S_QAM_u] = T2F(t_,s_QAM_u); % 频域
S_QAM_u_BPF = BPF(f,-(fc+B),fc+B,1).*S_QAM_u; % 经过带通滤波器
[~,s_QAM_u_BPF] = F2T(f,S_QAM_u_BPF); % 时域
s1_QAM_u_BPF_c = s_QAM_u_BPF.*c1; % 与载波相乘
s2_QAM_u_BPF_c = s_QAM_u_BPF.*c2;
[~,S1_QAM_u_BPF_c] = T2F(t_,s1_QAM_u_BPF_c); % 频域
[~,S2_QAM_u_BPF_c] = T2F(t_,s2_QAM_u_BPF_c);
S1_QAM_u_BPF_c_LPF = LPF(B,f,2).*(S1_QAM_u_BPF_c); % 经过低通滤波器
S2_QAM_u_BPF_c_LPF = LPF(B,f,2).*(S2_QAM_u_BPF_c);
[~,s1_QAM_u_BPF_c_LPF] = F2T(f,S1_QAM_u_BPF_c_LPF); % 时域
[~,s2_QAM_u_BPF_c_LPF] = F2T(f,S2_QAM_u_BPF_c_LPF);

subplot(324)
plot(t_,s1_QAM_u_BPF_c_LPF);
hold on;
plot(t_,s2_QAM_u_BPF_c_LPF);
title('低通滤波器输出信号');
xlabel('t');
ylabel('幅度');
legend('同向分量','正交分量');
axis([0,6,-10,10]);
grid on;

% 解调
s1_QAM = QAM_SJ(s1_QAM_u_BPF_c_LPF,L); % 抽样判决
s2_QAM = QAM_SJ(s2_QAM_u_BPF_c_LPF,L);
s1_QAM_ = sample(s1_QAM_u_BPF_c_LPF,L);
s2_QAM_ = sample(s2_QAM_u_BPF_c_LPF,L);

% 16QAM星座点
constellation = [-(3+3i), -(3+1i), -(3-3i), -(3-1i), ...
                 -(1+3i), -(1+1i), -(1-3i), -(1-1i), ...
                 (3+3i), (3+1i), (3-3i), (3-1i), ...
                 (1+3i), (1+1i), (1-3i), (1-1i)];
% 绘制星座图
subplot(322)
scatter(real(constellation), imag(constellation), 'filled');
hold on;
scatter(s1_QAM_, s2_QAM_);
grid on;
axis([-7,7,-3.5,3.5]);
title('16QAM 星座图');
xlabel('I');
ylabel('R');
ax = gca;  % 获取当前坐标轴对象
ax.XAxisLocation = 'origin';  % 设置X轴显示在中心
ax.YAxisLocation = 'origin';  % 设置Y轴显示在中心

b = zeros(1,N); % 初始化
for i = 1:1:round(N/4)  % 串并转换
    if s1_QAM(i) == -3
        b(4*i-3) = 0;
        b(4*i-1) = 0;
    elseif s1_QAM(i) == -1
        b(4*i-3) = 0;
        b(4*i-1) = 1;
    elseif s1_QAM(i) == 1
        b(4*i-3) = 1;
        b(4*i-1) = 0;
    else
        b(4*i-3) = 1;
        b(4*i-1) = 1;
    end
    
    if s2_QAM(i) == -3
        b(4*i-2) = 0;
        b(4*i) = 0;
    elseif s2_QAM(i) == -1
        b(4*i-2) = 0;
        b(4*i) = 1;
    elseif s2_QAM(i) == 1
        b(4*i-2) = 1;
        b(4*i) = 0;
    else
        b(4*i-2) = 1;
        b(4*i) = 1;
    end
end
s = signal_expand(b,L); 

subplot(325)
plot(t,s);
title('解调信号');
xlabel('t');
ylabel('幅度');
axis([0,6,0,1.2]);

% 信噪比
SNR1 = -15; % 最小信噪比
SNR2 = 5; % 最大信噪比
T = 30; % 次数
n = SNR1:SNR2; % 信噪比横轴
Pe_theory = 1-(1-(3*(0.5*erfc(sqrt(10.^(n/10))/sqrt(40)))-9/4*(0.5*erfc(sqrt(10.^(n/10))/sqrt(40))).^2)).^(1/4); % 理论误码率
Pe_practice = zeros(1,length(n)); % 实际误码率
for SNR = SNR1:SNR2
    for i = 1:T
        b = randi([0,1],1,N); % 二进制随机码
        out = QAM(N,t_,b,A,fc,L,B,SNR);  % 进行调制解调
        out = out - b;  % 信号差
        Pe_practice(-SNR1+SNR+1) = Pe_practice(-SNR1+SNR+1) + (sum(abs(out),'double')/N);  % 误码累计
    end
    Pe_practice(-SNR1+SNR+1)=Pe_practice(-SNR1+SNR+1)/T; % 平均误码率
end

subplot(326)
semilogy(n,Pe_theory);
hold on;
semilogy(n,Pe_practice);
legend('理论误码率','实际误码率');
title('误码率曲线');
xlabel('信噪比');
ylabel('误码率');
axis([-15 5 0.1 1]);
