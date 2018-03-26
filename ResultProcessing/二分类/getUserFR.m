function [ UserFR,HotR,ColdR ] = getUserFR( rnnpara,useritr )
%计算该用户每天的召回率
    hotResult = rnnpara.hotResult(useritr,:);
    coldResult = rnnpara.coldResult(useritr,:);
    UserFR = [];HotR =[]; ColdR = []; 
    for day = rnnpara.startday : rnnpara.endday
        flag = 0;
        if (hotResult(day) == 404 && coldResult(day) == 404)
             UserFR = [UserFR,0];HotR =[HotR,0]; ColdR = [ColdR,0]; 
             continue;
        end
        
         %-----根据训练集找出已训练过的冷、热频道列表-------
        dataset = rnnpara.dataset(find(rnnpara.dataset(:,4:4)>=day&rnnpara.dataset(:,4:4)<day+rnnpara.windows),:);
        dataset = dataset(:,2:2); %只取当前频道一列
        [ColdChannelList,HotChannelList,~] = ChannelPartition_rnn(dataset,rnnpara.channelFP);
        %-----取出测试当天数据计算冷、热频道推荐次数-------
        dataset = rnnpara.dataset(find(rnnpara.dataset(:,4:4)==day+rnnpara.windows),:);
        dataset = dataset(:,2:2);
        if (hotResult(day) ~= 404)
            flag = flag+1;
            Hotdatalen = size(getChannelRecord_rnn(dataset,HotChannelList),1);
            Hottestlen = Hotdatalen- rnnpara.seqlength + 1;
            HotR =[HotR,(Hottestlen*hotResult(day))/Hotdatalen];
        else
            HotR =[HotR,0];
        end
        
        if (coldResult(day) ~= 404)
            flag = flag+1;
            Colddatalen = size(getChannelRecord_rnn(dataset,ColdChannelList),1);
            Coldtestlen = Colddatalen- rnnpara.seqlength + 1;
            ColdR =[ColdR,(Coldtestlen*coldResult(day))/Colddatalen];
         else
            ColdR = [ColdR,0]; 
        end
           
        if(flag == 2)
            %-----计算召回率：冷、热频道推荐正确总次数除以总记录条数-------
            UserFR = [UserFR,double( (Hottestlen*hotResult(day)+Coldtestlen*coldResult(day)) / size(dataset,1) )];
        else
            UserFR = [UserFR,0];
        end
    end
end

