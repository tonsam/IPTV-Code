function [ eachUserMean ] = getEachUserMean( rt )
%����ÿ���û������µ�ƽ��׼ȷ�ʣ��޳�404��������������Ϊ404
%����һ������
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

