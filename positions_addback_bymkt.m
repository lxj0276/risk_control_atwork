function[meanret,volatility,maxdd,up_chgs,down_chgs]=positions_addback_bymkt(mu,sigma,delta,simtype,maxlen,netvals,positions,step,type,startlevel)
% ���г�������ΪBM������£������λ�ӻص�1�����ʱ��
% ����ڼ侻ֵ���³�����ع����������

totlevels = length(netvals);
curr_net_level = max(startlevel-1,1);
pre_netval = netvals(startlevel);
position = positions(curr_net_level);

timelen = 1;
%maxnet = pre_netval;
maxnet = 1;
netrets = zeros(maxlen,1);
drawdowns = zeros(maxlen,1);
mktrets = simrets_gen(mu,sigma,delta,simtype,[maxlen,1]);
mktnets = cumprod(1+mktrets);
mktmark = 1;
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
        mktmark = mktnets(timelen);   % ���ֺ�����г���ֵ��׼
        down_chgs = down_chgs+1;
    else  % ���ж��Ƿ���Լӻز�λ
        % ȷ�ϵ�ǰ��λ�����ĵ�λ,�п���1����ǵ���ͻ�ƶ����λ
        % �ϵ������г�����������Լ���һ��λ��� max(��һ��λ���г��Ƿ�ˮƽ)
        if strcmp(type,'bynet')
            mktchg = mktnets(timelen)-mktmark;
        elseif strcmp(type,'bypct')
            mktchg = mktnets(timelen)/mktmark - 1;
        else
            error('Must specify the type of adding step');
        end
        mktaddlevels = floor(mktchg/step);
        if mktaddlevels >0 && curr_net_level<totlevels  % �г�����(���ϴε���ʱ)�ﵽ�Ӳֱ�׼,��Ŀǰ������߲�λ���Ѵﵽ��߲�λ�Ͳ����ټ��ˣ�
            targetlevel = min(totlevels,curr_net_level+mktaddlevels);
            if netval > netvals(targetlevel)  % ��Ҫ��ֵ�ﵽ���ϣ�����������ּ��֣�
                curr_net_level = targetlevel;
                mktmark = mktnets(timelen);   % ���ֺ�����г���ֵ��׼
                up_chgs = up_chgs+1;
            end
        end
    end
    position = positions(curr_net_level);
    pre_netval = netval;
    timelen = timelen+1;
end
meanret = mean(netrets);
volatility = std(netrets);
maxdd = min(min(drawdowns),netvals(startlevel)-1);



