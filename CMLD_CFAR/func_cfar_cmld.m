%% ��������Ҫʵ��CMLD-CFAR���龯�ʼ���㷨�ĺ�����ʽ
function result = func_cfar_cmld(x,alpha,NSlide,Pro_cell,rate)
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
    
    T = zeros(1,len); %CMLD�����ֵ
    target = [];

    for i = 1:left - 1 %��߽�
        cell_right = x(1,i + Half_Pro_cell + 1 : i + Half_Slide * 2 + Half_Pro_cell); 
        cell_right = sort(cell_right);
        cell_right(end-K+1:end) = []; %ɾ����K����Ԫ
        T(1,i) = mean(cell_right) * alpha; %CMLD CFAR������
        if T(1,i) < x(i)
            target = [target, i]; %����Ŀ��
        end
    end
    
    for i = left:right %�м�����
        cell_left = x(1,i - Half_Pro_cell - Half_Slide : i - Half_Pro_cell - 1);
        cell_right = x(1,i + Half_Pro_cell + 1 : i + Half_Pro_cell + Half_Slide);
        cell = [cell_left,cell_right];
        cell = sort(cell); %�Բο���Ԫ����
        cell(end-K+1:end) = []; %ɾ������ο��������ĵ�K����Ԫ
        T(1,i) = (mean(cell)) * alpha; %CMLD CFAR������
        if T(1,i) < x(i)
            target = [target, i]; %����Ŀ��
        end
    end
    
    for i = right + 1 : len
        cell_left = x(1,i - Half_Pro_cell - Half_Slide * 2 : i - Half_Pro_cell - 1); 
        cell_left = sort(cell_left);
        cell_left(end-K+1:end) = [];
        T(1,i) = mean(cell_left) * alpha; %CMLD CFAR������
        if T(1,i) < x(i) 
            target = [target, i]; %����Ŀ��
        end
    end
    
    result = {'CFAR_CMLD',T,target}; %�����ֵ�����
end
    
    