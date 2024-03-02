function H = LPF(f_cutoff,f,p) 
% 低通滤波器
%------------------------输入参数
% f_cutoff：低通滤波器的截止频率
% f：频域
% p：滤波器幅度
%---------------------输出(返回)参数
% H：低通滤波器频率响应

n = length(f);
df = f(2)-f(1);
H = zeros(1,n);
n_start = floor((n/2)-(f_cutoff/df))+1;
n_end = ceil((n/2)+(f_cutoff/df))+1;
H(n_start:n_end) = p*ones(1,n_end-n_start+1);

end
