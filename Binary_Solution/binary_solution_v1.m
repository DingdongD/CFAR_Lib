%% ���ַ���ⷽ��:��������������
function [result] = binary_solution_v1(scope,precision,func,parameter)
    % result:�������
    % target��Ŀ����ֵ
    % scope��Ŀ���ʼ����[Сֵ����ֵ]
    % precision�� Ŀ����ֵ����
    % func����ⷽ��
    % parameter����ز���,��alpha��target
    
    shape = size(parameter); 
    if shape(2) == 2 %����һ����������ʱ
        while 1
            result = mean(scope); %��������ֵ
            target = func(result,parameter(1,1)); %Ԥ��Pfa
            difference = 1 / (1 - target) - 1 / (1 - parameter(1,end)); %���������ֵ���
            if abs(difference) < precision || abs(scope(1,1) - scope(1,2)) < 0.001 %�ж��Ƿ�ﵽ����Ҫ��
                return;
            elseif target < 1 - parameter(1,end) %δ�ﵽ����Ҫȥ��������
                scope(1,1) = result;
            else
                scope(1,2) = result;
            end
        end
    elseif shape(2)==3      %����OS_CFAR�������ӵļ���
        while 1
            result = mean(scope); %��������ֵ
            target = func(result,parameter(1,1),parameter(1,2)); %Ԥ��Pfa,����parameter����alpha,N,rate˳��
            difference = 1 / (1 - target) - 1 / (1 - parameter(1,end)); %���������ֵ���
            if abs(difference) < precision || abs(scope(1,1) - scope(1,2)) < 0.001 %�ж��Ƿ�ﵽ����Ҫ��
                return;
            elseif target < 1 - parameter(1,end) %δ�ﵽ����Ҫȥ��������
                scope(1,1) = result;
            else
                scope(1,2) = result;
            end
        end
    end
end