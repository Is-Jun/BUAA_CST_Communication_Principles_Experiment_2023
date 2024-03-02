clear;
t = linspace(0,0.6,1024); % ʱ��Χ
x = 0.4*sin(100*pi*t)+0.4*sin(640*pi*t); % �ź�x(t)
u = randn(1, 1024); % ��ֵΪ0������Ϊ1�ĸ�˹�����ź�u(n)
y = x+u; % ���ߵ���

[f, Y] = T2F(t,y);

subplot(211)
plot(t,y);
xlabel('t');
ylabel('x(t)+u(n)');
title('x(t)��u(n)����ͼ��');
grid on;

subplot(212)
plot(f, abs(Y));
xlabel('Ƶ��(Hz)');
title('Ƶ��');
grid on;


