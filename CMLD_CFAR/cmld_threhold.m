%% CMLD-CFAR������Ӽ���
function alpha = cmld_threhold(Pfa,N,rate)
    % Pfa:�龯����
    % N���ο���Ԫ��
    scope = [0,100]; %����
    precision = 0.01; %����
    func = @CMLD_Pfa;
    parameter = [N,rate,Pfa];
    alpha = binary_solution(scope,precision,func,parameter);
end