clear;

N = 256; % ������Ԫ��
Ts = 1; % ��Ԫ����ʱ��
A = 1; % �ز���ֵ
fc = 20; % �ز�Ƶ��
L = 1000; % ÿ����Ԫ�Ĳ�������
dt = Ts/L; % �������
T = N*Ts; % ��ʱ��
t = 0:dt:T-dt; % ʱ��
t_ = 0:dt:T/4-dt;

% ���ɵ����ź�
b = randi([0,1],1,N); % �����������
s = signal_expand(b,L); 

subplot(321)
plot(t,s);
title('�����ź�');
xlabel('t');
ylabel('����');
axis([0,6,0,1.2]);
grid on;

% QAM
% ����I��Q·��Ԫ
I = zeros(1,N/4); 
Q = zeros(1,N/4); 
for i = 4:4:N % ����ת����2-4��ƽת��
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
c1 = A*cos(2*pi*fc*t_); % �ز�1
c2 = -A*sin(2*pi*fc*t_); % �ز�2
s_QAM = I.*c1+Q.*c2;

subplot(323)
plot(t_,s_QAM);
title('QAM�ѵ��ź�');
xlabel('t');
ylabel('����');
axis([0,6,-5,5]);

% ����
SNRdb = 0; % �����
SNR = 10^(SNRdb/10);
B = 4; % ��������
B_bpf = 2*(B+fc); % �����ͨ�˲�������
P = (norm(s_QAM(1:L)).^2)./length(s_QAM(1:L)); % ƽ������
n0 = (P/SNR)/B_bpf; % �����������ܶ�
u = sqrt(n0*L*fc/2)*randn(1,L*N/4); % ����
s_QAM_u = s_QAM+u; % �����ŵ����ѵ��ź�

% �˲���
[f,S_QAM_u] = T2F(t_,s_QAM_u); % Ƶ��
S_QAM_u_BPF = BPF(f,-(fc+B),fc+B,1).*S_QAM_u; % ������ͨ�˲���
[~,s_QAM_u_BPF] = F2T(f,S_QAM_u_BPF); % ʱ��
s1_QAM_u_BPF_c = s_QAM_u_BPF.*c1; % ���ز����
s2_QAM_u_BPF_c = s_QAM_u_BPF.*c2;
[~,S1_QAM_u_BPF_c] = T2F(t_,s1_QAM_u_BPF_c); % Ƶ��
[~,S2_QAM_u_BPF_c] = T2F(t_,s2_QAM_u_BPF_c);
S1_QAM_u_BPF_c_LPF = LPF(B,f,2).*(S1_QAM_u_BPF_c); % ������ͨ�˲���
S2_QAM_u_BPF_c_LPF = LPF(B,f,2).*(S2_QAM_u_BPF_c);
[~,s1_QAM_u_BPF_c_LPF] = F2T(f,S1_QAM_u_BPF_c_LPF); % ʱ��
[~,s2_QAM_u_BPF_c_LPF] = F2T(f,S2_QAM_u_BPF_c_LPF);

subplot(324)
plot(t_,s1_QAM_u_BPF_c_LPF);
hold on;
plot(t_,s2_QAM_u_BPF_c_LPF);
title('��ͨ�˲�������ź�');
xlabel('t');
ylabel('����');
legend('ͬ�����','��������');
axis([0,6,-10,10]);
grid on;

% ���
s1_QAM = QAM_SJ(s1_QAM_u_BPF_c_LPF,L); % �����о�
s2_QAM = QAM_SJ(s2_QAM_u_BPF_c_LPF,L);
s1_QAM_ = sample(s1_QAM_u_BPF_c_LPF,L);
s2_QAM_ = sample(s2_QAM_u_BPF_c_LPF,L);

% 16QAM������
constellation = [-(3+3i), -(3+1i), -(3-3i), -(3-1i), ...
                 -(1+3i), -(1+1i), -(1-3i), -(1-1i), ...
                 (3+3i), (3+1i), (3-3i), (3-1i), ...
                 (1+3i), (1+1i), (1-3i), (1-1i)];
% ��������ͼ
subplot(322)
scatter(real(constellation), imag(constellation), 'filled');
hold on;
scatter(s1_QAM_, s2_QAM_);
grid on;
axis([-7,7,-3.5,3.5]);
title('16QAM ����ͼ');
xlabel('I');
ylabel('R');
ax = gca;  % ��ȡ��ǰ���������
ax.XAxisLocation = 'origin';  % ����X����ʾ������
ax.YAxisLocation = 'origin';  % ����Y����ʾ������

b = zeros(1,N); % ��ʼ��
for i = 1:1:round(N/4)  % ����ת��
    if s1_QAM(i) == -3
        b(4*i-3) = 0;
        b(4*i-1) = 0;
    elseif s1_QAM(i) == -1
        b(4*i-3) = 0;
        b(4*i-1) = 1;
    elseif s1_QAM(i) == 1
        b(4*i-3) = 1;
        b(4*i-1) = 0;
    else
        b(4*i-3) = 1;
        b(4*i-1) = 1;
    end
    
    if s2_QAM(i) == -3
        b(4*i-2) = 0;
        b(4*i) = 0;
    elseif s2_QAM(i) == -1
        b(4*i-2) = 0;
        b(4*i) = 1;
    elseif s2_QAM(i) == 1
        b(4*i-2) = 1;
        b(4*i) = 0;
    else
        b(4*i-2) = 1;
        b(4*i) = 1;
    end
end
s = signal_expand(b,L); 

subplot(325)
plot(t,s);
title('����ź�');
xlabel('t');
ylabel('����');
axis([0,6,0,1.2]);

% �����
SNR1 = -15; % ��С�����
SNR2 = 5; % ��������
T = 30; % ����
n = SNR1:SNR2; % ����Ⱥ���
Pe_theory = 1-(1-(3*(0.5*erfc(sqrt(10.^(n/10))/sqrt(40)))-9/4*(0.5*erfc(sqrt(10.^(n/10))/sqrt(40))).^2)).^(1/4); % ����������
Pe_practice = zeros(1,length(n)); % ʵ��������
for SNR = SNR1:SNR2
    for i = 1:T
        b = randi([0,1],1,N); % �����������
        out = QAM(N,t_,b,A,fc,L,B,SNR);  % ���е��ƽ��
        out = out - b;  % �źŲ�
        Pe_practice(-SNR1+SNR+1) = Pe_practice(-SNR1+SNR+1) + (sum(abs(out),'double')/N);  % �����ۼ�
    end
    Pe_practice(-SNR1+SNR+1)=Pe_practice(-SNR1+SNR+1)/T; % ƽ��������
end

subplot(326)
semilogy(n,Pe_theory);
hold on;
semilogy(n,Pe_practice);
legend('����������','ʵ��������');
title('����������');
xlabel('�����');
ylabel('������');
axis([-15 5 0.1 1]);
