clc;clear;close all;
% ��������Ҫ�о���Ŀ������²�ͬCFAR�㷨��������ȵļ������

%% ������ʼ��
N = 64; %����������
n = N / 2; %ǰ���زο���Ԫ����
Pfa = [1e-6:2e-6:9e-6, 1e-5:2e-5:9e-5,1e-4:2e-4:9e-4,1e-3:2e-3:9e-3,1e-2:2e-2:9e-2,1e-1:2e-2:9e-2]; %�龯����
SNR_dB = 15; %�����
SNR = 10 .^ (SNR_dB / 10);
Lth = length(Pfa); %������������䳤��
monte_num = 1e5;
k = 3 * N / 4; %��������ѡ�����

T_CA = zeros(1, Lth);
T_GO = zeros(1, Lth);
T_SO = zeros(1, Lth);
T_OS = zeros(1, Lth);

for i = 1 : Lth
    T_CA(1,i) = Pfa(i) ^ (-1 / N) - 1; %��������
    T_GO(1,i) = Pfa(i) ^ (-1 / N) - 1; %��������
    T_SO(1,i) = Pfa(i) ^ (-1 / N) - 1; %��������

    syms T_os
    
    g = Pfa(i) - k * nchoosek(N,k) * gamma(k) * gamma(N-k+1+T_os) / gamma(N+T_os +1);
    x = solve(g);
    T_os = double(x);
    T_OS(1,i) = T_os(T_os  == abs(T_os));

end

% ���ؿ������
Pd_CA = zeros(1, Lth);
Pd_SO = zeros(1, Lth);
Pd_GO = zeros(1, Lth);
Pd_OS = zeros(1, Lth);

%% ��Ŀ�����
for i = 1:Lth
    detect_ca = 0; % ����CA����ź���Ŀ����
    detect_so = 0; % ����SO����ź���Ŀ����
    detect_go = 0; % ����GO����ź���Ŀ����
    detect_os = 0; % ����OS����ź���Ŀ����
    for j = 1:monte_num
        lambda = 1;
        u = rand(1,N-5);
        exp_noise = log(u) * (-lambda);
        lambda = SNR + 1;
        u = rand(1,6);  % 
        exp_target = log(u(1)) * (-lambda);  % Ŀ��
        
        exp_noise(N-4) = log(u(2)) * (-lambda);  % ����Ŀ��1
        exp_noise(N-3) = log(u(3)) * (-lambda);  % ����Ŀ��2
        exp_noise(N-2) = log(u(4)) * (-lambda);  % ����Ŀ��3
        exp_noise(N-1) = log(u(5)) * (-lambda);  % ����Ŀ��4
        exp_noise(N) = log(u(6)) * (-lambda);  % ����Ŀ��5
        
        cfar_ca = exp_target / sum(exp_noise);
        if cfar_ca > T_CA(i)
            detect_ca = detect_ca + 1;
        end
        
        cfar_go = exp_target / max(sum(exp_noise(1:N/2)),sum(exp_noise(N/2+1:N)));
        if cfar_go > T_GO(i)
            detect_go = detect_go + 1;
        end
        
        cfar_so = exp_target / min(sum(exp_noise(1:N/2)),sum(exp_noise(N/2+1:N)));
        if cfar_so > T_SO(i)
            detect_so = detect_so + 1;
        end
        
        exp_noise = sort(exp_noise);
        cfar_os = exp_target / exp_noise(k);
        if cfar_os > T_OS(i)
            detect_os = detect_os + 1;
        end  
        
    end
    Pd_CA(1,i) = detect_ca / monte_num;
    Pd_SO(1,i) = detect_so / monte_num;
    Pd_GO(1,i) = detect_go / monte_num;
    Pd_OS(1,i) = detect_os / monte_num;
end

% %% ��Ŀ�����
% for i = 1:Lth
%     detect_ca = 0; %����CA����ź���Ŀ����
%     detect_so = 0; %����SO����ź���Ŀ����
%     detect_go = 0; %����GO����ź���Ŀ����
%     detect_os = 0; %����OS����ź���Ŀ����
%     for j = 1:monte_num
%         lambda = 1;
%         u = rand(1,N);
%         exp_noise = log(u) * (-lambda);
%         lambda = SNR + 1;
%         u = rand(1,1);  % 
%         exp_target = log(u(1)) * (-lambda);  % Ŀ��
%         
%         cfar_ca = exp_target / sum(exp_noise);
%         if cfar_ca > T_CA(i)
%             detect_ca = detect_ca + 1;
%         end
%         
%         cfar_go = exp_target / max(sum(exp_noise(1:N/2)),sum(exp_noise(N/2+1:N)));
%         if cfar_go > T_GO(i)
%             detect_go = detect_go + 1;
%         end
%         
%         cfar_so = exp_target / min(sum(exp_noise(1:N/2)),sum(exp_noise(N/2+1:N)));
%         if cfar_so > T_SO(i)
%             detect_so = detect_so + 1;
%         end
%         
%         exp_noise = sort(exp_noise);
%         cfar_os = exp_target / exp_noise(k);
%         if cfar_os > T_OS(i)
%             detect_os = detect_os + 1;
%         end  
%         
%     end
%     Pd_CA(1,i) = detect_ca / monte_num;
%     Pd_SO(1,i) = detect_so / monte_num;
%     Pd_GO(1,i) = detect_go / monte_num;
%     Pd_OS(1,i) = detect_os / monte_num;
% end

semilogx(Pfa,Pd_CA,'rd-','LineWidth',1.5);hold on;   
semilogx(Pfa,Pd_GO,'g-*','LineWidth',1.5);hold on;   
semilogx(Pfa,Pd_SO,'b-.','LineWidth',1.5);hold on;   
semilogx(Pfa,Pd_OS,'k-x','LineWidth',1.5);hold on;   

grid minor;
xlabel('\fontname{����}�龯����');
ylabel('\fontname{����}������\fontname{Times New Roman}Pd');
h = legend('CA-CFAR','GO-CFAR','SO-CFAR','OS-CFAR','Location','SouthEast','NumColumns',1);
set(h,'edgecolor','none');




