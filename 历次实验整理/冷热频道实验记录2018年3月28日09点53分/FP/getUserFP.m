function [ UserFP ] = getUserFP( rnnpara,useritr )
%计算该用户每天的加权查准率
    hotResult = rnnpara.hotResult(useritr,:);
    coldResult = rnnpara.coldResult(useritr,:);
    UserFP = [];
    for day = rnnpara.startday : rnnpara.endday
        if (hotResult(day) == 404 || coldResult(day) == 404)
            UserFP = [UserFP,404];
        else
            %-----根据训练集找出已训练过的冷、热频道列表-------
            dataset = rnnpara.dataset(find(rnnpara.dataset(:,4:4)>=day&rnnpara.dataset(:,4:4)<day+rnnpara.windows),:);
            dataset = dataset(:,2:2); %只取当前频道一列
            [ColdChannelList,HotChannelList,~] = ChannelPartition_rnn(dataset,rnnpara.channelFP);
            %-----取出测试当天数据计算冷、热频道推荐次数-------
            dataset = rnnpara.dataset(find(rnnpara.dataset(:,4:4)==day+rnnpara.windows),:);
            dataset = dataset(:,2:2);
            Colddataset = size(getChannelRecord_rnn(dataset,ColdChannelList),1) - rnnpara.seqlength + 1;
            Hotdataset = size(getChannelRecord_rnn(dataset,HotChannelList),1) - rnnpara.seqlength + 1;
            %-----计算冷、热频道推荐次数占比及加权查全率-------
            hotPercent = Hotdataset/(Hotdataset + Colddataset);
            coldPercent = 1 - hotPercent;
            UserFP = [UserFP,double(hotResult(day)*hotPercent+coldResult(day)*coldPercent)];
        end
    end
end

