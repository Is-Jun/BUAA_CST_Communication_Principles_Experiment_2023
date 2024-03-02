clear;

N = 1024; % ������
t = linspace(0,0.6,N); % ʱ��Χ
m = 0.1*cos(15*pi*t)+1.5*sin(25*pi*t)+0.5*cos(40*pi*t); % �����ź�m(t)
c = cos(250*pi*t); % �ز�c(t)
A = 3; % ֱ������
SNR_dB = 10; % ���ն����������
SNR = 10^(SNR_dB/10);


% �����ŵ�ǰ
s_AM = (A+m).*c; % AM��ʽ����
[f,S_AM] = T2F(t,s_AM); % Ƶ��

Pst = sum(abs(s_AM).^2)/length(s_AM); % �źŵķ��͹���
Pni = SNR/Pst; % �����������
u = sqrt(Pni)*randn(1,N); % �����ź�

subplot(321)
plot(t,s_AM);
xlabel('t');
ylabel('s_{AM}');
title('����AWGN�ŵ�ǰ���ѵ��ź�ʱ����ͼ');
grid on;

subplot(322);
plot(f,abs(S_AM));
xlabel('\omega');
ylabel('S_{AM}');
title('����AWGN�ŵ�ǰ���ѵ��ź�Ƶ��');
grid on;

% �����ŵ���

% �����ǽ����
s_AM_ = s_AM+u; % ����AWGN����ź�
[f, S_AM_] = T2F(t, s_AM_);

subplot(323)
plot(t, s_AM_);
xlabel('t');
ylabel('s_{AM}''');
title('����AWGN�ŵ�����ѵ��ź�ʱ����ͼ�������ǽ������');
grid on;

subplot(324)
plot(f,abs(S_AM_));
xlabel('\omega');
ylabel('S_{AM}''');
title('����AWGN�ŵ�����ѵ��ź�Ƶ�ף������ǽ������');
grid on;

% ���ǽ����
% ���ݹ�ʽ���n0
B = 40;
n0 = (sum(abs(s_AM).^2)/length(s_AM))/(SNR*B);
% ���ݹ�ʽ����������׼��
fs = 1/(t(2)-t(1));
sigma = sqrt(n0*fs/2);
u = sigma*randn(1,N); % ����
s_AM_ = s_AM+u; % ���ܵ��ź�
[f,S_AM_] = T2F(t,s_AM_);

subplot(325)
plot(t, s_AM_);
xlabel('t');
ylabel('s_{AM}''');
title('����AWGN�ŵ�����ѵ��ź�ʱ����ͼ�����ǽ������');
grid on;

subplot(326)
plot(f,abs(S_AM_));
xlabel('\omega');
ylabel('S_{AM}''');
title('����AWGN�ŵ�����ѵ��ź�Ƶ�ף����ǽ������');
grid on;

