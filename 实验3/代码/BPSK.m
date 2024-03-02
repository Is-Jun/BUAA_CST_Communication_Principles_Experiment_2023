function out = BPSK(t,s,A,fc,L,d,B,SNRdb)
% bpsk���ƽ��
%------------------------������� 
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
%%  BPSK����
c = A*cos(2*pi*fc*t);  % �ز�
s_BPSK = c.*(s*2-1);
%% ��������
SNR = 10^(SNRdb/10);  % �����
B_bpf = 2*fc+2*B;  % �����ͨ�˲�������
P = (norm(s_BPSK(1:L)).^2)./length(s_BPSK(1:L));  % ���ƽ������
n0 = P/SNR/B_bpf;
u = sqrt(n0*L*fc/2)*randn(1,length(s));  % ����
s_BPSK_u = s_BPSK+u;  % �ź����������
%% �˲�������
[f,S_BPSK_u] = T2F(t,s_BPSK_u);   % ת����Ƶ��
S_BPSK_u_BPF = BPF(f,-(fc+B),fc+B,1).*S_BPSK_u;  % ������ͨ�˲�����
[t,s_BPSK_u_BPF] = F2T(f,S_BPSK_u_BPF);  % �任Ϊʱ��
s_BPSK_u_BPF_c = s_BPSK_u_BPF.*c ;  % �����ز�
[f,S_BPSK_u_BPF_c] = T2F(t,s_BPSK_u_BPF_c) ;  % �任��Ƶ��
S_BPSK_u_BPF_c_LPF = LPF(B,f,1).*(S_BPSK_u_BPF_c);  % ������ͨ�˲���
%% ����źš���LPF������źŽ��г����о�
[~,s] = F2T(f,S_BPSK_u_BPF_c_LPF);  % �任��ʱ��
out = BPSK_SJ(s,L,d);
end