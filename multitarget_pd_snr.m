%% ��������Ҫ�о���Ŀ������²�ͬCFAR�㷨��������ȵļ������
clc;clear;close all;

%% ������ʼ��
N = 64; %����������
n = N / 2; %ǰ���زο���Ԫ����
Pfa = 1e-6; %�龯����
SNR_dB = 1:1:35; %�����
SNR = 10 .^ (SNR_dB / 10);
Lth = length(SNR); %������������䳤��
monte_num = 1e4; % ���ؿ�����������ֵԽ��Խƽ��
rate = 3 / 4;
k = 3 * N / 4; % ����ѡ�����
tm_rate1 = 1 / 32;
tm_rate2 = 1 / 16;
cmld_rate = 1 / 4;

%% ����ϵ������
T_CA = ca_threhold(Pfa,N); %CA-CFAR��������
T_GO = go_threhold(Pfa,N); %GO-CFAR��������
T_SO = so_threhold(Pfa,N); %SO-CFAR��������
T_OS = os_threhold(Pfa,N,rate); % OS-CFAR ����������
T_TM = tm_threhold(Pfa,N,tm_rate1,tm_rate2); % TM-CFAR����������
T_CMLD = cmld_threhold(Pfa,N,cmld_rate); % CMLD-CFAR����������

% �����ʾ���
Pd_CA = zeros(1, Lth);
Pd_SO = zeros(1, Lth);
Pd_GO = zeros(1, Lth);
Pd_OS = zeros(1, Lth);
Pd_TM = zeros(1, Lth);
Pd_CMLD = zeros(1, Lth);

%% ��Ŀ����򣨴˴�������3��Ŀ�꣬�ɸ����Լ�������ģ�
for i = 1:Lth
    detect_ca = 0; %����CA����ź���Ŀ����
    detect_so = 0; %����SO����ź���Ŀ����
    detect_go = 0; %����GO����ź���Ŀ����
    detect_os = 0; %����OS����ź���Ŀ����
    detect_tm = 0; %����TM����ź���Ŀ����
    detect_cmld = 0; %����CMLD����ź���Ŀ����
    for j = 1:monte_num
        lambda = 1;
        u = rand(1,N);
        exp_noise = log(u) * (-lambda);
        lambda = SNR(i) + 1;
        u = rand(1,3);  % ����Ŀ��
        exp_target = log(u(1)) * (-lambda);  % Ŀ��
        
% ע�� �˴����Ը�������ѡ����ŵ�λ�÷������� �� ���Ƹ��ŵ���Ŀ ʹ��ʱע�͵���������
%=================================================================================
        InterPos = randi([1+n,N],1,2); %���زο���������������
        exp_noise(InterPos(1)) =  log(u(2)) * (-lambda); 
        exp_noise(InterPos(2)) =  log(u(3)) * (-lambda); 
%=================================================================================
%         InterPos = randi([1,n],1,2); %ǰ�زο���������������
%         exp_noise(InterPos(1)) =  log(u(2)) * (-lambda); 
%         exp_noise(InterPos(2)) =  log(u(3)) * (-lambda); 
%=================================================================================
%         InterPos1 = randi([1,n],1,1); %ǰ�زο�������1������
%         InterPos2 = randi([1+n,N],1,1); %���زο�������1������
%         exp_noise(InterPos(1)) =  log(u(2)) * (-lambda); 
%         exp_noise(InterPos(2)) =  log(u(3)) * (-lambda); 
%=================================================================================
        
        % ��ͬ������Ĺ���
        % CA-CFAR
        cfar_ca = exp_target / mean(exp_noise);
        if cfar_ca > T_CA
            detect_ca = detect_ca + 1;
        end
        
        % GO-CFAR
        cfar_go = exp_target / max(mean(exp_noise(1:N/2)),mean(exp_noise(N/2+1:N)));
        if cfar_go > T_GO
            detect_go = detect_go + 1;
        end
        
        % SO-CFAR
        cfar_so = exp_target / min(mean(exp_noise(1:N/2)),mean(exp_noise(N/2+1:N)));
        if cfar_so > T_SO
            detect_so = detect_so + 1;
        end
        
        % OS-CFAR
        os_noise = sort(exp_noise);
        cfar_os = exp_target / os_noise(k);
        if cfar_os > T_OS
            detect_os = detect_os + 1;
        end  
        
        % TM-CFAR
        tm_noise = sort(exp_noise);
        tm_noise(1:N*tm_rate1) = [];
        tm_noise(end+1-N*tm_rate2:end) = [];
        cfar_tm = exp_target / mean(tm_noise);
        if cfar_tm > T_TM
            detect_tm = detect_tm + 1;
        end
        
        % CMLD-CFAR
         cmld_noise = sort(exp_noise);
         cmld_noise(end-cmld_rate*N+1:end) = [];
         cfar_cmld = exp_target / mean(cmld_noise);
         if cfar_cmld > T_CMLD
            detect_cmld = detect_cmld + 1;
        end
        
        
    end
    Pd_CA(1,i) = detect_ca / monte_num;
    Pd_SO(1,i) = detect_so / monte_num;
    Pd_GO(1,i) = detect_go / monte_num;
    Pd_OS(1,i) = detect_os / monte_num;
    Pd_TM(1,i) = detect_tm / monte_num;
    Pd_CMLD(1,i) = detect_cmld / monte_num;
end

plot(SNR_dB,Pd_CA,'Color','#FFD700','LineWidth',2,'Marker','<');hold on;   
plot(SNR_dB,Pd_GO,'Color','#DC143C','LineWidth',2,'Marker','+');hold on;   
plot(SNR_dB,Pd_SO,'Color','#FF1493','LineWidth',2,'Marker','*');hold on;   
plot(SNR_dB,Pd_OS,'Color','#8B008B','LineWidth',2,'Marker','v');hold on;   
plot(SNR_dB,Pd_TM,'Color','#483D8B','LineWidth',2,'Marker','^');hold on;   
plot(SNR_dB,Pd_CMLD,'Color','#0000FF','LineWidth',2,'Marker','o');hold on;   

grid minor;
xlabel('\fontname{Times New Roman}SNR/dB');
ylabel('\fontname{����}������\fontname{Times New Roman}Pd');
h = legend('CA-CFAR','GO-CFAR','SO-CFAR','OS-CFAR','TM-CFAR','CMLD-CFAR','Location','SouthEast','NumColumns',1);
set(h,'edgecolor','none');




