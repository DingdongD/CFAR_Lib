%% ICOS-CFAR���龯�ʼ���㷨�ĺ���ʵ��
function result = func_cfar_icos(x,Pfa,NSlide,Pro_cell,rate)
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
        alpha = os_threhold(Pfa,length(cell_right),rate); %��ʼalpha
        for time = 1:30 %IC�������´���
            cell_right = sort(cell_right);
            t = cell_right(ceil(rate*length(cell_right))) * alpha; %��ֵϵ����ȡ
            cell_right = cell_right(cell_right <= t);
            if os_threhold(Pfa,length(cell_right),rate) == alpha
                break; %���alpha ���������,˵����������
            else
                alpha = os_threhold(Pfa,length(cell_right),rate); %�������alpha
            end
        end
        T(1,i) = cell_right(ceil(rate*length(cell_right))) * alpha;
        if T(1,i) < x(i)
            target.add(i); %����Ŀ��
        end
    end
    
    for i = left:right %�м�����
        cell_left = x(1,i - Half_Slide - Half_Pro_cell:i - Half_Pro_cell - 1);
        cell_right = x(1,i + Half_Pro_cell + 1 : i + Half_Pro_cell + Half_Slide);
        cell = [cell_left,cell_right]; %�ϲ����ര
        alpha = os_threhold(Pfa,length(cell),rate); %��ʼalpha
        for time = 1:30 %IC�������´���
            cell = sort(cell);
            t = cell(ceil(rate*length(cell))) * alpha; %��ֵϵ����ȡ
            cell = cell(cell <= t);
            if os_threhold(Pfa,length(cell),rate) == alpha
                break; %���alpha ���������,˵����������
            else
                alpha = os_threhold(Pfa,length(cell),rate); %�������alpha
            end
        end
        T(1,i) = cell(ceil(rate*length(cell))) * alpha; %�������
        if T(1,i) < x(i)
            target.add(i); %����Ŀ��
        end
    end
    
    for i = right + 1:len %�ұ߽�
        cell_left = x(1,i - Half_Pro_cell - Half_Slide * 2 : i-Half_Pro_cell-1); 
        alpha = os_threhold(Pfa,length(cell_left),rate); %��ʼalpha
        for time = 1:30 %IC�������´���
            cell_left = sort(cell_left);
            t = cell_left(ceil(rate*length(cell_left))) * alpha; %��ֵϵ����ȡ
            cell_left = cell_left(cell_left <= t);
            if os_threhold(Pfa,length(cell_left),rate) == alpha
                break; %���alpha ���������,˵����������
            else
                alpha = os_threhold(Pfa,length(cell_left),rate); %�������alpha
            end
        end
        T(1,i) = cell_left(ceil(rate*length(cell_left))) * alpha;
        if T(1,i) < x(i)
            target.add(i);
        end
    end
    
    result = {'CFAR_ICOS',T,target}; %�����ֵ�����
end