function [SLRecall,anss  ] = getSL_Recall(resultPath,inputFile)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��ȡ���ѵ�������Խ�����ٻ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��Ҫѡȡrt����
temp = load(resultPath);
rnnpara.Result = temp.recomm5.rt1 ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rnnpara.channelFP = 4; %Ƶ������Ƶ�ʰٷֱ�,����ȡ������޹�
rnnpara.windows= 7;    %ѡ���ѵ������
rnnpara.startday = 1;   %��һ��ѵ��������ʼ���ڣ���һ��ѵ��Ϊ1~window�ţ�window+1����Ϊ��һ�β�������
rnnpara.endday = 31 - rnnpara.windows;   %���һ��ѵ��������ʼ���ڣ�w=7����Ϊ24��31����Ϊ���һ�β�������
rnnpara.seqlength = 5; %rnn�����г���
rnnpara.inputfiledata = load(inputFile);  %ѵ��ʱ����������
userN = 50; %��Ҫ������û�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SLRecall = zeros(userN,rnnpara.endday); %Ԥ�����ڴ�

for useritr = 1:userN
    rnnpara.dataset = rnnpara.inputfiledata(find(rnnpara.inputfiledata(:,1:1)==useritr),:);
    
    Result = rnnpara.Result(useritr,:);
    UserFR = [];
    for day = rnnpara.startday : rnnpara.endday
        if (Result(day) == 404 )
            UserFR = [UserFR,0];
        else
            %-----����ѵ�����ҳ���ѵ������Ƶ���б�-------
            dataset = rnnpara.dataset(find(rnnpara.dataset(:,4:4)>=day&rnnpara.dataset(:,4:4)<day+rnnpara.windows),:);
            dataset = dataset(:,2:2); %ֻȡ��ǰƵ��һ��
            [~,~,TestChannelList] = ChannelPartition_rnn(dataset,rnnpara.channelFP);
            %-----ȡ�����Ե������ݼ���Ƶ���������Ƽ�����-------
            Alldataset = rnnpara.dataset(find(rnnpara.dataset(:,4:4)==day+rnnpara.windows),:);
            Alldataset = Alldataset(:,2:2);
            Testdataset = getChannelRecord_rnn(Alldataset,TestChannelList) - rnnpara.seqlength + 1;
            %-----�����ٻ��ʣ��Ƽ���ȷ�ܴ��������ܼ�¼����-------
            UserFR = [UserFR,double( size(Testdataset,1)*Result(day) / size(Alldataset,1) )];
        end
    end
    SLRecall(useritr,:) = SLRecall(useritr,:) + UserFR;
end
anssum = 0;
for useritr = 1:userN
    sum = 0;
    i = 1;
    for day = rnnpara.startday:rnnpara.endday
        sum = sum + SLRecall(useritr,day);
        i =i+1;
    end
    anssum = anssum + sum /i;
    
end
anss = anssum / userN;
end

