function [ eachUserMean ] = getEachUserMean( rt )
%计算每个用户整个月的平均准确率，剔除404；数据量不足则为404
%返回一列向量
eachUserMean =  zeros(50,1);
for i = 1: 50
    sum = 0;
    count = 0;
    for j = 1:size(rt,2)
        if rt(i,j) ~= 404
            sum = sum + rt(i,j);
            count = count + 1;
        end
    end
    
    if sum ~= 0
        eachUserMean(i) = eachUserMean(i) + double(sum/count);
    else
        eachUserMean(i) = eachUserMean(i) + 404;
    end
end
end

