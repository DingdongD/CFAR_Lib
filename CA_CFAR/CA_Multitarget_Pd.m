clc;clear all;close all;
% ��������Ҫ�о���Ŀ�������CA-CFAR��������ȵļ������
%% ������ʼ��
N = 36; %����������
n = N / 2; %ǰ���زο���Ԫ����
Pfa = 1e-6; %�龯����
SNR_dB = 5:1:35; %�����
SNR = 10 .^ (SNR_dB / 10);
Lth = length(SNR); %������������䳤��
T = Pfa ^ (-1 / N) - 1; %��������
monte_num = 1e5;

%%���ؿ���ģ��
Pd_CA1 = 0;
for i = 1:Lth
    detect_num = 0; %���ü���ź���Ŀ����
    for j = 1:monte_num
        lambda = 1;
        u = rand(1,N-1);
        exp_noise = log(u) * (-lambda);
        lambda = SNR(i) + 1;
        u = rand(1,2);
        exp_target = log(u(1)) * (-lambda);
        exp_noise(N) = log(u(2)) * (-lambda);
        cfar = exp_target / sum(exp_noise);
        if cfar > T
            detect_num = detect_num + 1;
        end
    end
    Pd_CA1(i) = detect_num / monte_num;
end
plot(SNR_dB,Pd_CA1,'bo-','LineWidth',1.5);
hold on;

Pd_CA2 = 0;
for i = 1:Lth
    detect_num = 0; %���ü���ź���Ŀ����
    for j = 1:monte_num
        lambda = 1;
        u = rand(1,N-2);
        exp_noise = log(u) * (-lambda);
        lambda = SNR(i) + 1;
        u = rand(1,3);
        exp_target = log(u(3)) * (-lambda);
        exp_noise(N-1) = log(u(2)) * (-lambda);
        exp_noise(N) = log(u(1)) * (-lambda);
        cfar = exp_target / sum(exp_noise);
        if cfar > T
            detect_num = detect_num + 1;
        end
    end
    Pd_CA2(i) = detect_num / monte_num;
end
plot(SNR_dB,Pd_CA2,'rs-','LineWidth',1.5);
hold on;        

Pd_CA3 = 0;
for i = 1:Lth
    detect_num = 0; %���ü���ź���Ŀ����
    for j = 1:monte_num
        lambda = 1;
        u = rand(1,N-3);
        exp_noise = log(u) * (-lambda);
        lambda = SNR(i) + 1;
        u = rand(1,4);
        exp_target = log(u(4)) * (-lambda);
        exp_noise(N-2) = log(u(3)) * (-lambda);
        exp_noise(N-1) = log(u(2)) * (-lambda);
        exp_noise(N) = log(u(1)) * (-lambda);
        cfar = exp_target / sum(exp_noise);
        if cfar > T
            detect_num = detect_num + 1;
        end
    end
    Pd_CA3(i) = detect_num / monte_num;
end

plot(SNR_dB,Pd_CA3,'kd-','LineWidth',1.5);
hold on;     
grid minor;
xlabel('\fontname{Times New Roman}SNR/dB');
ylabel('\fontname{����}������\fontname{Times New Roman}Pd');
title('\fontname{Times New Roman}r\fontname{����}������Ŀ�������\fontname{Times New Roman}CA-CAFR\fontname{����}������\fontname{Times New Roman}(N=36,Pfa=1e-6)');
h = legend('r=1','r=2','r=3','Location','SouthEast','NumColumns',1);
set(h,'edgecolor','none');