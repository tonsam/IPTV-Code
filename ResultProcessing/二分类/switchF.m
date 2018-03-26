function [ anss,A,B] = switchF()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rnnpara.channelFP = 4; %频道划分频率百分比,任意取，与此无关
rnnpara.windows= 7;    %选择的训练窗口
rnnpara.startday = 1;   %第一个训练窗口起始日期，第一次训练为1~window号，window+1号作为第一次测试日期
rnnpara.endday = 31 - rnnpara.windows;   %最后一个训练窗口起始日期，w=7，则为24，31号作为最后一次测试日期
rnnpara.seqlength = 5; %rnn的序列长度
inputFile = 'C:\Work\IPTV\IPTV Recommendation\dataset\Trainingset3000WithDuration[10-3600].txt';
rnnpara.inputfiledata = load(inputFile);  %训练时总输入数据
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A = [];
B =[];
for U = 1:50
    valid = 0;    anss = 0;
    rnnpara.dataset = rnnpara.inputfiledata(find(rnnpara.inputfiledata(:,1:1)==U),:);
    for day = rnnpara.startday : rnnpara.endday
        flag = 0;
        %-----根据训练集找出已训练过的频道列表-------
        dataset = rnnpara.dataset(find(rnnpara.dataset(:,4:4)>=day&rnnpara.dataset(:,4:4)<day+rnnpara.windows),:);
        dataset = dataset(:,2:2); %只取当前频道一列
        if size(dataset,1)==0
            continue;
        end
        [cold,hot,~] = ChannelPartition_rnn(dataset,rnnpara.channelFP);
        %-----取出测试当天数据计算频道例表中推荐次数-------
        Alldataset = rnnpara.dataset(find(rnnpara.dataset(:,4:4)==day+rnnpara.windows),:);
        Alldataset = Alldataset(:,2:2);
        if size(Alldataset,1)>0
            for i = 1:size(cold,1)
                 index = Alldataset==cold(i);
                Alldataset(index) = 0; 
            end
             for i = 1:size(hot,1)
                index = Alldataset==hot(i);
                Alldataset(index) = 1; 
             end
            for i = 1:size(Alldataset,1)-1;
                if Alldataset(i)~=Alldataset(i+1)
                    flag = flag + 1;
                end
            end
            anss = anss+flag/size(Alldataset,1);
            valid = valid +1;
        end
    end
            anss = anss/valid;
            A = [A;anss];
            B = [B;1-anss];
            fprintf('---%d-%f--\n',U,anss);
end
end


