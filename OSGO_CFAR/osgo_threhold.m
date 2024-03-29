%% OSGO-CFAR标称因子计算
function alpha = osgo_threhold(Pfa,N,rate)
    % Pfa:虚警概率
    % N：参考单元数
    scope = [0,100]; %区间
    precision = 0.01; %精度
    func = @OSGO_Pfa;
    parameter = [N,rate,Pfa];
    alpha = binary_solution(scope,precision,func,parameter);
end