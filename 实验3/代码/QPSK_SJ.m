function out = QPSK_SJ(s,L,d)
% �����о�
%------------------------������� 
% s��ԭʼ�ź�
% L���жϵ���
% d:�о�����
%---------------------���(����)����
% out������ź�
N = length(s)/L;
out = zeros(1,N);
for i = 1 : N
    if s((i-1)*L+L/2)>d
        out(i) = 1;
    else
        out(i) = 0;
    end
end

end