function H = BPF(f,f_start,f_end,p)
%��ͨ�˲�������
%------------------------������� 
%f Ƶ��
%f_start ͨ����ʼƵ�� 
%f_end ��ͨ�˲����Ľ�ֹƵ�� 
%p �˲�������
%---------------------���(����)����
% H����ͨ�˲���Ƶ����Ӧ

n = length(f);
df = f(2)-f(1);
H = zeros(1,n);
n_start = floor((f_start - f(1))/df)+1;
n_end = ceil((f_end - f(1))/df)+1;
H(n_start:n_end) = p*ones(1,n_end-n_start+1);

end