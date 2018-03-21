function [ UserFR ] = getUserFR( rnnpara,useritr )
%������û�ÿ����ٻ���
    hotResult = rnnpara.hotResult(useritr,:);
    coldResult = rnnpara.coldResult(useritr,:);
    UserFR = [];
    for day = rnnpara.startday : rnnpara.endday
        if (hotResult(day) == 404 || coldResult(day) == 404)
            UserFR = [UserFR,0];
        else
            %-----����ѵ�����ҳ���ѵ�������䡢��Ƶ���б�-------
            dataset = rnnpara.dataset(find(rnnpara.dataset(:,4:4)>=day&rnnpara.dataset(:,4:4)<day+rnnpara.windows),:);
            dataset = dataset(:,2:2); %ֻȡ��ǰƵ��һ��
            [ColdChannelList,HotChannelList,~] = ChannelPartition_rnn(dataset,rnnpara.channelFP);
            %-----ȡ�����Ե������ݼ����䡢��Ƶ���Ƽ�����-------
            dataset = rnnpara.dataset(find(rnnpara.dataset(:,4:4)==day+rnnpara.windows),:);
            dataset = dataset(:,2:2);
            Colddataset = getChannelRecord_rnn(dataset,ColdChannelList) - rnnpara.seqlength + 1;
            Hotdataset = getChannelRecord_rnn(dataset,HotChannelList) - rnnpara.seqlength + 1;
            %-----�����ٻ��ʣ��䡢��Ƶ���Ƽ���ȷ�ܴ��������ܼ�¼����-------
            UserFR = [UserFR,double( (size(Hotdataset,1)*hotResult(day)+size(Colddataset,1)*coldResult(day))  / size(dataset,1) )];
        end
    end
end

