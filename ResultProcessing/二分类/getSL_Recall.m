function [SLRecall,anss  ] = getSL_Recall(resultPath,inputFile)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%获取混合训练、测试结果的召回率
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%需要选取rt矩阵
temp = load(resultPath);
rnnpara.Result = temp.recomm5.rt1 ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rnnpara.channelFP = 4; %频道划分频率百分比,任意取，与此无关
rnnpara.windows= 7;    %选择的训练窗口
rnnpara.startday = 1;   %第一个训练窗口起始日期，第一次训练为1~window号，window+1号作为第一次测试日期
rnnpara.endday = 31 - rnnpara.windows;   %最后一个训练窗口起始日期，w=7，则为24，31号作为最后一次测试日期
rnnpara.seqlength = 5; %rnn的序列长度
rnnpara.inputfiledata = load(inputFile);  %训练时总输入数据
userN = 50; %需要计算的用户数量
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SLRecall = zeros(userN,rnnpara.endday); %预分配内存

for useritr = 1:userN
    rnnpara.dataset = rnnpara.inputfiledata(find(rnnpara.inputfiledata(:,1:1)==useritr),:);
    
    Result = rnnpara.Result(useritr,:);
    UserFR = [];
    for day = rnnpara.startday : rnnpara.endday
        if (Result(day) == 404 )
            UserFR = [UserFR,0];
        else
            %-----根据训练集找出已训练过的频道列表-------
            dataset = rnnpara.dataset(find(rnnpara.dataset(:,4:4)>=day&rnnpara.dataset(:,4:4)<day+rnnpara.windows),:);
            dataset = dataset(:,2:2); %只取当前频道一列
            [~,~,TestChannelList] = ChannelPartition_rnn(dataset,rnnpara.channelFP);
            %-----取出测试当天数据计算频道例表中推荐次数-------
            Alldataset = rnnpara.dataset(find(rnnpara.dataset(:,4:4)==day+rnnpara.windows),:);
            Alldataset = Alldataset(:,2:2);
            Testdataset = getChannelRecord_rnn(Alldataset,TestChannelList) - rnnpara.seqlength + 1;
            %-----计算召回率：推荐正确总次数除以总记录条数-------
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

