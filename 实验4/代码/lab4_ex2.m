clear;

f = 160; % 频率
dt = 1/f; % 时间间隔
t = -2:dt:2; % 时域

Ac = 1;
x = Ac*sin(2*pi*t); % 输入信号
fs = 160;
x_s = Sample(t,f,x,fs); % 抽样
[n,x_PCM_en] = PCM(t,x_s,1,2048); % 编码
[~,x_PCM_de] = PCM(n,x_PCM_en,0,2048); % 译码

subplot(311)
plot(n,x_PCM_en);
title('PCM编码序列');
xlabel('N');
ylabel('幅度');
axis([0 100 0 1.2]);
grid on;

subplot(312)
plot(t,x_PCM_de);
hold on;
plot(t,x);
title('PCM译码与原信号对比图');
legend('PCM译码','原信号');
xlabel('t');
ylabel('幅度');
grid on;

Ac_db = -70:0;
Ac = 10.^(Ac_db/10);
s = zeros(1,length(Ac)); % 信号
u = zeros(1,length(Ac)); % 噪声

for i=1:1:length(Ac)
    x = sqrt(Ac(i))*sin(2*pi*t);
    x_s = Sample(t,f,x,fs);
    [n,x_PCM_en] = PCM(t,x_s,1,2048); % PCM编码
    [~,x_PCM_de] = PCM(n,x_PCM_en,0,2048); % PCM译码
    u(i) = mean((x-x_PCM_de).^2);
    s(i) = mean(x_PCM_de.^2);
end
SNR = s./u;

subplot(313)
plot(Ac_db,10*log10(SNR));
title('不同幅度下PCM译码后的量化信噪比');
xlabel('A_c');
ylabel('信噪比');
grid on;