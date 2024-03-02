function out = QAM(N,t,b,A,fc,L,B,SNRdb)
% bpsk���ƽ��
%------------------------������� 
% N��������Ԫ��
% t��ʱ��
% b��ԭʼ�ź�
% A���ز�����
% fc���ز�Ƶ��
% L��ÿ����Ԫ�Ĳ�������
% B���źŴ���
% SNRdb�������
%% �����ź����ز�
I = zeros(1,N/4); 
Q = zeros(1,N/4); 
for i = 4:4:N  % ����ת�� �� 2-4��ƽת��
    if b(i-3)==0 && b(i-1)==0
        I(round(i/4)) = -3;
    elseif b(i-3)==0 && b(i-1)==1
        I(round(i/4)) = -1;
    elseif b(i-3)==1 && b(i-1)==0
        I(round(i/4)) = 1;
    else
        I(round(i/4)) = 3;
    end
    
    if b(i-2)==0 && b(i)==0
        Q(round(i/4)) = -3;
    elseif b(i-2)==0 && b(i)==1
        Q(round(i/4)) = -1;
    elseif b(i-2)==1 && b(i)==0
        Q(round(i/4)) = 1;
    else
        Q(round(i/4)) = 3;
    end
end

I = signal_expand(I,L);
Q = signal_expand(Q,L);
%% QAM����
c1 = A*cos(2*pi*fc*t);  % �ز�1
c2 = -A*sin(2*pi*fc*t);  % �ز�2
s_QAM = I.*c1+Q.*c2;
%% ����
SNR = 10^(SNRdb/10);
B_bpf = 2*(B+fc); % �����ͨ�˲�������
P = (norm(s_QAM(1:L)).^2)./length(s_QAM(1:L)); % ƽ������
n0 = (P/SNR)/B_bpf; % �����������ܶ�
u = sqrt(n0*L*fc/2)*randn(1,L*N/4); % ����
s_QAM_u = s_QAM+u; % �����ŵ����ѵ��ź�
%% �˲�������
[f,S_QAM_u] = T2F(t,s_QAM_u); % Ƶ��
S_QAM_u_BPF = BPF(f,-(fc+B),fc+B,1).*S_QAM_u; % ������ͨ�˲���
[~,s_QAM_u_BPF] = F2T(f,S_QAM_u_BPF); % ʱ��
s1_QAM_u_BPF_c = s_QAM_u_BPF.*c1; % ���ز����
s2_QAM_u_BPF_c = s_QAM_u_BPF.*c2;
[~,S1_QAM_u_BPF_c] = T2F(t,s1_QAM_u_BPF_c); % Ƶ��
[~,S2_QAM_u_BPF_c] = T2F(t,s2_QAM_u_BPF_c);
S1_QAM_u_BPF_c_LPF = LPF(B,f,2).*(S1_QAM_u_BPF_c); % ������ͨ�˲���
S2_QAM_u_BPF_c_LPF = LPF(B,f,2).*(S2_QAM_u_BPF_c);
[~,s1_QAM_u_BPF_c_LPF] = F2T(f,S1_QAM_u_BPF_c_LPF); % ʱ��
[~,s2_QAM_u_BPF_c_LPF] = F2T(f,S2_QAM_u_BPF_c_LPF);
%% ���
s1_QAM = QAM_SJ(s1_QAM_u_BPF_c_LPF,L); % �����о�
s2_QAM = QAM_SJ(s2_QAM_u_BPF_c_LPF,L);
out = zeros(1,N);  % ��ʼ��
for i = 1:1:round(N/4)  % ����ת��
    if s1_QAM(i) == -3
        out(4*i-3) = 0;
        out(4*i-1) = 0;
    elseif s1_QAM(i) == -1
        out(4*i-3) = 0;
        out(4*i-1) = 1;
    elseif s1_QAM(i) == 1
        out(4*i-3) = 1;
        out(4*i-1) = 0;
    else
        out(4*i-3) = 1;
        out(4*i-1) = 1;
    end
    
    if s2_QAM(i) == -3
        out(4*i-2) = 0;
        out(4*i) = 0;
    elseif s2_QAM(i) == -1
        out(4*i-2) = 0;
        out(4*i) = 1;
    elseif s2_QAM(i) == 1
        out(4*i-2) = 1;
        out(4*i) = 0;
    else
        out(4*i-2) = 1;
        out(4*i) = 1;
    end
end
end
