%%ָ���ֲ����ۻ��ֲ�����
function fc = cdf_exponential(x,lambda)
%      x:�Ӳ�����
% lambda:�Ӳ�����
fc = 1 - exp(-x ./ lambda);
end