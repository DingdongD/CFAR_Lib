%% ���ַ���ⷽ��
function result = binary_solution(scope,precision,func,parameter)
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
            difference = 1 / target - 1 / parameter(1,end); %���������ֵ���
            if abs(difference) < precision || abs(scope(1,1) - scope(1,2)) < 0.001 %�ж��Ƿ�ﵽ����Ҫ��
                return;
            elseif difference < 0 %δ�ﵽ����Ҫȥ��������
                scope(1,1) = result;
            else
                scope(1,2) = result;
            end
        end
    elseif shape(2)==3      %����OS_CFAR�������ӵļ���
        while 1
            result = mean(scope); %��������ֵ
            target = func(result,parameter(1,1),parameter(1,2)); %Ԥ��Pfa,����parameter����alpha,N,rate˳��
            difference = 1 / target- 1 / parameter(1,end); %���������ֵ���
            if abs(difference) < precision || abs(scope(1,1) - scope(1,2)) < 0.001 %�ж��Ƿ�ﵽ����Ҫ��
                return;
            elseif difference<0 %δ�ﵽ����Ҫȥ��������
                scope(1,1) = result;
            else
                scope(1,2) = result;
            end
        end
    elseif shape(2) == 4
        while 1
            result = mean(scope); %��������ֵ
            target = func(result,parameter(1,1),parameter(1,2),parameter(1,3)); %Ԥ��Pfa,����parameter����alpha,N,rate1,rate2˳��
            difference = 1 / target - 1 / parameter(1,end);
            if abs(difference) < precision || abs(scope(1,1) - scope(1,2)) < 0.001 %�ж��Ƿ�ﵽ����Ҫ��
                return;
            elseif difference < 0 %δ�ﵽ����Ҫȥ��������
                scope(1,1)  = result;
            else
                scope(1,2) = result;
            end
        end
    end
end