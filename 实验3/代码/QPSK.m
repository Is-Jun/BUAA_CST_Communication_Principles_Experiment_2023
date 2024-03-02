function out = QPSK(N,t,s,A,fc,L,d,B,SNRdb)
% bpsk���ƽ��
%------------------------������� 
% N��������Ԫ��
% t��ʱ��
% s��ԭʼ�ź�
% A���ز�����
% fc���ز�Ƶ��
% L��ÿ����Ԫ�Ĳ�������
% d���о�����
% B���źŴ���
% SNRdb�������
%---------------------���(����)����
% out������ź�
%% ���������ź�
s1_ = zeros(1,N/2); % _0��_1
s2_ = zeros(1,N/2); % 0_��1_
for i = 2:2:N % ����ת��
    if s(i-1)==0
        s1_(round(i/2)) = -1;
    else
        s1_(round(i/2)) = 1;
    end
    
    if s(i)==0
        s2_(round(i/2)) = -1;
    else
        s2_(round(i/2)) = 1;
    end
end
s1 = signal_expand(s1_,L);
s2 = signal_expand(s2_,L);
%% QPSK����
c1 = A*cos(2*pi*fc*t);  % �ز�
c2 = -A*sin(2*pi*fc*t);
s_QPSK = c1.*s1+c2.*s2;
%% ��������
SNR = 10^(SNRdb/10);  % �����
B_bpf = 2*fc+2*B;  % �����ͨ�˲�������
P = (norm(s_QPSK(1:L)).^2)./length(s_QPSK(1:L));  % ���ƽ������
n0 = P/SNR/B_bpf;
u = sqrt(n0*L*fc/2)*randn(1,L*N/2);  % ����
s_QPSK_u = s_QPSK+u;  % �ź����������
%% �˲�������
[f,S_QPSK_u] = T2F(t,s_QPSK_u); % Ƶ��
S_QPSK_u_BPF = BPF(f,-(fc+B),fc+B,1).*S_QPSK_u; % ������ͨ�˲���
[~,s_QPSK_u_BPF] = F2T(f,S_QPSK_u_BPF); % ʱ��
s1_QPSK_u_BPF_c = s_QPSK_u_BPF.*c1; % ���ز����
s2_QPSK_u_BPF_c = s_QPSK_u_BPF.*c2;
[~,S1_QPSK_u_BPF_c] = T2F(t,s1_QPSK_u_BPF_c); % Ƶ��
[~,S2_QPSK_u_BPF_c] = T2F(t,s2_QPSK_u_BPF_c);
S1_QPSK_u_BPF_c_LPF = LPF(B,f,2).*(S1_QPSK_u_BPF_c); % ������ͨ�˲���
S2_QPSK_u_BPF_c_LPF = LPF(B,f,2).*(S2_QPSK_u_BPF_c);
[~,s1_QPSK_u_BPF_c_LPF] = F2T(f,S1_QPSK_u_BPF_c_LPF); % ʱ��
[~,s2_QPSK_u_BPF_c_LPF] = F2T(f,S2_QPSK_u_BPF_c_LPF);
%% ����źš���LPF������źŽ��г����о�
s1_QPSK = QPSK_SJ(s1_QPSK_u_BPF_c_LPF,L,d); % �����о�
s2_QPSK = QPSK_SJ(s2_QPSK_u_BPF_c_LPF,L,d);
out = zeros(1,N); % ��ʼ��
for i = 1:1:round(N/2) % ����ת��
    out(2*i-1:2*i) = [s1_QPSK(i),s2_QPSK(i)];
end
end