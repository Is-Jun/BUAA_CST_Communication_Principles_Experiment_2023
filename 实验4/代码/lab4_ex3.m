clear;

N = 1000000; % ��Ϣ������
M = 4; % QPSK����
n = 7; % �����������鳤��
m = 3; % ��������ලλ����
graycode = [0,1,3,2]; % ���ױ������

x = randi([0,1],N,n-m); % ��Ϣ
x1 = reshape(x',log2(M),N*(n-m)/log2(M))'; % ��Ϣ����
x1_de = bi2de(x1,'left-msb'); % ת��ʮ����
x1 = graycode(x1_de+1); % ���ױ���
x1 = pskmod(x1,M); % QPSK����
Eb1 = norm(x1).^2/(N*(n-m)); % �����������
x2 = encode(x,n,n-m,'hamming/binary'); % ��������
x2 = reshape(x2',log2(M),N*n/log2(M))'; % ���ܱ��������
x2 = bi2de(x2,'left-msb'); % ת��ʮ����
x2 = graycode(x2+1); % ���ױ���
x2 = pskmod(x2,M); % QPSK����
Eb2 = norm(x2).^2/(N*(n-m)); % �����������

SNR_db = 0:10;
SNR = 10.^(SNR_db/10);
for i=1:length(SNR_db)
    sigma1 = sqrt(Eb1/(2*SNR(i))); % δ�����������׼��
    u1 = sigma1*(randn(1,length(x1))+1j*randn(1,length(x1))); % ����
    s1 = x1+u1;
    y1 = pskdemod(s1,M); % δ����QPSK����
    y1_de = graycode(y1+1); % δ����ĸ�����ӳ��
    [e pe1(i)] = biterr(x1_de',y1_de,log2(M)); % δ������������
    
    sigma2 = sqrt(Eb2/(2*SNR(i))); % �����������׼��
    u2 = sigma2*(randn(1,length(x2))+1j*randn(1,length(x2))); % ����
    s2 = x2+u2;
    y2 = pskdemod(s2,M); % ����QPSK����
    y2_de = graycode(y2+1); % ����ĸ�����ӳ��
    y2_de = de2bi(y2_de,'left-msb'); % ת��Ϊ��������ʽ
    y2_de = reshape(y2_de',n,N)'; % ����
    y2_de = decode(y2_de,n,n-m,'hamming/binary'); % ����
    [e pe2(i)] = biterr(x,y2_de); % δ������������
end

figure();
semilogy(SNR_db,pe1,'-bo',SNR_db,pe2,'-r*');
title('(7,4)���������QPSK����ͨ��AWGN�ŵ��������������ܱȽ�');
legend('δ����','(7,4)��������');
xlabel('SNR(dB)');
ylabel('�������');