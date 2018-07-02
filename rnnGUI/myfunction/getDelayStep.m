function [ AnsDelayStep ] = getDelayStep(someOutput,sqlength )
%冷热区分训练DL中延时推荐，统计分析延时跳数
%计算平均延时跳数DelayStep、命中的平均延时跳数RecommDelayStep
AnsDelayStep.DelayStep = zeros(1,size(someOutput.prediction,1));
AnsDelayStep.RecommDelayStep = zeros(5,size(someOutput.prediction,1));

for U = 1:size(someOutput.prediction,1)%用户
    UDelayStep = 0;
    URecommDelayStep(:) = zeros(5,1);
    validDay = 0;%有效测试天数
    validRecommDay = zeros(5,1);%有效测试且存在命中天数
    for D = 1:size(someOutput.prediction,2) %天数
        %当天观看总频道数\观看频道序列长度
        TotalChanNum = size(someOutput.datasetorder{U,D},1);
        RecommChanNum = size(someOutput.prediction{U,D},2);%推荐频道（次）数
        if RecommChanNum == 0
            continue;
        end
        AcceptedChanNum =  sum(someOutput.prediction{U,D},2);% 推荐命中（次）数 （5行1列）
        %五个候选频道序列（还原到原始观看序列位置）
        predictionLine = zeros(5,TotalChanNum ); %正确错误曲线数据
        predictionLine(:,:) = -1;%-1表示未发生推荐，0表示推荐错误，1表示推荐正确
        for i = sqlength:size(someOutput.watchorder{U,D},2)  %第一个推荐频道为第sqlength个
            predictionLine(:,someOutput.watchorder{U,D}(i)) = someOutput.prediction{U,D}(:,i-sqlength+1);
        end
        %计算平均延时跳数dDelayStep、命中的平均延时跳数dRecommDelayStep
        dDelayStep = 0;
        dRecommDelayStep(:) = zeros(5,1);
        count = 0;
        for i = 1:TotalChanNum 
            if predictionLine(1,i)==1||predictionLine(1,i)==0 %发生一次推荐
                if dDelayStep == 0%第一个推荐的频道延时跳数为1
                    dDelayStep = 1;
                    dRecommDelayStep(:) = 1*predictionLine(:,i);  
                else
                    dDelayStep = dDelayStep +count;
                    dRecommDelayStep(:) = dRecommDelayStep(:) + count*predictionLine(:,i); 
                end
                count = 1;
            else %没发生推荐，计数
                count = count+1;
            end
        end
        UDelayStep = UDelayStep + dDelayStep/RecommChanNum;
        t = dRecommDelayStep(:)./AcceptedChanNum(:) ;
        for i = 1:5
            if isnan(t(i)) %当天不存在命中推荐则标记未0
                t(i) = 0;
                validRecommDay(i) =  validRecommDay(i)-1; 
            end
        end
        URecommDelayStep(:) =  URecommDelayStep(:) + t(:) ;
        validDay = validDay + 1;
        validRecommDay(:)= validRecommDay(:)+1;
    end
    AnsDelayStep.DelayStep(U) = UDelayStep /validDay;
    AnsDelayStep.RecommDelayStep(:,U) = URecommDelayStep(:)./validRecommDay(:);
end

