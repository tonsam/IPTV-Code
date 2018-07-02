function [ ValidSUR ] = getSUR( recomm5 ,datasetorder,prediction)
%获取该用户所有有效测试天数的统计结果

%将所有预测准确率结果中去除404数据、统计有效天数、统计在有效测试天数的平均acc
ValidDayNum = 0;
tacc = zeros(5,1);
for i = 1:size(recomm5,2)
     if recomm5(1,i) == 404 
        recomm5(:,i) =NaN;  %去除404数据
     else
        ValidDayNum = ValidDayNum + 1;%统计有效天数
        tacc = tacc + recomm5(:,i); %统计平均acc
     end
end

ValidSUR.recomm5 = recomm5';
ValidSUR.ValidDayNum = ValidDayNum;
ValidSUR.Averacc = tacc / ValidDayNum;%平均准确率

%统计汇总结果:总频道数量、总推荐频道数量、总采纳频道数量、汇总acc、汇总召回率
UserTotalChanNum = 0;
for i = 1: size(datasetorder,2)   %累加每天的频道数
    UserTotalChanNum = UserTotalChanNum + size(datasetorder{1,i},1);%dataset为（1*测试天数）的cell，cell为（观看频道个数*1）的一列数据
end
UserRecommChanNum = 0;
for i = 1: size(prediction,2)   %累加每天的推荐次数
    UserRecommChanNum = UserRecommChanNum + size(prediction{1,i},2);
end
UserAcceptedChanNum =zeros(5,1);
trecall  = zeros(5,1);
for i = 1: size(prediction,2)   
    if size(prediction{1,i},2)~= 0
        t = sum(prediction{1,i},2);%t求出当天测试命中的个数
        trecall = trecall  + t/size(datasetorder{1,i},1);%累加每天的召回率
        UserAcceptedChanNum = UserAcceptedChanNum  + t;%累加每天的推荐top推荐命中次数
    end
end

ValidSUR.UserTotalChanNum  = UserTotalChanNum ;
ValidSUR.UserRecommChanNum = UserRecommChanNum ;
ValidSUR.UserAcceptedChanNum  = UserAcceptedChanNum  ;
ValidSUR.Totalacc =UserAcceptedChanNum / UserRecommChanNum;
ValidSUR.Totalrecall =UserAcceptedChanNum / UserTotalChanNum;
ValidSUR.Averrecall = trecall / ValidDayNum;%平均召回率



