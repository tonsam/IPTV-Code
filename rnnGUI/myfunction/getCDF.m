function [ Ans ] = getCDF( ColVector )
%计算一个列向量的CDF，i=1,2,3对应“数字-频数-频率”列排序
SortedData  = tabulate(ColVector);%统计数组中各数字（元素）出现的次数 “数字-频数-频率”
SortedData  = sortrows(SortedData,1); % 1表示按第1列（数字）升序排列 
Ans.SortedData = SortedData(:,1)';
Ans.AnsCDF = zeros(fix(max(SortedData(:,1)-1)*10)+2,4);%以0.1为区间划分
Step = 1.0;
for i = 1:size(SortedData,1) %按0.1间隔统计CDF
    while SortedData(i,1)>Step %下一个区间
        Step = Step+0.1;
        Ans.AnsCDF(int32((Step-1)*10),1) = Step-0.1;
        Ans.AnsCDF(int32((Step-1)*10),2) = i-1;%累积用户个数
        Ans.AnsCDF(int32((Step-1)*10),3) = (i-1)*(1/size(SortedData,1));%CDF
        if Step>1.1  %当前区间用户统计个数
            Ans.AnsCDF(int32((Step-1)*10),4) = i-1 - Ans.AnsCDF(int32((Step-1)*10)-1,2);
        else
            Ans.AnsCDF(int32((Step-1)*10),4) = i-1;
        end
    end
end
%序列末端补充
Ans.AnsCDF(int32((Step-1)*10)+1,1) = Step;
Ans.AnsCDF(int32((Step-1)*10)+1,2) = i;
Ans.AnsCDF(int32((Step-1)*10)+1,3) = i*(1/size(SortedData,1));
Ans.AnsCDF(int32((Step-1)*10)+1,4) = i - Ans.AnsCDF(int32((Step-1)*10),2);
Ans.AnsCDF = Ans.AnsCDF';
end

