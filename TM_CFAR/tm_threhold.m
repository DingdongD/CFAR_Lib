%% TM-CFAR������Ӽ���
function alpha = tm_threhold(Pfa,N,rate1,rate2)
    % Pfa:�龯����
    % N���ο���Ԫ��
    scope = [0,100]; %����
    precision = 0.01; %����
    func = @TM_Pfa;
    parameter = [N,rate1,rate2,Pfa];
    alpha = binary_solution(scope,precision,func,parameter);
end