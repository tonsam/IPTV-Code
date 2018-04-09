function [ UserFR,HotR,ColdR ] = getUserFR( rnnpara,useritr )
%������û�ÿ����ٻ���
    hotResult = rnnpara.hotResult(useritr,:);
    coldResult = rnnpara.coldResult(useritr,:);
    UserFR = [];HotR =[]; ColdR = []; 
    for day = rnnpara.startday : rnnpara.endday
        flag = 0;
        if (hotResult(day) == 404 && coldResult(day) == 404)
             UserFR = [UserFR,0];HotR =[HotR,0]; ColdR = [ColdR,0]; 
             continue;
        end
        
         %-----����ѵ�����ҳ���ѵ�������䡢��Ƶ���б�-------
        dataset = rnnpara.dataset(find(rnnpara.dataset(:,4:4)>=day&rnnpara.dataset(:,4:4)<day+rnnpara.windows),:);
        dataset = dataset(:,2:2); %ֻȡ��ǰƵ��һ��
        [ColdChannelList,HotChannelList,~] = ChannelPartition_rnn(dataset,rnnpara.channelFP);
        %-----ȡ�����Ե������ݼ����䡢��Ƶ���Ƽ�����-------
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
            %-----�����ٻ��ʣ��䡢��Ƶ���Ƽ���ȷ�ܴ��������ܼ�¼����-------
            UserFR = [UserFR,double( (Hottestlen*hotResult(day)+Coldtestlen*coldResult(day)) / size(dataset,1) )];
        else
            UserFR = [UserFR,0];
        end
    end
end

