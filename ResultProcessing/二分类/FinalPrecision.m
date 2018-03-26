function [ anss ] = FinalPrecision(hotchannelresultPath,coldchannelresultPath,channelFreqPercent,inputFile)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%需要选取rt矩阵
temp = load(hotchannelresultPath);
rnnpara.hotResult = temp.recomm5.rt5 ;
temp = load(coldchannelresultPath);
rnnpara.coldResult = temp.recomm5.rt5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rnnpara.channelFP = channelFreqPercent; %频道划分频率百分比
rnnpara.windows= 7;    %选择的训练窗口
rnnpara.startday = 1;   %第一个训练窗口起始日期，第一次训练为1~window号，window+1号作为第一次测试日期
rnnpara.endday = 31 - rnnpara.windows;   %最后一个训练窗口起始日期，w=7，则为24，31号作为最后一次测试日期
rnnpara.seqlength = 5; %rnn的序列长度
rnnpara.inputfiledata = load(inputFile);  %训练时总输入数据
userN = 50; %需要计算的用户数量
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FinalPrecision = zeros(userN,rnnpara.endday); %预分配内存
fprintf('当前文件为频率为%f的那个...\n',channelFreqPercent);
for useritr = 1:userN
    rnnpara.dataset = rnnpara.inputfiledata(find(rnnpara.inputfiledata(:,1:1)==useritr),:);
    FinalPrecision(useritr,:) = FinalPrecision(useritr,:) + getUserFP(rnnpara,useritr);
end
anssum = 0;
temp  = 0;
for useritr = 1:userN
    sum = 0;
    i = 0;
    for day = rnnpara.startday:rnnpara.endday
        if FinalPrecision(useritr,day) ~= 404
            sum = sum + FinalPrecision(useritr,day);
            i =i+1;
        end
    end
    if i>0
        anssum = anssum + sum /i;
        temp =temp+1;
    end
end
anss = anssum / temp;
end

