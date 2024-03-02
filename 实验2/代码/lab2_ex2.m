clear;

B = 10; % �����źŴ���
T = 1/B; % �ź�����
N = 1024; % ��������
t = linspace(0,5*T,N);
dt = t(2)-t(1); % ʱ��΢��
P_m = 1; % m(t)����
A = sqrt(2*P_m); % ���
m = A*cos(2*pi*B*t); % ������Դ


f_c = 100; % �ز�Ƶ��
c = cos(2*pi*f_c*t); % �ز�

% ��1��
s_DSB = m.*c; % DSB�ѵ��ź�

subplot(411)
plot(t,s_DSB);
xlabel('t');
ylabel('s_{DSB}');
title('DSB�ѵ��źŵ�ʱ����');
grid on;

% ��2��
% �������ܶ�
[f,p] = PSD(t,s_DSB);

subplot(412)
plot(f,p);
xlabel('f');
ylabel('�������ܶ�');
title('�ѵ��źŵĹ������ܶ�');
axis([-150 150 0 0.15]);
grid on;

[f,S_DSB] = T2F(t,s_DSB); % Ƶ��

subplot(413)
plot(f,abs(S_DSB));
xlabel('f');
ylabel('S_{DSB}');
title('DSB�ѵ��źŵ�Ƶ��');
axis([-150 150 0 0.5]);
grid on;

% ��3��
n0 = 0.001; % �������߹������ܶ�
sigma = sqrt(n0*(1/dt)/2);
u = sigma*randn(1,N); % ����

s_DSB_ = s_DSB + u; % �����ŵ����ѵ��ź�

[f,S_DSB_] = T2F(t,s_DSB_); % Ƶ��

% ������ͨ�˲���
bpf = BPF(f,-(B+f_c),B+f_c,1); % ��ͨ�˲���
S_DSB_BPF = bpf.*S_DSB_;
[t,s_DSB_BPF] = F2T(f,S_DSB_BPF); % ��ʱ��

% ��ɽ��
s_DSB_c = s_DSB_BPF.*c; % ���ز����
[f,S_DSB_c] = T2F(t,s_DSB_c);
lpf = LPF(B,f,2); % ��ͨ�˲���
S_DSB = lpf.*S_DSB_c;
[t,m_] = F2T(f,S_DSB);

subplot(414)
plot(t,m_);
xlabel('t');
ylabel('m''');
title('��ɽ������źŲ���');
grid on;

