function [out]=signal_expand(s,L)   
% �ź���չ
%------------------------�������
% s��ԭ�ź�
% L���ź���չ��һ����Ԫ����
%---------------------���(����)����
% out����չ���ź�
N=length(s);             %�����ź���Ԫ����
out=zeros(1,N*L);
for i = 1 : N
    out((i-1)*L+1:i*L) = repmat(s(i), 1, L);
end
end