function [f,fpd] = PSD(t,m)
% �������ܶ�
%------------------------�������
% t��ʱ��
% m���ź�
%---------------------���(����)����
% f��Ƶ��
% fpd���������ܶ�
N = length(t);
T = t(end);
dt = t(2)-t(1);
Ns = 1/dt;  % Ƶ�����䳤�ȣ����ڶ��¶��壬
df = 1/T;
M =fftshift(fft(m,N))/N;
fpd = abs(M).^2;
f = -N/2*df:df:N/2*df-df;
end