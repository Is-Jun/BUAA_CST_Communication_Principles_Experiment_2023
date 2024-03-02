clear;
N = 500000; % u(n)�ĳ���

u = sqrt(0.1)*randn(1, N); % ����randn���õ���ֵΪ0������Ϊ0.1�İ�����u(n)

subplot(211)
plot(u(1:100));
grid on; % ��һ��ͼ�Ϸ�Ϊ����������ͼ
ylabel('u(n)');
xlabel('n');

subplot(212)
hist(u, 50); % ��u(n)��ֱ��ͼ��������ֲ���50�Ƕ�ȡֵ��Χ[0,1]����Ϊ50��
grid on; % ����
ylabel('����������״ͼ');
