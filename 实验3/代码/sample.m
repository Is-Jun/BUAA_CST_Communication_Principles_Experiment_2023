function out = sample(s,L)
% �����о�
%------------------------������� 
% s��ԭʼ�ź�
% L���жϵ���
%---------------------���(����)����
% out������ź�
N = length(s)/L;
out = zeros(1,N);
for i = 1 : N
    out(i) = s((i-1)*L+L/2);
end

end
