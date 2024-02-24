%% ICCA-CFAR���龯�ʼ���㷨�ĺ���ʵ��
function result = func_cfar_icca(x,Pfa,NSlide,Pro_cell)
    %x:ԭʼ�Ӳ�����
    %alpha���������
    %Nslide����������С
    %Pro_cell:������Ԫ��С
    %rate:���������OS��ѡ�������k=3/4Nʱrate=0.75
    
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
    target = java.util.LinkedList; %����Java������ʵ��Ŀ��Ĵ洢
    
    for i = 1:left - 1 %��߽�
        cell_right = x(1,i + Half_Pro_cell + 1 : i + Half_Slide * 2 + Half_Pro_cell); 
        alpha = 1 - Pfa^(1 / (NSlide-1)); %��ʼalpha0
        for time = 1:30 %IC�������´���
            t = sum(cell_right) * alpha;%��ֵϵ����ȡ
            cell_right = cell_right(cell_right <= t);
            if 1 - Pfa^(1 / (length(cell_right)-1)) == alpha
                break; %���alpha ���������,˵����������
            else
                alpha = 1 - Pfa^(1 / (length(cell_right)-1)); %�������alpha
            end
        end
        T(1,i) = sum(cell_right) * alpha;
        if T(1,i) < x(i)
            target.add(i); %����Ŀ��
        end
    end
    
    for i = left:right %�м�����
        cell_left = x(1,i - Half_Slide - Half_Pro_cell:i - Half_Pro_cell - 1);
        cell_right = x(1,i + Half_Pro_cell + 1 : i + Half_Pro_cell + Half_Slide);
        cell = [cell_left,cell_right]; %�ϲ����ര
        alpha = 1 - Pfa^(1 / (NSlide-1)); %��ʼalpha0
        for time = 1:30 %IC�������´���
            t = sum(cell) * alpha;%��ֵϵ����ȡ
            cell = cell(cell <= t);
            if 1 - Pfa^(1 / (length(cell)-1)) == alpha
                break; %���alpha ���������,˵����������
            else
                alpha = 1 - Pfa^(1 / (length(cell)-1)); %�������alpha
            end
        end
        T(1,i) = sum(cell) * alpha; %�������
        if T(1,i) < x(i)
            target.add(i); %����Ŀ��
        end
    end
    
    for i = right + 1:len %�ұ߽�
        cell_left = x(1,i - Half_Pro_cell - Half_Slide * 2 : i-Half_Pro_cell-1); 
        alpha = 1 - Pfa^(1 / (NSlide-1)); %��ʼalpha0
        for time = 1:30 %IC�������´���
            t = sum(cell_left) * alpha;%��ֵϵ����ȡ
            cell_left = cell_left(cell_left <= t);
            if 1 - Pfa^(1 / (length(cell_left)-1)) == alpha
                break; %���alpha ���������,˵����������
            else
                alpha = 1 - Pfa^(1 / (length(cell_left)-1)); %�������alpha
            end
        end
        T(1,i) = sum(cell_left) * alpha;
        if T(1,i) < x(i)
            target.add(i);
        end
    end
    
    result = {'CFAR_ICCA',T,target}; %�����ֵ�����
end