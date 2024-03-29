function [ FR,hR,cR  ] = FinalRecall(hotchannelresultPath,coldchannelresultPath,channelFreqPercent,inputFile)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%获取冷、热频道的召回率
%需要选取rt矩阵
temp = load(hotchannelresultPath);
rnnpara.hotResult = temp.recomm5.rt4 ;
temp = load(coldchannelresultPath);
rnnpara.coldResult = temp.recomm5.rt4;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rnnpara.channelFP = channelFreqPercent; %频道划分频率百分比
rnnpara.windows= 7;    %选择的训练窗口
rnnpara.startday = 1;   %第一个训练窗口起始日期，第一次训练为1~window号，window+1号作为第一次测试日期
rnnpara.endday = 31 - rnnpara.windows;   %最后一个训练窗口起始日期，w=7，则为24，31号作为最后一次测试日期
rnnpara.seqlength = 5; %rnn的序列长度
rnnpara.inputfiledata = load(inputFile);  %训练时总输入数据
userN = 50; %需要计算的用户数量
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FinalRecall = zeros(userN,rnnpara.endday); %预分配内存
hotR = zeros(userN,rnnpara.endday); %预分配内存
coldR = zeros(userN,rnnpara.endday); %预分配内存
fprintf('当前文件为频率为%f的那个...\n',channelFreqPercent);
for useritr = 1:userN
    rnnpara.dataset = rnnpara.inputfiledata(find(rnnpara.inputfiledata(:,1:1)==useritr),:);
    [tempFR,temphotR,tempcoldR] = getUserFR(rnnpara,useritr);
    FinalRecall(useritr,:) = FinalRecall(useritr,:) + tempFR;
    hotR(useritr,:) = hotR(useritr,:) + temphotR;
    coldR(useritr,:) = coldR(useritr,:) + tempcoldR;
end
FR = getMean(FinalRecall,rnnpara,userN);
hR = getMean(hotR,rnnpara,userN);
cR = getMean(coldR,rnnpara,userN);

end


function [anss] = getMean(tempR,rnnpara,userN)
anssum = 0;
for useritr = 1:userN
    sum = 0;
    i = 0;
    for day = rnnpara.startday:rnnpara.endday
        sum = sum + tempR(useritr,day);
        i =i+1;
    end
    if i>0
        anssum = anssum + sum /i;
    end
end
anss = anssum /userN;
end