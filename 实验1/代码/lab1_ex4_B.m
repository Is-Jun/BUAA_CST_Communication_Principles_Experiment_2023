clear;
% ���ex4�л�������
N = 1024; % ������
t = linspace(0,0.6,N); % ʱ��Χ
m = 0.1*cos(15*pi*t)+1.5*sin(25*pi*t)+0.5*cos(40*pi*t); % �����ź�m(t)

[f,M] = T2F(t,m); % Ƶ��

plot(f,abs(M));
xlabel('\omega');
ylabel('M(\omega)');
title('�����ź�Ƶ��');
axis([-40 40 0 0.6]);