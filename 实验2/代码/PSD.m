function [f,fpd] = PSD(t,m)
% 功率谱密度
%------------------------输入参数
% t：时域
% m：信号
%---------------------输出(返回)参数
% f：频域
% fpd：功率谱密度
N = length(t);
T = t(end);
dt = t(2)-t(1);
Ns = 1/dt;  % 频率区间长度，见第二章定义，
df = 1/T;
M =fftshift(fft(m,N))/N;
fpd = abs(M).^2;
f = -N/2*df:df:N/2*df-df;
end