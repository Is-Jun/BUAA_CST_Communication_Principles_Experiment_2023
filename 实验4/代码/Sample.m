function out = Sample(t,f,s,fs)  
% ��������
%------------------------�������
% t��ʱ��
% f��ģ��Ƶ��
% s�������ź�
% fs������Ƶ��
%---------------------���(����)����
% out�������ź�
gap = ceil(f/fs);
n = length(t);
out = zeros(1,n);
out(1:gap:n) = s(1:gap:n);

end
