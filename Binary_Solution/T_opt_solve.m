%% ���ۼ����ֵ�ļ���:��֪��ز����������T
function T_opt = T_opt_solve(Pfa,lambda,dB,Range)
    %Pfa:�龯����
    %lambda:ָ���ֲ�����
    %dB:��������
    %Range:���뵥Ԫ��Χ
    %T_opt:���ۼ����ֵ
    scope = [0,100]; %�������
    precision = 0.0001; %��������
    func = @cdf_exponential; %ָ���ֲ�
    parameter = [lambda,Pfa];
    x = binary_solution_v1(scope,precision,func,parameter); %���������
    T_opt = ones(1,Range(1,end)) .* x;
    
    P = form_Power_DB2P(dB); %������db��ʽתΪP
    for i = 2:length(Range)
        T_opt(1,Range(1,i-1) + 1:Range(1,i)) = T_opt(1,Range(1,i-1) + 1:Range(1,i)) .* P(1,i-1); 
    end
    T_opt(1,1) = x .* P(1,1); 
end