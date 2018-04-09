function [ hotrealRecomm,coldrealRecomm,hotcoldRecomm,AOOC] = FinalAOOC( hotchannelresultPath,coldchannelresultPath )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
temp = load(hotchannelresultPath);
rnnpara.hotResult.watchorder = temp.someOutput.watchorder ;
rnnpara.hotResult.prediction = temp.someOutput.prediction ;
rnnpara.hotResult.recomm = temp.someOutput.recomm ;
temp = load(coldchannelresultPath);
rnnpara.coldResult.watchorder = temp.someOutput.watchorder ;
rnnpara.coldResult.prediction = temp.someOutput.prediction ;
rnnpara.coldResult.recomm = temp.someOutput.recomm ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rnnpara.windows= 7;    %选择的训练窗口
rnnpara.startday = 1;   %第一个训练窗口起始日期，第一次训练为1~window号，window+1号作为第一次测试日期
rnnpara.endday = 31 - rnnpara.windows;   %最后一个训练窗口起始日期，w=7，则为24，31号作为最后一次测试日期
rnnpara.seqlength = 5; %rnn的序列长
userN = 10; %需要计算的用户数量
hotTopN = 3;
coldTopN = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[hotrealRecomm,coldrealRecomm,hotcoldRecomm] = getrealRecomm(rnnpara,userN,hotTopN,coldTopN);

AOOC = getAOOC(rnnpara,userN,hotTopN,coldTopN);%推荐一个热频道、推荐一个冷频道



end

