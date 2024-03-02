function [n,y] = PCM(t,s,mode,delta)  
% A��13����PCM����
%------------------------�������
% t��ʱ��
% s���ź�
% mode��ģʽ(1:����,0:����)
% delta��delta
%---------------------���(����)����
% n���任�����к�
% y�������ź�

if mode == 1
    %% ����
    len = length(t);
    n = 1:1:8*len;
    y = zeros(1,8*len);
    for i = 1:8:8*len
        y(i:i+7) = pcm_e(s(floor(i/8)+1),delta);
    end
else
    %% ����
    len = floor(length(t)/8);
    n = [];  % ��ֵ
    y = zeros(1,len);
    for i = 1:1:len
        y(i) = pcm_d(s((i-1)*8+1:(i-1)*8+8),delta);
    end
end
%% �����Ӻ���
    function y = pcm_e(x,delta)
        % ���ֱ���
        y = zeros(1,8);
        %% ������
        if x > 0
            y(1) = 1;
        end
        x = abs(x);
        %% ������
        seg = floor(x*delta);
        if 0 <= seg && seg < 16
            y(2)=0;y(3)=0;y(4)=0;step=1;st=0;
        elseif 16 <= seg && seg < 32
            y(2)=0;y(3)=0;y(4)=1;step=1;st=16;
        elseif 32 <= seg && seg < 64
            y(2)=0;y(3)=1;y(4)=0;step=2;st=32;
        elseif 64 <= seg && seg < 128
            y(2)=0;y(3)=1;y(4)=1;step=4;st=64;
        elseif 128 <= seg && seg < 256
            y(2)=1;y(3)=0;y(4)=0;step=8;st=128;
        elseif 256 <= seg && seg < 512
            y(2)=1;y(3)=0;y(4)=1;step=16;st=256;
        elseif 512 <= seg && seg < 1024
            y(2)=1;y(3)=1;y(4)=0;step=32;st=512;
        else
            y(2)=1;y(3)=1;y(4)=1;step=64;st=1024;
        end
        
        %% ������
        ise = floor((seg-st)/step);
        if ise < 16
            y(5:8) = (dec2bin(ise,4)-48);
        else
            y(5:8) = [1,1,1,1];
        end
    end

%% �����Ӻ���
    function y = pcm_d(x,delta)
        %% ������
        pol = x(1)*2-1;
        %% ������
        if x(2)==0&&x(3)==0&&x(4)==0
            step = 1;st=0;
        elseif x(2)==0&&x(3)==0&&x(4)==1
            step = 1;st=16;
        elseif x(2)==0&&x(3)==1&&x(4)==0
            step = 2;st=32;
        elseif x(2)==0&&x(3)==1&&x(4)==1
            step = 4;st=64;
        elseif x(2)==1&&x(3)==0&&x(4)==0
            step = 8;st=128;
        elseif x(2)==1&&x(3)==0&&x(4)==1
            step = 16;st=256;
        elseif x(2)==1&&x(3)==1&&x(4)==0
            step = 32;st=512;
        else
            step = 64;st=1024;
        end

        %% ������
        ise = x(5)*8+x(6)*4+x(7)*2+x(8);
        seg = ise*step+0.5*step+st;
        y = pol*seg/delta;
    end

end
