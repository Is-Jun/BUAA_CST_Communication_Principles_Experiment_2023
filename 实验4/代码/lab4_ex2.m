clear;

f = 160; % Ƶ��
dt = 1/f; % ʱ����
t = -2:dt:2; % ʱ��

Ac = 1;
x = Ac*sin(2*pi*t); % �����ź�
fs = 160;
x_s = Sample(t,f,x,fs); % ����
[n,x_PCM_en] = PCM(t,x_s,1,2048); % ����
[~,x_PCM_de] = PCM(n,x_PCM_en,0,2048); % ����

subplot(311)
plot(n,x_PCM_en);
title('PCM��������');
xlabel('N');
ylabel('����');
axis([0 100 0 1.2]);
grid on;

subplot(312)
plot(t,x_PCM_de);
hold on;
plot(t,x);
title('PCM������ԭ�źŶԱ�ͼ');
legend('PCM����','ԭ�ź�');
xlabel('t');
ylabel('����');
grid on;

Ac_db = -70:0;
Ac = 10.^(Ac_db/10);
s = zeros(1,length(Ac)); % �ź�
u = zeros(1,length(Ac)); % ����

for i=1:1:length(Ac)
    x = sqrt(Ac(i))*sin(2*pi*t);
    x_s = Sample(t,f,x,fs);
    [n,x_PCM_en] = PCM(t,x_s,1,2048); % PCM����
    [~,x_PCM_de] = PCM(n,x_PCM_en,0,2048); % PCM����
    u(i) = mean((x-x_PCM_de).^2);
    s(i) = mean(x_PCM_de.^2);
end
SNR = s./u;

subplot(313)
plot(Ac_db,10*log10(SNR));
title('��ͬ������PCM���������������');
xlabel('A_c');
ylabel('�����');
grid on;