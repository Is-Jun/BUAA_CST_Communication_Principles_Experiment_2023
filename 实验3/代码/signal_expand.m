function [out]=signal_expand(s,L)   
% 信号拓展
%------------------------输入参数
% s：原信号
% L：信号拓展后一个码元长度
%---------------------输出(返回)参数
% out：拓展后信号
N=length(s);             %基带信号码元长度
out=zeros(1,N*L);
for i = 1 : N
    out((i-1)*L+1:i*L) = repmat(s(i), 1, L);
end
end