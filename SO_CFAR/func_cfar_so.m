%% SO-CFAR���龯�ʼ���㷨�ĺ���ʵ��
function result = func_cfar_so(x,alpha,NSlide,Pro_cell)
    %x:ԭʼ�Ӳ�����
    %alpha���������
    %Nslide����������С
    %Pro_cell:������Ԫ��С
    
    persistent left; 
    persistent right;
    persistent Half_Slide;
    persistent Half_Pro_cell;
    persistent len;
    
    if isempty(left)
        left = 1 + Half_Pro_cell + Half_Slide; %������߽�
        right = length(x) - Half_Pro_cell - Half_Slide; %�����ұ߽�
        Half_Slide = NSlide / 2; %�뻬����
        Half_Pro_cell = Pro_cell / 2; %һ�ౣ����Ԫ����
        len = length(x); %�Ӳ���Ԫ
    end
    T = zeros(1,len); %�����ֵ
%     target = java.util.LinkedList; %����Java������ʵ��Ŀ��Ĵ洢
    target = [];
    
    for i = 1:left - 1 %��߽�
        cell_right = x(1,i + Half_Pro_cell + 1 : i + Half_Slide * 2 + Half_Pro_cell); 
        T(1,i) = mean(cell_right) * alpha;
        if T(1,i) < x(i)
            target = [target, i]; %����Ŀ��
        end
    end
    
    for i = left:right %�м�����
        cell_left = x(1,i - Half_Slide - Half_Pro_cell:i - Half_Pro_cell - 1);
        cell_right = x(1,i + Half_Pro_cell + 1 : i + Half_Pro_cell + Half_Slide);
        T(1,i) = min(mean(cell_left),mean(cell_right)) * alpha; %�������
        if T(1,i) < x(i)
            target = [target, i]; %����Ŀ��
        end
    end
    
    for i = right + 1:len %�ұ߽�
        cell_left = x(1,i - Half_Pro_cell - Half_Slide * 2 : i-Half_Pro_cell-1); 
        T(1,i) = mean(cell_left) * alpha;
        if T(1,i) < x(i)
            target = [target, i]; %����Ŀ��
        end
    end
    
    result = {'CFAR_SO',T,target}; %�����ֵ�����
end