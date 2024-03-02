clear;

N = 256; % ������Ԫ��
Ts = 1; % ��Ԫ����ʱ��
A = 1; % �ز���ֵ
fc = 20; % �ز�Ƶ��
d = 0; % �о�����
L = 1000; % ÿ����Ԫ�Ĳ�������
dt = Ts/L; % �������
T = N*Ts; % ��ʱ��
t = 0:dt:T-dt; % ʱ��
t_ = 0:dt:N/2-dt;

% ���ɵ����ź�
b = randi([0,1],1,N); % �����������
s = signal_expand(b,L); % �����ź�
s1_ = zeros(1,N/2); % _0��_1
s2_ = zeros(1,N/2); % 0_��1_
for i = 2:2:N % ����ת��
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
title('�����ź�');
xlabel('t');
ylabel('����');
axis([0,10,0,1.2]);
grid on;

% QPSK
c1 = A*cos(2*pi*fc*t_); % �ز�1
c2 = -A*sin(2*pi*fc*t_); % �ز�2
s_QPSK = s1.*c1+s2.*c2;

subplot(512)
plot(t_,s_QPSK);
title('QPSK�ѵ��ź�');
xlabel('t');
ylabel('����');
axis([0,10,-1.5,1.5]);

% ����
SNRdb = 0; % �����
SNR = 10^(SNRdb/10);
B = 2; % ��������
B_bpf = 2*(B+fc); % �����ͨ�˲�������
P = (norm(s_QPSK(1:L)).^2)./length(s_QPSK(1:L)); % ƽ������
n0 = (P/SNR)/B_bpf; % �����������ܶ�
u = sqrt(n0*L*fc/2)*randn(1,L*N/2); % ����
s_QPSK_u = s_QPSK+u; % �����ŵ����ѵ��ź�

% �˲���
[f,S_QPSK_u] = T2F(t_,s_QPSK_u); % Ƶ��
S_QPSK_u_BPF = BPF(f,-(fc+B),fc+B,1).*S_QPSK_u; % ������ͨ�˲���
[~,s_QPSK_u_BPF] = F2T(f,S_QPSK_u_BPF); % ʱ��
s1_QPSK_u_BPF_c = s_QPSK_u_BPF.*c1; % ���ز����
s2_QPSK_u_BPF_c = s_QPSK_u_BPF.*c2;
[~,S1_QPSK_u_BPF_c] = T2F(t_,s1_QPSK_u_BPF_c); % Ƶ��
[~,S2_QPSK_u_BPF_c] = T2F(t_,s2_QPSK_u_BPF_c);
S1_QPSK_u_BPF_c_LPF = LPF(B,f,2).*(S1_QPSK_u_BPF_c); % ������ͨ�˲���
S2_QPSK_u_BPF_c_LPF = LPF(B,f,2).*(S2_QPSK_u_BPF_c);
[~,s1_QPSK_u_BPF_c_LPF] = F2T(f,S1_QPSK_u_BPF_c_LPF); % ʱ��
[~,s2_QPSK_u_BPF_c_LPF] = F2T(f,S2_QPSK_u_BPF_c_LPF);

subplot(513)
plot(t_,s1_QPSK_u_BPF_c_LPF);
hold on;
plot(t_,s2_QPSK_u_BPF_c_LPF);
title('��ͨ�˲�������ź�');
xlabel('t');
ylabel('����');
legend('ͬ�����','��������');
axis([0,10,-4,4]);
grid on;

% ���
s1_QPSK = QPSK_SJ(s1_QPSK_u_BPF_c_LPF,L,d); % �����о�
s2_QPSK = QPSK_SJ(s2_QPSK_u_BPF_c_LPF,L,d);
s_ = zeros(1,N); % ��ʼ��
for i = 1:1:round(N/2) % ����ת��
    s_(2*i-1:2*i) = [s1_QPSK(i),s2_QPSK(i)];
end
s = signal_expand(s_,L);

subplot(514)
plot(t,s);
title('����ź�');
xlabel('t');
ylabel('����');
axis([0,10,0,1.2]);

% �����
SNR1 = -15; % ��С�����
SNR2 = 5; % ��������
T = 30; % ����
n = SNR1:SNR2; % ����Ⱥ���
Pe_theory = 0.5*erfc(sqrt(10.^(n/10)/2)); % ����������
Pe_practice = zeros(1,length(n)); % ʵ��������
for SNR = SNR1:SNR2
    for i = 1:T
        b = randi([0,1],1,N); % �����������
        out = QPSK(N,t_,b,A,fc,L,d,B,SNR);  % ���е��ƽ��
        out = out - b;  % �źŲ�
        Pe_practice(-SNR1+SNR+1) = Pe_practice(-SNR1+SNR+1) + (sum(abs(out),'double')/N);  % �����ۼ�
    end
    Pe_practice(-SNR1+SNR+1)=Pe_practice(-SNR1+SNR+1)/T; % ƽ��������
end

subplot(515)
semilogy(n,Pe_theory);
hold on;
semilogy(n,Pe_practice);
legend('����������','ʵ��������');
title('����������');
xlabel('�����');
ylabel('������');
axis([-15 5 0.001 1]);
