clear;

N = 1000000; % 消息比特数
M = 4; % QPSK调制
n = 7; % 汉明编码码组长度
m = 3; % 汉明编码监督位长度
graycode = [0,1,3,2]; % 格雷编码规则

x = randi([0,1],N,n-m); % 消息
x1 = reshape(x',log2(M),N*(n-m)/log2(M))'; % 消息重塑
x1_de = bi2de(x1,'left-msb'); % 转成十进制
x1 = graycode(x1_de+1); % 格雷编码
x1 = pskmod(x1,M); % QPSK调制
Eb1 = norm(x1).^2/(N*(n-m)); % 计算比特能量
x2 = encode(x,n,n-m,'hamming/binary'); % 汉明编码
x2 = reshape(x2',log2(M),N*n/log2(M))'; % 重塑编码后序列
x2 = bi2de(x2,'left-msb'); % 转成十进制
x2 = graycode(x2+1); % 格雷编码
x2 = pskmod(x2,M); % QPSK调制
Eb2 = norm(x2).^2/(N*(n-m)); % 计算比特能量

SNR_db = 0:10;
SNR = 10.^(SNR_db/10);
for i=1:length(SNR_db)
    sigma1 = sqrt(Eb1/(2*SNR(i))); % 未编码的噪声标准差
    u1 = sigma1*(randn(1,length(x1))+1j*randn(1,length(x1))); % 噪声
    s1 = x1+u1;
    y1 = pskdemod(s1,M); % 未编码QPSK调制
    y1_de = graycode(y1+1); % 未编码的格雷逆映射
    [e pe1(i)] = biterr(x1_de',y1_de,log2(M)); % 未编码的误比特率
    
    sigma2 = sqrt(Eb2/(2*SNR(i))); % 编码的噪声标准差
    u2 = sigma2*(randn(1,length(x2))+1j*randn(1,length(x2))); % 噪声
    s2 = x2+u2;
    y2 = pskdemod(s2,M); % 编码QPSK调制
    y2_de = graycode(y2+1); % 编码的格雷逆映射
    y2_de = de2bi(y2_de,'left-msb'); % 转换为二进制形式
    y2_de = reshape(y2_de',n,N)'; % 重塑
    y2_de = decode(y2_de,n,n-m,'hamming/binary'); % 译码
    [e pe2(i)] = biterr(x,y2_de); % 未编码的误比特率
end

figure();
semilogy(SNR_db,pe1,'-bo',SNR_db,pe2,'-r*');
title('(7,4)汉明编码的QPSK调制通过AWGN信道后的误比特率性能比较');
legend('未编码','(7,4)汉明编码');
xlabel('SNR(dB)');
ylabel('误比特率');