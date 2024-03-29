clc;clear all;close all;
% 本程序主要研究多目标情况下GO-CFAR关于信噪比的检测性能

%% 参数初始化
N = 36; %滑动窗长度
n = N / 2; %前后沿参考单元长度
Pfa = 1e-6; %虚警概率
SNR_dB = 5:1:35; %信噪比
SNR = 10 .^ (SNR_dB / 10);
Lth = length(SNR); %仿真信噪比区间长度
T = Pfa ^ (-1 / N) - 1; %门限因子
monte_num = 1e5;

%% 蒙特卡洛模拟1
% Pd_GO1 = 0;
% for i = 1:Lth
%     detect_num = 0; %设置检测信号数目变量
%     for j = 1:monte_num
%         lambda = 1;
%         u = rand(1,N);
%         exp_noise = log(u) * (-lambda);
%         lambda = SNR(i) + 1;
%         u = rand(1,2);
%         exp_target = log(u(1)) * (-lambda); %主要信号
%         InterPos = randi([1+n,N],1,1); %后沿参考窗1个干扰
%         exp_noise(InterPos) = log(u(2)) * (-lambda); 
%         cfar = exp_target / max(sum(exp_noise(1:N/2)),sum(exp_noise(N/2+1:N)));
%         if cfar > T
%             detect_num = detect_num + 1;
%         end
%     end
%     Pd_GO1(i) = detect_num / monte_num;
% end
% plot(SNR_dB,Pd_GO1,'bo-','LineWidth',1.5);
% hold on;
% 
% Pd_GO2 = 0;
% for i = 1:Lth
%     detect_num = 0; %设置检测信号数目变量
%     for j = 1:monte_num
%         lambda = 1;
%         u = rand(1,N);
%         exp_noise = log(u) * (-lambda);
%         lambda = SNR(i) + 1;
%         u = rand(1,3);
%         exp_target = log(u(1)) * (-lambda); %主要信号
%         InterPos = randi([1+n,N],1,2); %后沿参考窗产生两个干扰
%         exp_noise(InterPos(1)) =  log(u(2)) * (-lambda); 
%         exp_noise(InterPos(2)) =  log(u(3)) * (-lambda); 
%         cfar = exp_target / max(sum(exp_noise(1:N/2)),sum(exp_noise(N/2+1:N)));
%         if cfar > T
%             detect_num = detect_num + 1;
%         end
%     end
%     Pd_GO2(i) = detect_num / monte_num;
% end
% plot(SNR_dB,Pd_GO2,'rs-','LineWidth',1.5);
% hold on;
% 
% Pd_GO3 = 0;
% for i = 1:Lth
%     detect_num = 0; %设置检测信号数目变量
%     for j = 1:monte_num
%         lambda = 1;
%         u = rand(1,N);
%         exp_noise = log(u) * (-lambda);
%         lambda = SNR(i) + 1;
%         u = rand(1,3);
%         exp_target = log(u(1)) * (-lambda); %主要信号
%         InterPos1 = randi([1,n],1,1); %前沿参考窗产生1个干扰
%         InterPos2 = randi([n+1,N],1,1); %后沿参考窗产生1个干扰
%         exp_noise(InterPos1) =  log(u(2)) * (-lambda); 
%         exp_noise(InterPos2) =  log(u(3)) * (-lambda); 
%         cfar = exp_target / max(sum(exp_noise(1:N/2)),sum(exp_noise(N/2+1:N)));
%         if cfar > T
%             detect_num = detect_num + 1;
%         end
%     end
%     Pd_GO3(i) = detect_num / monte_num;
% end
% plot(SNR_dB,Pd_GO3,'kd-','LineWidth',1.5);
% hold on; 

% 蒙特卡洛模拟2
Pd_GO1 = 0;
for i = 1:Lth
    detect_num = 0; %设置检测信号数目变量
    for j = 1:monte_num
        lambda = 1;
        u = rand(1,N);
        exp_noise = log(u) * (-lambda);
        lambda = SNR(i) + 1;
        u = rand(1,2);
        exp_target = log(u(1)) * (-lambda); %主要信号
        InterPos = randi([1+n,N],1,1); %后沿参考窗1个干扰
        exp_noise(InterPos) = log(u(2)) * (-lambda); 
        cfar = exp_target / max(sum(exp_noise(1:N/2)),sum(exp_noise(N/2+1:N)));
        if cfar > T
            detect_num = detect_num + 1;
        end
    end
    Pd_GO1(i) = detect_num / monte_num;
end
plot(SNR_dB,Pd_GO1,'bo-','LineWidth',1.5);
hold on;

Pd_GO2 = 0;
for i = 1:Lth
    detect_num = 0; %设置检测信号数目变量
    for j = 1:monte_num
        lambda = 1;
        u = rand(1,N);
        exp_noise = log(u) * (-lambda);
        lambda = SNR(i) + 1;
        u = rand(1,5);
        exp_target = log(u(1)) * (-lambda); %主要信号
        InterPos1 = randi([1+n,N],1,2); %后沿参考窗产生两个干扰
        InterPos2 = randi([1,n],1,2); %前沿参考窗产生两个干扰
        exp_noise(InterPos1(1)) =  log(u(2)) * (-lambda); 
        exp_noise(InterPos1(2)) =  log(u(3)) * (-lambda);
        exp_noise(InterPos2(1)) =  log(u(4)) * (-lambda); 
        exp_noise(InterPos2(2)) =  log(u(5)) * (-lambda);
        cfar = exp_target / max(sum(exp_noise(1:N/2)),sum(exp_noise(N/2+1:N)));
        if cfar > T
            detect_num = detect_num + 1;
        end
    end
    Pd_GO2(i) = detect_num / monte_num;
end
plot(SNR_dB,Pd_GO2,'rs-','LineWidth',1.5);
hold on;

Pd_GO3 = 0;
for i = 1:Lth
    detect_num = 0; %设置检测信号数目变量
    for j = 1:monte_num
        lambda = 1;
        u = rand(1,N);
        exp_noise = log(u) * (-lambda);
        lambda = SNR(i) + 1;
        u = rand(1,3);
        exp_target = log(u(1)) * (-lambda); %主要信号
        InterPos1 = randi([1,n],1,1); %前沿参考窗产生1个干扰
        InterPos2 = randi([n+1,N],1,1); %前沿参考窗产生1个干扰
        exp_noise(InterPos1) =  log(u(2)) * (-lambda); 
        exp_noise(InterPos2) =  log(u(3)) * (-lambda); 
        cfar = exp_target / max(sum(exp_noise(1:N/2)),sum(exp_noise(N/2+1:N)));
        if cfar > T
            detect_num = detect_num + 1;
        end
    end
    Pd_GO3(i) = detect_num / monte_num;
end
plot(SNR_dB,Pd_GO3,'kd-','LineWidth',1.5);
hold on; 

%% 标注
grid minor;
xlabel('\fontname{Times New Roman}SNR/dB');
ylabel('\fontname{宋体}检测概率\fontname{Times New Roman}Pd');
title('\fontname{Times New Roman}r\fontname{宋体}个干扰目标情况下\fontname{Times New Roman}GO-CAFR\fontname{宋体}检测概率\fontname{Times New Roman}(N=36,Pfa=1e-6)');
h = legend('r=(0,1)','r=(2,2)','r=(1,1)','Location','SouthEast','NumColumns',1);
% h = legend('r=(0,1)','r=(0,2)','r=(1,1)','Location','SouthEast','NumColumns',1);
set(h,'edgecolor','none');