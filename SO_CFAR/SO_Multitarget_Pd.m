clc;clear all;close all;
% ��������Ҫ�о���Ŀ�������SO-CFAR��������ȵļ������

%% ������ʼ��
N = 36; %����������
n = N / 2; %ǰ���زο���Ԫ����
Pfa = 1e-6; %�龯����
SNR_dB = 5:1:35; %�����
SNR = 10 .^ (SNR_dB / 10);
Lth = length(SNR); %������������䳤��
T = Pfa ^ (-1 / N) - 1; %��������
monte_num = 1e5;

%% ���ؿ���ģ��1
Pd_SO1 = 0;
for i = 1:Lth
    detect_num = 0; %���ü���ź���Ŀ����
    for j = 1:monte_num
        lambda = 1;
        u = rand(1,N);
        exp_noise = log(u) * (-lambda);
        lambda = SNR(i) + 1;
        u = rand(1,2);
        exp_target = log(u(1)) * (-lambda); %��Ҫ�ź�
        InterPos = randi([1+n,N],1,1); %���زο���1������
        exp_noise(InterPos) = log(u(2)) * (-lambda); 
        cfar = exp_target / min(sum(exp_noise(1:N/2)),sum(exp_noise(N/2+1:N)));
        if cfar > T
            detect_num = detect_num + 1;
        end
    end
    Pd_SO1(i) = detect_num / monte_num;
end
plot(SNR_dB,Pd_SO1,'bo-','LineWidth',1.5);
hold on;

Pd_SO2 = 0;
for i = 1:Lth
    detect_num = 0; %���ü���ź���Ŀ����
    for j = 1:monte_num
        lambda = 1;
        u = rand(1,N);
        exp_noise = log(u) * (-lambda);
        lambda = SNR(i) + 1;
        u = rand(1,3);
        exp_target = log(u(1)) * (-lambda); %��Ҫ�ź�
        InterPos = randi([1+n,N],1,2); %���زο���������������
        exp_noise(InterPos(1)) =  log(u(2)) * (-lambda); 
        exp_noise(InterPos(2)) =  log(u(3)) * (-lambda); 
        cfar = exp_target / min(sum(exp_noise(1:N/2)),sum(exp_noise(N/2+1:N)));
        if cfar > T
            detect_num = detect_num + 1;
        end
    end
    Pd_SO2(i) = detect_num / monte_num;
end
plot(SNR_dB,Pd_SO2,'rs-','LineWidth',1.5);
hold on;

Pd_SO3 = 0;
for i = 1:Lth
    detect_num = 0; %���ü���ź���Ŀ����
    for j = 1:monte_num
        lambda = 1;
        u = rand(1,N);
        exp_noise = log(u) * (-lambda);
        lambda = SNR(i) + 1;
        u = rand(1,3);
        exp_target = log(u(1)) * (-lambda); %��Ҫ�ź�
        InterPos1 = randi([1,n],1,1); %ǰ�زο�������1������
        InterPos2 = randi([n+1,N],1,1); %���زο�������1������
        exp_noise(InterPos1) =  log(u(2)) * (-lambda); 
        exp_noise(InterPos2) =  log(u(3)) * (-lambda); 
        cfar = exp_target / min(sum(exp_noise(1:N/2)),sum(exp_noise(N/2+1:N)));
        if cfar > T
            detect_num = detect_num + 1;
        end
    end
    Pd_SO3(i) = detect_num / monte_num;
end
plot(SNR_dB,Pd_SO3,'kd-','LineWidth',1.5);
hold on; 

