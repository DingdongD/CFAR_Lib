%% OS-CFAR���龯���ʼ���
function Pfa = OS_Pfa(alpha,N,rate)
    k = ceil(N .* rate);
    Pfa = gamma(N+1) .* gamma(N-k+alpha+1) ./ gamma(N-k+1) ./ gamma(N+alpha+1);
end
