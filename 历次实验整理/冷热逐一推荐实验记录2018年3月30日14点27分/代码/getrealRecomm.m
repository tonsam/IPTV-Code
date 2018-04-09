function [ hotrealRecomm,coldrealRecomm,hotcoldRecomm ] = getrealRecomm( rnnpara,userN,hotTopN,coldTopN )
hotrealRecomm = zeros(5,1);
coldrealRecomm = zeros(5,1);
hotcoldRecomm = 0;
temp = 0;%记录有效用户数
for useritr = 1:userN
    hotdayRecomm = zeros(5,rnnpara.endday);
    colddayRecomm = zeros(5,rnnpara.endday);
    hotcolddayRecomm = zeros(1,rnnpara.endday);
    valid = 0;%记录有效天数
    for day = rnnpara.startday:rnnpara.endday
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if ( rnnpara.hotResult.recomm{useritr}(1,day) == 404 || rnnpara.coldResult.recomm{useritr}(1,day) == 404)
            continue;
        end
        valid = valid+1;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        userhotResult.watchorder = rnnpara.hotResult.watchorder{useritr,day};%1行
        userhotResult.prediction = rnnpara.hotResult.prediction{useritr,day};%5行
        usercoldResult.watchorder = rnnpara.coldResult.watchorder{useritr,day};
        usercoldResult.prediction = rnnpara.coldResult.prediction{useritr,day};
        %测试集总观看次数
        maxN = max(userhotResult.watchorder );
        maxN = max([usercoldResult.watchorder,maxN] );
        %冷、热第一次推荐的下标
        hotfirstR = userhotResult.watchorder(rnnpara.seqlength-1)+1;
        coldfirstR = usercoldResult.watchorder(rnnpara.seqlength-1)+1;
        %冷、热、混合各发生的总推荐次数
        hotrecommSum = maxN - hotfirstR+1;
        coldrecommSum = maxN - coldfirstR+1;
        recommSum = maxN - min(hotfirstR,coldfirstR)+1;
        %冷、热、混合频道各统计推荐成功次数
        hotcount = sum(userhotResult.prediction,2);%按行求和
        coldcount = sum(usercoldResult.prediction,2);%按行求和
        recommCount = sum(userhotResult.prediction(hotTopN,:)) + sum(usercoldResult.prediction(coldTopN,:)) ;
        %记录当天冷、热、混合推荐率
        hotdayRecomm(:,valid) = hotcount/hotrecommSum;
        colddayRecomm(:,valid) = coldcount/coldrecommSum;
        hotcolddayRecomm(day) = recommCount/recommSum;
    end
    %当前用户的平均推荐率

    if valid>0
        hotrealRecomm = hotrealRecomm + sum(hotdayRecomm,2)/valid;
        coldrealRecomm = coldrealRecomm +sum(colddayRecomm,2)/valid;
        hotcoldRecomm = hotcoldRecomm + sum(hotcolddayRecomm)/valid;
        temp = temp+1;
    end
end
%所有用户的平均值
hotrealRecomm = hotrealRecomm/temp;
coldrealRecomm = coldrealRecomm/temp;
hotcoldRecomm = hotcoldRecomm/temp;

end