%% ���ؿ���ģ��2
% Pd_SO1 = 0;
% for i = 1:Lth
%     detect_num = 0; %���ü���ź���Ŀ����
%     for j = 1:monte_num
%         lambda = 1;
%         u = rand(1,N);
%         exp_noise = log(u) * (-lambda);
%         lambda = SNR(i) + 1;
%         u = rand(1,2);
%         exp_target = log(u(1)) * (-lambda); %��Ҫ�ź�
%         InterPos = randi([1+n,N],1,1); %���زο���1������
%         exp_noise(InterPos) = log(u(2)) * (-lambda); 
%         cfar = exp_target / min(sum(exp_noise(1:N/2)),sum(exp_noise(N/2+1:N)));
%         if cfar > T
%             detect_num = detect_num + 1;
%         end
%     end
%     Pd_SO1(i) = detect_num / monte_num;
% end
% plot(SNR_dB,Pd_SO1,'bo-','LineWidth',1.5);
% hold on;
% 
% Pd_SO2 = 0;
% for i = 1:Lth
%     detect_num = 0; %���ü���ź���Ŀ����
%     for j = 1:monte_num
%         lambda = 1;
%         u = rand(1,N);
%         exp_noise = log(u) * (-lambda);
%         lambda = SNR(i) + 1;
%         u = rand(1,5);
%         exp_target = log(u(1)) * (-lambda); %��Ҫ�ź�
%         InterPos1 = randi([1+n,N],1,2); %���زο���������������
%         InterPos2 = randi([1,n],1,2); %ǰ�زο���������������
%         exp_noise(InterPos1(1)) =  log(u(2)) * (-lambda); 
%         exp_noise(InterPos1(2)) =  log(u(3)) * (-lambda); 
%         exp_noise(InterPos2(1)) =  log(u(4)) * (-lambda); 
%         exp_noise(InterPos2(2)) =  log(u(5)) * (-lambda); 
%         cfar = exp_target / min(sum(exp_noise(1:N/2)),sum(exp_noise(N/2+1:N)));
%         if cfar > T
%             detect_num = detect_num + 1;
%         end
%     end
%     Pd_SO2(i) = detect_num / monte_num;
% end
% plot(SNR_dB,Pd_SO2,'rs-','LineWidth',1.5);
% hold on;
% 
% Pd_SO3 = 0;
% for i = 1:Lth
%     detect_num = 0; %���ü���ź���Ŀ����
%     for j = 1:monte_num
%         lambda = 1;
%         u = rand(1,N);
%         exp_noise = log(u) * (-lambda);
%         lambda = SNR(i) + 1;
%         u = rand(1,3);
%         exp_target = log(u(1)) * (-lambda); %��Ҫ�ź�
%         InterPos1 = randi([1,n],1,1); %ǰ�زο�������1������
%         InterPos2 = randi([n+1,N],1,1); %���زο�������1������
%         exp_noise(InterPos1) =  log(u(2)) * (-lambda); 
%         exp_noise(InterPos2) =  log(u(3)) * (-lambda); 
%         cfar = exp_target / min(sum(exp_noise(1:N/2)),sum(exp_noise(N/2+1:N)));
%         if cfar > T
%             detect_num = detect_num + 1;
%         end
%     end
%     Pd_SO3(i) = detect_num / monte_num;
% end
% plot(SNR_dB,Pd_SO3,'kd-','LineWidth',1.5);
% hold on; 

grid minor;
xlabel('\fontname{Times New Roman}SNR/dB');
ylabel('\fontname{����}������\fontname{Times New Roman}Pd');
title('\fontname{Times New Roman}r\fontname{����}������Ŀ�������\fontname{Times New Roman}SO-CAFR\fontname{����}������\fontname{Times New Roman}(N=36,Pfa=1e-6)');h = legend('r=2','r=5','r=10','Location','SouthEast','NumColumns',1);h = legend('r=(0,1)','r=(0,2)','r=(1,1)','Location','SouthEast','NumColumns',1);
h = legend('r=(0,1)','r=(0,2)','r=(1,1)','Location','SouthEast','NumColumns',1);
% h = legend('r=(0,1)','r=(2,2)','r=(1,1)','Location','SouthEast','NumColumns',1);
set(h,'edgecolor','none');