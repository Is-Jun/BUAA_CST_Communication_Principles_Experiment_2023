clear;

B = 20; % �����źŴ���
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
[f,S_DSB] = T2F(t,s_DSB);
% �ô�ͨ�˲��������ϱߴ�
bpf_LSB = BPF(f,-f_c,f_c,1);
S_SSB = bpf_LSB.*S_DSB; % �������±ߴ�
[t,s_SSB] = F2T(f,S_SSB);

subplot(411)
plot(t,s_SSB);
xlabel('t');
ylabel('s_{SSB}');
title('SSB�ѵ��źţ��±ߴ�����ʱ����');
grid on;

% ��2��
S_LSB = S_SSB;
S_USB = S_DSB-S_LSB;

subplot(412)
plot(f,abs(S_LSB));
xlabel('f');
ylabel('S_{LSB}');
title('�ѵ��źŵ��±ߴ�����Ƶ��');
axis([-150 150 0 0.5]);
grid on;


subplot(413)
plot(f,abs(S_USB));
xlabel('f');
ylabel('S_{USB}');
title('�ѵ��źŵ��ϱߴ�����Ƶ��');
axis([-150 150 0 0.5]);
grid on;

% ��3��
n0 = 0.001; % �������߹������ܶ�
sigma = sqrt(n0*(1/dt)/2);
u = sigma*randn(1,N); % ����

s_SSB_ = s_SSB + u; % �����ŵ����ѵ��ź�

[f,S_SSB_] = T2F(t,s_SSB_); % Ƶ��

% ������ͨ�˲���
bpf = BPF(f,-f_c,f_c,1); % ��ͨ�˲���
S_SSB_BPF = bpf.*S_SSB_;
[t,s_SSB_BPF] = F2T(f,S_SSB_BPF); % ��ʱ��

% ��ɽ��
s_SSB_c = s_SSB_BPF.*c; % ���ز����
[f,S_SSB_c] = T2F(t,s_SSB_c);
lpf = LPF(B,f,4); % ��ͨ�˲���
S_SSB = lpf.*S_SSB_c;
[t,m_] = F2T(f,S_SSB);

subplot(414)
plot(t,m_);
xlabel('t');
ylabel('m''');
title('��ɽ������źŲ���');
grid on;

