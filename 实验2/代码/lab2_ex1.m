clear;

T = 1; % �ź�����
N = 1024; % ��������
t = linspace(0,5*T,N);
dt = t(2)-t(1); % ʱ��΢��
A = 2; % ֱ������
m = cos(2*pi*t); % �����ź�
B = 1; % �����źŴ���

f_c = 10; % �ز�Ƶ��
c = cos(2*pi*f_c*t); % �ز�

% ��1��
s_AM = (A+m).*c; % AM�ѵ��ź�

subplot(311)
plot(t,s_AM);
xlabel('t');
ylabel('s_{AM}');
title('AM�ѵ��źŵ�ʱ����');
grid on;

% ��2��
[f,S_AM] = T2F(t,s_AM); % Ƶ��

subplot(312)
plot(f,abs(S_AM));
xlabel('f');
ylabel('S_{AM}');
title('AM�ѵ��źŵ�Ƶ��');
grid on;

% ��3��
n0 = 0.01; % �������߹������ܶ�
sigma = sqrt(n0*(1/dt)/2);
u = sigma*randn(1,N); % ����

s_AM_ = s_AM + u; % �����ŵ����ѵ��ź�

[f,S_AM_] = T2F(t,s_AM_); % Ƶ��

% ������ͨ�˲���
bpf = BPF(f,-(B+f_c),B+f_c,1); % ��ͨ�˲���
S_AM_BPF = bpf.*S_AM_;
[t,s_AM_BPF] = F2T(f,S_AM_BPF); % ��ʱ��

% ��ɽ��
s_AM_c = s_AM_BPF.*c; % ���ز����
[f,S_AM_c] = T2F(t,s_AM_c);
lpf = LPF(B,f,2); % ��ͨ�˲���
S_AM = lpf.*S_AM_c;
[t,s_AM] = F2T(f,S_AM);
m_ = s_AM - A; % ��ȥֱ������

subplot(313)
plot(t,m_);
xlabel('t');
ylabel('m''');
title('��ɽ������źŲ���');
grid on;


