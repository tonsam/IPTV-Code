function [ UserFP ] = getUserFP( rnnpara,useritr )
%������û�ÿ��ļ�Ȩ��׼��
    hotResult = rnnpara.hotResult(useritr,:);
    coldResult = rnnpara.coldResult(useritr,:);
    UserFP = [];
    for day = rnnpara.startday : rnnpara.endday
        if (hotResult(day) == 404 || coldResult(day) == 404)
            UserFP = [UserFP,404];
        else
            %-----����ѵ�����ҳ���ѵ�������䡢��Ƶ���б�-------
            dataset = rnnpara.dataset(find(rnnpara.dataset(:,4:4)>=day&rnnpara.dataset(:,4:4)<day+rnnpara.windows),:);
            dataset = dataset(:,2:2); %ֻȡ��ǰƵ��һ��
            [ColdChannelList,HotChannelList,~] = ChannelPartition_rnn(dataset,rnnpara.channelFP);
            %-----ȡ�����Ե������ݼ����䡢��Ƶ���Ƽ�����-------
            dataset = rnnpara.dataset(find(rnnpara.dataset(:,4:4)==day+rnnpara.windows),:);
            dataset = dataset(:,2:2);
            Colddataset = size(getChannelRecord_rnn(dataset,ColdChannelList),1) - rnnpara.seqlength + 1;
            Hotdataset = size(getChannelRecord_rnn(dataset,HotChannelList),1) - rnnpara.seqlength + 1;
            %-----�����䡢��Ƶ���Ƽ�����ռ�ȼ���Ȩ��ȫ��-------
            hotPercent = Hotdataset/(Hotdataset + Colddataset);
            coldPercent = 1 - hotPercent;
            UserFP = [UserFP,double(hotResult(day)*hotPercent+coldResult(day)*coldPercent)];
        end
    end
end

