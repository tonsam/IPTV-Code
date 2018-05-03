function [SingleDayResult] = getSDR(recommchannel,watchorder,datasetorder,prediction,sqlength)
%GETRCL 获取该用户该天的各种结果信息
%watchorder 样例频道对应原始序列的索引
SingleDayResult.datasetorder = datasetorder;%列向量转行向量
SingleDayResult.TotalChanNum = size(SingleDayResult.datasetorder,1); %观看总频道数
SingleDayResult.RecommChanNum = size(prediction,2);%推荐频道（次）数
SingleDayResult.AcceptedChanNum =  sum(prediction,2);% 推荐接受的频道（次）数 （5行1列）

%五个候选频道序列（还原到原始观看序列长度以作对比）
SingleDayResult.recommchannel= zeros(5,SingleDayResult.TotalChanNum );
for i = sqlength:size(watchorder,2)  %第一个推荐频道为第sqlength个
    SingleDayResult.recommchannel(:,watchorder(i)) = recommchannel(:,i-sqlength+1);
end
%未发生推荐的设置为空
for i = 1:size(SingleDayResult.recommchannel,2)
    if SingleDayResult.recommchannel(1,i) ==0
        SingleDayResult.recommchannel(:,i) = NaN;
    end
end
SingleDayResult.recommchannel = SingleDayResult.recommchannel';

%计算TopN对应的acc与recall
SingleDayResult.acc =SingleDayResult.AcceptedChanNum / SingleDayResult.RecommChanNum;
SingleDayResult.recall =SingleDayResult.AcceptedChanNum / SingleDayResult.TotalChanNum;

