clear;

N = 256; % ������Ԫ��
Ts = 1; % ��Ԫ����ʱ��
A = 1; % �ز���ֵ
fc = 20; % �ز�Ƶ��
d = 0; % �о�����
L = 200; % ÿ����Ԫ�Ĳ�������
dt = Ts/L; % �������
T = N*Ts; % ��ʱ��
t = 0:dt:T-dt; % ʱ��

% ���ɵ����ź�
b = randi([0,1],1,N); % �����������
s = signal_expand(b,L); % �����ź�

subplot(511)
plot(t,s);
title('�����ź�');
xlabel('t');
ylabel('����');
axis([0,10,0,1.2]);
grid on;

% BPSK
c = A*cos(2*pi*fc*t); % �ز�
s_BPSK = c.*(2*s-1);

subplot(512)
plot(t,s_BPSK);
title('BPSK�ѵ��ź�');
xlabel('t');
ylabel('����');
axis([0,10,-1.2,1.2]);

% ����
SNRdb = 0; % �����
SNR = 10^(SNRdb/10);
B = 1; % ��������
B_bpf = 2*(B+fc); % �����ͨ�˲�������
P = (norm(s_BPSK(1:L)).^2)./length(s_BPSK(1:L)); % ƽ������
n0 = (P/SNR)/B_bpf; % �����������ܶ�
u = sqrt(n0*L*fc/2)*randn(1,L*N); % ����
s_BPSK_u = s_BPSK+u; % �����ŵ����ѵ��ź�

% �˲���
[f,S_BPSK_u] = T2F(t,s_BPSK_u); % Ƶ��
S_BPSK_u_BPF = BPF(f,-(fc+B),fc+B,1).*S_BPSK_u; % ������ͨ�˲���
[t,s_BPSK_u_BPF] = F2T(f,S_BPSK_u_BPF); % ʱ��
s_BPSK_u_BPF_c = s_BPSK_u_BPF.*c; % ���ز����
[f,S_BPSK_u_BPF_c] = T2F(t,s_BPSK_u_BPF_c); % Ƶ��
S_BPSK_u_BPF_c_LPF = LPF(B,f,1).*(S_BPSK_u_BPF_c); % ������ͨ�˲���
[t,s_BPSK_u_BPF_c_LPF] = F2T(f,S_BPSK_u_BPF_c_LPF); % ʱ��

subplot(513)
plot(t,s_BPSK_u_BPF_c_LPF);
title('��ͨ�˲�������ź�');
xlabel('t');
ylabel('����');
axis([0,10,-1.5,1.5]);
grid on;

% ���
s_BPSK = BPSK_SJ(s_BPSK_u_BPF_c_LPF,L,d); % �����о�

subplot(514)
plot(t,s_BPSK);
title('����ź�');
xlabel('t');
ylabel('����');
axis([0,10,0,1.2]);

% �����
SNR1 = -15; % ��С�����
SNR2 = 5; % ��������
T = 30; % ����
n = SNR1:SNR2; % ����Ⱥ���
Pe_theory = 0.5*erfc(sqrt(10.^(n/10))); % ����������
Pe_practice = zeros(1,length(n)); % ʵ��������
for SNR = SNR1:SNR2
    for i = 1:T
        b = randi([0,1],1,N); % �����������
        s = signal_expand(b,L); % �����ź�
        out = BPSK(t,s,A,fc,L,d,B,SNR);  % ���е��ƽ��
        out = out - s;  % �źŲ�
        Pe_practice(-SNR1+SNR+1) = Pe_practice(-SNR1+SNR+1) + (sum(abs(out),'double')/L/N);  % �����ۼ�
    end
    Pe_practice(-SNR1+SNR+1)=Pe_practice(-SNR1+SNR+1)/T; % ƽ��������
end

subplot(515)
plot(n,Pe_theory);
hold on;
plot(n,Pe_practice);
legend('����������','ʵ��������');
title('����������');
xlabel('�����');
ylabel('������');