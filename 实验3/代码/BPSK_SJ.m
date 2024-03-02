function out = BPSK_SJ(s,L,d)
% 抽样判决
%------------------------输入参数 
% s：原始信号
% L：判断点数
% d:判决门限
%---------------------输出(返回)参数
% out：输出信号
N = length(s)/L;
out = zeros(1,N);
for i = 1 : N
    if s((i-1)*L+L/2)>d
        out((i-1)*L+1:i*L) = ones(1,L);
    else
        out((i-1)*L+1:i*L) = zeros(1,L);
    end
end

end