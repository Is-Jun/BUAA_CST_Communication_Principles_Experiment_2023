function H = LPF(f_cutoff,f,p) 
% ��ͨ�˲���
%------------------------�������
% f_cutoff����ͨ�˲����Ľ�ֹƵ��
% f��Ƶ��
% p���˲�������
%---------------------���(����)����
% H����ͨ�˲���Ƶ����Ӧ

n = length(f);
df = f(2)-f(1);
H = zeros(1,n);
n_start = floor((n/2)-(f_cutoff/df))+1;
n_end = ceil((n/2)+(f_cutoff/df))+1;
H(n_start:n_end) = p*ones(1,n_end-n_start+1);

end
