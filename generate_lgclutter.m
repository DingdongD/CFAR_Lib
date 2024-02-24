function [clutter_data] = generate_lgclutter(radar_points, sigmav, muc, sigmac)
    fr = 1000;%�����ظ�Ƶ��
    lambda = 0.05;%����
    sigmaf = 2*sigmav/lambda;%������Ƶ��

    %���ɸ�˹����ֲ�����ͬ����������
    rand('state',sum(100*clock));%�������� 0-1�ľ��ȷֲ��������
    d1 = rand(1,radar_points);
    rand('state',7*sum(100*clock)+1);
    d2 = rand(1,radar_points);
    xi = 2*sqrt(-2*log(d1)).*cos(2*pi*d2);

    %�˲�����ƣ�����Ҷ����չ��
    coe_num = 12;
    for n = 0:coe_num
        coeff(n+1) = 2*sigmaf*sqrt(pi)*exp(-4*sigmaf^2*pi^2*n^2/fr^2)/fr;
    end
    for n = 1:2*coe_num+1
        if n <= coe_num+1
            b(n) = 1/2*coeff(coe_num+2-n);
        else
            b(n) = 1/2*coeff(n-coe_num);
        end
    end

    %���ɸ�˹���Ӳ�
    xxi = conv(b,xi);
    xxi = xxi(coe_num*2+1:radar_points+coe_num*2);
    xsigmac = std(xxi);
    xmuc = mean(xxi);
    yyi = (xxi-xmuc)/xsigmac;%��׼��һ��0-1��˹

    %�任���ɶ�����̬�ֲ�����
    yyi = sigmac*yyi+log(muc);
    clutter_data = exp(yyi);%���ɶ�����̬�ֲ����Ӳ�����
end