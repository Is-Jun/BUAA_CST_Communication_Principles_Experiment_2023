function H = BPF(f,f_start,f_end,p)
%带通滤波器函数
%------------------------输入参数 
%f 频域
%f_start 通带起始频率 
%f_end 带通滤波器的截止频率 
%p 滤波器幅度
%---------------------输出(返回)参数
% H：带通滤波器频率响应

n = length(f);
df = f(2)-f(1);
H = zeros(1,n);
n_start = floor((f_start - f(1))/df)+1;
n_end = ceil((f_end - f(1))/df)+1;
H(n_start:n_end) = p*ones(1,n_end-n_start+1);

end