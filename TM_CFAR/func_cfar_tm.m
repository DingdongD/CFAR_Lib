%% ��������Ҫʵ��TM-CFAR���龯�ʼ���㷨�ĺ�����ʽ
function result = func_cfar_tm(x,alpha,NSlide,Pro_cell,rate1,rate2)
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
    persistent K1;
    persistent K2;
    
    if isempty(left)
        left = 1 + Half_Pro_cell + Half_Slide; %������߽�
        right = length(x) - Half_Pro_cell - Half_Slide; %�����ұ߽�
        Half_Slide = NSlide / 2; %�뻬����
        Half_Pro_cell = Pro_cell / 2; %һ�ౣ����Ԫ����
        len = length(x); %�Ӳ���Ԫ
        K1 = round(rate1 * NSlide); %�������
        K2 = round(rate2 * NSlide); %�������
    end
    
    T = zeros(1,len); %CMLD�����ֵ
    target = java.util.LinkedList; %����Java������ʵ��Ŀ��Ĵ洢

    for i = 1:left - 1 %��߽�
        cell_right = x(1,i + Half_Pro_cell + 1 : i + Half_Slide * 2 + Half_Pro_cell); 
        cell_right = sort(cell_right);
        cell_right(1:K1) = [];
        cell_right(end-K2+1:end) = [];
        T(1,i) = mean(cell_right) * alpha; %TM CFAR������
        if T(1,i) < x(i)
            target.add(i); %����Ŀ��
        end
    end
    
    for i = left:right %�м�����
        cell_left = x(1,i - Half_Pro_cell - Half_Slide : i - Half_Pro_cell - 1);
        cell_right = x(1,i + Half_Pro_cell + 1 : i + Half_Pro_cell + Half_Slide);
        cell = [cell_left,cell_right];
        cell = sort(cell);
        cell(1:K1) = [];
        cell(end+1-K2:end) = [];
        T(1,i) = mean(cell) * alpha; %TM CFAR������
        if T(1,i) < x(i)
            target.add(i); %����Ŀ��
        end
    end
    
    for i = right + 1 : len
        cell_left = x(1,i - Half_Pro_cell - Half_Slide * 2 : i - Half_Pro_cell - 1); 
        cell_left = sort(cell_left);
        cell_left(1:K1) = [];
        cell_left(end-K2+1:end) = [];
        T(1,i) = mean(cell_left) * alpha; %TM CFAR������
        if T(1,i) < x(i) 
            target.add(i);
        end
    end
    
    result = {'CFAR_TM',T,target}; %�����ֵ�����
end
    
    