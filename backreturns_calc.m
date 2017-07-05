function[mktrets,addnet]=backreturns_calc(step,positions,netvals,type)
%�����㽫��λ�������������г�����
% ���� �� ��ǰ��λΪpositions(end) ��Ӧ�Ĳ�λ
%         ��ǰ��Ʒ��ֵΪnetvals(end)��Ӧ��
% ÿ����ֵ�ﵽ netval��ĳ��ֵ+step���ɽ���λ����һ��
% ����λ���ӵ���ߣ�positions(1)��ʱ��ֹͣ
if step<=0
   error('step �������0��') 
end
if strcmp(type,'bynet')
    tp = 1;
elseif strcmp(type,'bypct')
    tp = 2;
end
len = length(positions);
currnet = netvals(1);
mktrets = zeros(1,len);
addnet = zeros(1,len);
for dumi=1:len
    currpos = positions(dumi);
    if dumi==len
        targetnet = 1;
    else
        if tp==1
            targetnet = netvals(dumi)+step;
        elseif tp==2
            targetnet = netvals(dumi)*(1+step);
        end
    end
    mktrets(dumi) = (targetnet/currnet-1)/currpos;
    addnet(dumi) = targetnet;
    currnet = targetnet;
end