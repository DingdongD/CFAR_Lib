%% GO-CFAR������Ӽ���
function [alpha] = go_threhold(Pfa,N)
    % Pfa:�龯����
    % N���ο���Ԫ��
    scope = [0,100]; %����
    precision = 0.01; %����
    func = @GO_Pfa;
    parameter = [N,Pfa];
    [alpha] = binary_solution(scope,precision,func,parameter);
end
