clear;
x = 0:0.01:2*pi; % ʱ���źŵķ�Χ
y1 = 2*exp(-0.5*x); % ����1
y2 = cos(4*pi*x); % ����2

plot(x,y1); % ��ͼ
hold on; % ͼ�α���
plot(x,y2);

xlabel('x');
ylabel('y');
title('y1��y2�ĺ���ͼ��');
legend('y1=2e^{-0.5x}','y2=cos(4\pix)');
