function[meanret,volatility,maxdd,up_chgs,down_chgs]=positions_addback_byself(mu,sigma,delta,simtype,maxlen,netvals,positions,step,type,startlevel)
% ���г�������ΪBM������£������λ�ӻص�1�����ʱ��
% ����ڼ侻ֵ���³�����ع����������

totlevels = length(netvals);
curr_net_level = max(startlevel-1,1);
pre_netval = netvals(startlevel);
position = positions(curr_net_level);

if strcmp(type,'bynet')
    net_levels = netvals+step;
elseif strcmp(type,'bypct')
    net_levels = netvals*(1+step);
else
   error('Must specify the type of adding step'); 
end

timelen = 1;
%maxnet = pre_netval;
maxnet = 1;
netrets = zeros(maxlen,1);
drawdowns = zeros(maxlen,1);
mktrets = simrets_gen(mu,sigma,delta,simtype,[maxlen,1]);
up_chgs = 0;
down_chgs = 0;
while timelen<= maxlen
    mktret = mktrets(timelen);
    netret = position*mktret;
    netrets(timelen) = netret;
    netval = pre_netval*(1+netret);
    if netval > maxnet
        maxnet = netval;
    end
    drawdowns(timelen) = netval/maxnet-1;
    % ���ж��Ƿ񴥷����
    netpos = find(netval<=netvals);
    if ~isempty(netpos)
        netlevel = netpos(1)-1;
        if netlevel==0
            netlevel = 1;   % ����������س�Ҳֻ������ǰ����С��λ
        end
    else
        netlevel = totlevels;
    end
    if netlevel < curr_net_level   % �������µķ��,��Ҫ����
        curr_net_level = netlevel;
        down_chgs = down_chgs+1;
    else  % ���ж��Ƿ���Լӻز�λ
        % ȷ�ϵ�ǰ��λ�����ĵ�λ,�п���1����ǵ���ͻ�ƶ����λ
        upstep = find(netval>=net_levels);
        if ~isempty(upstep)
            uplevel = upstep(end);
        else
            uplevel = 1;
        end
        if uplevel > curr_net_level   % ��λ�ӻ�
            curr_net_level = uplevel;
            up_chgs = up_chgs+1;
        end
    end
    position = positions(curr_net_level);
    pre_netval = netval;
    timelen = timelen+1;
end
meanret = mean(netrets);
volatility = std(netrets);
maxdd = min(min(drawdowns),netvals(startlevel)-1);