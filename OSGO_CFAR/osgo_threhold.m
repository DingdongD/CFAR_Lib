%% OSGO-CFAR������Ӽ���
function alpha = osgo_threhold(Pfa,N,rate)
    % Pfa:�龯����
    % N���ο���Ԫ��
    scope = [0,100]; %����
    precision = 0.01; %����
    func = @OSGO_Pfa;
    parameter = [N,rate,Pfa];
    alpha = binary_solution(scope,precision,func,parameter);
end