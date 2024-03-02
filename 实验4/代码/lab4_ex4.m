clear;

SNR = 1:0.5:10; % ����ȷ�Χ
N = 1000000; % ��Ϣ���ظ���
M = 2; % BPSK����
L = 7; % Լ������
trel = poly2trellis(L,[171,133]); % ��������ɶ���ʽ
tblen = 6*L; % Viterbi�������������
x = randi([0,1],1,N); % ��Ϣ��������
x1 = convenc(x,trel); % �������
x_ = pskmod(x1,M); % BPSK����
for i = 1:length(SNR)
    % �����˹����������Ϊ����Ϊ1/2������ÿһ�����ŵ�����Ҫ�ȱ���������3dB
    y = awgn(x_,SNR(i)-3);
    y1 = pskdemod(y,M); % Ӳ�о�
    y2 = vitdec(y1,trel,tblen,'cont','hard'); % Viterbi����
    [err pe1(i)] = biterr(y2(tblen+1:end),x(1:end-tblen)); % �����������
    
    y3 = vitdec(real(y),trel,tblen,'cont','unquant'); % ���о�
    [err pe2(i)] = biterr(y3(tblen+1:end),x(1:end-tblen)); % �����������
end

ber = berawgn(SNR,'psk',2,'nodiff'); % BPSK���������������
figure();
semilogy(SNR,ber,'-bd',SNR,pe1,'-go',SNR,pe2,'-r*');
legend('BPSK�����������','Ӳ�о����������','���о����������');
xlabel('SNR');
ylabel('�������');