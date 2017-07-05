function[num,reminder]=change_times(maxdd,step,rmin,type)
% ����ӷ�ؽ�����ڸ��������س�Ŀ�����������������£�
% ��Ҫ���ֵĴ�����reminder Ϊ����
% type Ϊ������ȡ��ֵ�䶯��ʽ ���� �����ʱ䶯��ʽ
% ��� maxdd <= rmin�� �򷵻� 0 
if rmin > maxdd
    error('��ؽ������ڴ����س�֮ǰ');
end
if strcmp(type,'bynet')
    range = max(maxdd-rmin,0);
    num = floor(range/step);
    reminder = range - num*step;
elseif strcmp(type,'bypct')
    range = min((1-maxdd)/(1-rmin),1);
    num = floor(log(range)/log(1-step));
    reminder = 1-range/((1-step)^num);
end