clear;

SNR = 1:0.5:10; % 信噪比范围
N = 1000000; % 信息比特个数
M = 2; % BPSK调制
L = 7; % 约束长度
trel = poly2trellis(L,[171,133]); % 卷积码生成多项式
tblen = 6*L; % Viterbi译码器回溯深度
x = randi([0,1],1,N); % 信息比特序列
x1 = convenc(x,trel); % 卷积编码
x_ = pskmod(x1,M); % BPSK调制
for i = 1:length(SNR)
    % 加入高斯白噪声，因为码率为1/2，所以每一个符号的能量要比比特能量少3dB
    y = awgn(x_,SNR(i)-3);
    y1 = pskdemod(y,M); % 硬判决
    y2 = vitdec(y1,trel,tblen,'cont','hard'); % Viterbi译码
    [err pe1(i)] = biterr(y2(tblen+1:end),x(1:end-tblen)); % 计算误比特率
    
    y3 = vitdec(real(y),trel,tblen,'cont','unquant'); % 软判决
    [err pe2(i)] = biterr(y3(tblen+1:end),x(1:end-tblen)); % 计算误比特率
end

ber = berawgn(SNR,'psk',2,'nodiff'); % BPSK调制理论误比特率
figure();
semilogy(SNR,ber,'-bd',SNR,pe1,'-go',SNR,pe2,'-r*');
legend('BPSK理论误比特率','硬判决的误比特率','软判决的误比特率');
xlabel('SNR');
ylabel('误比特率');