function out = Sample(t,f,s,fs)  
% 抽样函数
%------------------------输入参数
% t：时域
% f：模拟频率
% s：输入信号
% fs：抽样频率
%---------------------输出(返回)参数
% out：抽样信号
gap = ceil(f/fs);
n = length(t);
out = zeros(1,n);
out(1:gap:n) = s(1:gap:n);

end
