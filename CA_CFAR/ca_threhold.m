%% CA-CFAR������Ӽ���
function alpha = ca_threhold(Pfa,N)
    % Pfa:�龯����
    % N���ο���Ԫ��
    alpha = N .* (Pfa .^ (-1 / N) - 1 );
end
