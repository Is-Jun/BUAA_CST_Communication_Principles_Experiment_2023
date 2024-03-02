clear;

f = 1000; % Ƶ��
dt = 1/f; % ʱ����
t = -10:dt:10; % ʱ��

x = cos(0.15*pi*t)+sin(2.5*pi*t)+cos(4*pi*t); % ��ͨ�ź�
fx = 4*pi/(2*pi); % ����ź�Ƶ��

subplot(311)
plot(t,x);
title('��ͨ�źŵĲ���');
xlabel('t');
ylabel('����');
grid on;

subplot(312)
fs = 4; % ����Ƶ��
x_s = Sample(t,f,x,fs); % ���źŽ��г���
plot(t,x_s);
title('��������');
xlabel('t');
ylabel('����');

subplot(313)
t_ = -20:dt:20; % �������ʱ��
Sa = sinc(fs*t); % �ָ��ź�
x_ = conv(Sa,x_s);
plot(t_,x_);
hold on;
plot(t,x);
title('�ָ����ź���ԭ�źűȽ�');
legend('�ָ��ź�','ԭ�ź�');
xlabel('t');
ylabel('����');
axis([-10,10,-4,4])