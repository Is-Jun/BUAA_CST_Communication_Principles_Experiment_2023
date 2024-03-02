function out = QAM_SJ(s,L)
% 抽样判决
%------------------------输入参数 
% s：原始信号
% L：判断点数
%---------------------输出(返回)参数
% out：输出信号
N = length(s)/L;
out = zeros(1,N);
d1 = -2;
d2 = 0;
d3 = 2;
for i = 1 : N
    if s((i-1)*L+L/2)<d1
        out(i) = -3;
    elseif s((i-1)*L+L/2)>=d1 && s((i-1)*L+L/2)<d2
        out(i) = -1;
    elseif s((i-1)*L+L/2)>=d2 && s((i-1)*L+L/2)<d3
        out(i) = 1;
    elseif s((i-1)*L+L/2)>=d3
        out(i) = 3;
    end
end

end
