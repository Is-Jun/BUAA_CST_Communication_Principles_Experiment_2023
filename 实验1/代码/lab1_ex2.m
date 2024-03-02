clear;
N = 500000; % u(n)的长度

u = sqrt(0.1)*randn(1, N); % 调用randn，得到均值为0，方差为0.1的白噪声u(n)

subplot(211)
plot(u(1:100));
grid on; % 在一个图上分为上下两个子图
ylabel('u(n)');
xlabel('n');

subplot(212)
hist(u, 50); % 对u(n)做直方图，检验其分布，50是对取值范围[0,1]均分为50份
grid on; % 网格
ylabel('白噪声的柱状图');
