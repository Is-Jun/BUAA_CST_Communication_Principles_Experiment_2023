function out = QAM_SJ(s,L)
% �����о�
%------------------------������� 
% s��ԭʼ�ź�
% L���жϵ���
%---------------------���(����)����
% out������ź�
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
