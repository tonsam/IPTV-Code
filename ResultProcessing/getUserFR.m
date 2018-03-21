function [ UserFR ] = getUserFR( rnnpara,useritr )
%计算该用户每天的召回率
    hotResult = rnnpara.hotResult(useritr,:);
    coldResult = rnnpara.coldResult(useritr,:);
    UserFR = [];
    for day = rnnpara.startday : rnnpara.endday
        if (hotResult(day) == 404 || coldResult(day) == 404)
            UserFR = [UserFR,0];
        else
            %-----根据训练集找出已训练过的冷、热频道列表-------
            dataset = rnnpara.dataset(find(rnnpara.dataset(:,4:4)>=day&rnnpara.dataset(:,4:4)<day+rnnpara.windows),:);
            dataset = dataset(:,2:2); %只取当前频道一列
            [ColdChannelList,HotChannelList,~] = ChannelPartition_rnn(dataset,rnnpara.channelFP);
            %-----取出测试当天数据计算冷、热频道推荐次数-------
            dataset = rnnpara.dataset(find(rnnpara.dataset(:,4:4)==day+rnnpara.windows),:);
            dataset = dataset(:,2:2);
            Colddataset = getChannelRecord_rnn(dataset,ColdChannelList) - rnnpara.seqlength + 1;
            Hotdataset = getChannelRecord_rnn(dataset,HotChannelList) - rnnpara.seqlength + 1;
            %-----计算召回率：冷、热频道推荐正确总次数除以总记录条数-------
            UserFR = [UserFR,double( (size(Hotdataset,1)*hotResult(day)+size(Colddataset,1)*coldResult(day))  / size(dataset,1) )];
        end
    end
end

