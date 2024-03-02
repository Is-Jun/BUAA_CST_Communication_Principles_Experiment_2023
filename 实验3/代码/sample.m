function out = sample(s,L)
% 抽样判决
%------------------------输入参数 
% s：原始信号
% L：判断点数
%---------------------输出(返回)参数
% out：输出信号
N = length(s)/L;
out = zeros(1,N);
for i = 1 : N
    out(i) = s((i-1)*L+L/2);
end

end
