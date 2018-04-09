function [ Recommmean ] = getRecommmean(someOutput )

Recommmean = zeros(5,1);
flag = 0;
for i = 1:10
    irecomm = someOutput.recomm{i};
    count = 0;
    tsum = zeros(5,1);
    for j = 1:24
        if irecomm(1,j) ~=404
            count = count +1;
            tsum = tsum + irecomm(:,j);
        end
    end
    if count >0
        tsum = tsum /count;
    end
    
    if tsum >0
        Recommmean = Recommmean + tsum;
        flag = flag + 1;
    end
    
end

Recommmean = Recommmean / flag;

end

