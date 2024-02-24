%% OS-CFAR���龯�ʼ���㷨�ĺ���ʵ��
function result = func_cfar_os(x,alpha,NSlide,Pro_cell,rate)
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
    persistent K;
    
    if isempty(left)
        left = 1 + Half_Pro_cell + Half_Slide; %������߽�
        right = length(x) - Half_Pro_cell - Half_Slide; %�����ұ߽�
        Half_Slide = NSlide / 2; %�뻬����
        Half_Pro_cell = Pro_cell / 2; %һ�ౣ����Ԫ����
        len = length(x); %�Ӳ���Ԫ
        K = round(rate * NSlide); %�������
    end
    T = zeros(1,len); %�����ֵ
    target = [];
    
    for i = 1:left - 1 %��߽�
        cell_right = x(1,i + Half_Pro_cell + 1 : i + Half_Slide * 2 + Half_Pro_cell); 
        cell_right = sort(cell_right);
        T(1,i) = cell_right(K) * alpha;
        if T(1,i) < x(i)
            target = [target, i]; %����Ŀ��
        end
    end
    
    for i = left:right %�м�����
        cell_left = x(1,i - Half_Slide - Half_Pro_cell:i - Half_Pro_cell - 1);
        cell_right = x(1,i + Half_Pro_cell + 1 : i + Half_Pro_cell + Half_Slide);
        cell = sort([cell_left,cell_right]); %�ϲ����Ҳ໬����
        T(1,i) = cell(K) * alpha; %�������
        if T(1,i) < x(i)
            target = [target, i]; %����Ŀ��
        end
    end
    
    for i = right + 1:len %�ұ߽�
        cell_left = x(1,i - Half_Pro_cell - Half_Slide * 2 : i-Half_Pro_cell-1); 
        cell_left = sort(cell_left);
        T(1,i) = cell_left(K) * alpha;
        if T(1,i) < x(i)
            target = [target, i]; %����Ŀ��
        end
    end
    
    result = {'CFAR_OS',T,target}; %�����ֵ�����
end