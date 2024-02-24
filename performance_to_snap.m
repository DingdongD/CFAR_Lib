%% ���ļ�����ģ�������̬�ֲ�����²�ͬ�����㷨��������֤
clc;clear;close;

radar_points = 1024; % �״�ز�����
fr = 1000; % �����ظ�Ƶ��
lambda = 0.05;%����
sigmav = 1.0;%�ٶȷ���
muc = 5; %�߶Ȳ���Ϊ10
sigmac = 0.6; %��״����


target_num = 6; % Ŀ����Ŀ

% target_idx = [128, 256, 384, 420, 512];

target_idx = [randsample(100:200,1),randsample(200:300,1), randsample(300:400,1), randsample(400:500,1), randsample(500:600,1), ...
    randsample(600:700,1), randsample(700:800,1), randsample(800:900,1)];


% target_idx = randperm(length(clutter_data)); 
target_idx = target_idx(1:target_num); % Ŀ������

target_test_window = 32; % Ŀ�깦�ʹ��ƵĲ��Ե�Ԫ
target_guard_window = 4; % Ŀ�깦�ʹ��Ƶı�����

% CFAR������������
Pfa = [1e-6:2e-6:9e-6, 1e-5:2e-5:9e-5,1e-4:2e-4:9e-4,1e-3:2e-3:9e-3,1e-2:2e-2:9e-2,1e-1:2e-2:9e-2]; %�龯����
NSlide = 64; % �ο���Ԫ��Ŀ
Pro_cell = 8; % ������Ԫ��Ŀ
rate = 3 / 4; % ����ѡ�����

% ���������
snr_db = 10; % ���������
snr = 10 .^ (snr_db / 10); % ����ת��
monte_num = 1e3; % ���ؿ���������

% �������ʼ��
Pd_CA = zeros(1, length(Pfa)); % CA-CFAR
Pd_SO = zeros(1, length(Pfa)); % SO-CFAR
Pd_GO = zeros(1, length(Pfa)); % GO-CFAR
Pd_OS = zeros(1, length(Pfa)); % OS-CFAR

tic
for pfa_id = 1 : length(Pfa)
    alpha_ca = ca_threhold(Pfa(pfa_id),NSlide); % CA����ϵ��
    alpha_so = so_threhold(Pfa(pfa_id),NSlide); % SO����ϵ��
    alpha_go = go_threhold(Pfa(pfa_id),NSlide); % GO����ϵ��
    alpha_os = os_threhold(Pfa(pfa_id),NSlide,rate); % OS����ϵ��
    ca_count = 0; % ��ʼ��CA-CFARͳ��ֵ
    so_count = 0; % ��ʼ��SO-CFARͳ��ֵ
    go_count = 0; % ��ʼ��GO-CFARͳ��ֵ
    os_count = 0; % ��ʼ��OS-CFARͳ��ֵ

    for monte_id = 1 : monte_num
        [clutter_data] = generate_lgclutter(radar_points, sigmav, muc, sigmac); % ÿ�����ģ�����ɶ�����̬�ֲ��Ӳ�
        
        for i = 1 : target_num % �����ض�snr�µĶ�Ŀ��
            window_left = target_idx(i) - target_guard_window / 2 - target_test_window / 2;
            window_right = target_idx(i) + target_guard_window / 2 + target_test_window / 2;
            clutter_power = (mean(clutter_data(1, [window_left : window_left + target_test_window / 2 - 1])) + ...
                mean(clutter_data(1, [window_right - target_test_window / 2 + 1 : window_right]))) / 2;
            clutter_data(target_idx(i)) = clutter_power * snr;
        end
        
        
        % CA-CFAR�㷨
        ca_result = func_cfar_ca(clutter_data,alpha_ca,NSlide,Pro_cell);
        ca_result = cell2mat(ca_result(3));
        ca_length = length(ca_result);
        
        % SO-CFAR�㷨
        so_result = func_cfar_so(clutter_data,alpha_so,NSlide,Pro_cell);
        so_result = cell2mat(so_result(3));
        so_length = length(so_result);
        
        % GO-CFAR�㷨
        go_result = func_cfar_go(clutter_data,alpha_go,NSlide,Pro_cell);
        go_result = cell2mat(go_result(3));
        go_length = length(go_result);
        
        % OS-CFAR�㷨
        os_result = func_cfar_os(clutter_data,alpha_os,NSlide,Pro_cell,rate);
        os_result = cell2mat(os_result(3));
        os_length = length(os_result);
        
        % ͳ�Ʋ�ͬ�㷨��Ŀ�������
        for tidx = 1 : target_num 
           for ca_idx = 1 : ca_length
               if ca_result(ca_idx) == target_idx(tidx)
                   ca_count = ca_count + 1;
                   break;
               end
           end
           
           for so_idx = 1 : so_length
               if so_result(so_idx) == target_idx(tidx)
                   so_count = so_count + 1;
                   break;
               end
           end
           
           for go_idx = 1 : go_length
               if go_result(go_idx) == target_idx(tidx)
                   go_count = go_count + 1;
                   break;
               end
           end
           
           for os_idx = 1 : os_length
               if os_result(os_idx) == target_idx(tidx)
                   os_count = os_count + 1;
                   break;
               end
           end
          
           
        end
    end
    
    % ͳ��ÿ��snr�µ�Ŀ�������
    Pd_CA(1, pfa_id) = ca_count / monte_num / target_num; 
    Pd_GO(1, pfa_id) = go_count / monte_num / target_num;
    Pd_SO(1, pfa_id) = so_count / monte_num / target_num;
    Pd_OS(1, pfa_id) = os_count / monte_num / target_num; 
end
toc

figure(1);
semilogx(Pfa, Pd_CA, 'Color','#FFD700','LineWidth',2.0,'Marker','d');hold on;
semilogx(Pfa, Pd_GO, 'Color','#483D8B','LineWidth',2.0,'Marker','+');hold on;
semilogx(Pfa, Pd_SO, 'Color','#FF1493','LineWidth',2.0,'Marker','*');hold on;
semilogx(Pfa, Pd_OS, 'Color','#8B008B','LineWidth',2.0,'Marker','s');hold on;
xlabel('\fontname{Times New Roman} False Alarm Rate');
ylabel('\fontname{Times New Roman} Pd');grid minor;
legend('CA-CFAR','GO-CFAR','SO-CFAR','OS-CFAR');
