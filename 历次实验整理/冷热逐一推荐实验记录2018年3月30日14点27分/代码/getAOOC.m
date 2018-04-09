function [ AOOC ] = getAOOC( rnnpara,userN,hotTopN,coldTopN)
AOOC = 0;
temp = 0;%记录有效用户数
for useritr = 1:userN
    valid = 0;%记录有效天数
    userAOOC = zeros(1,rnnpara.endday);
    for day = rnnpara.startday : rnnpara.endday
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if ( rnnpara.hotResult.recomm{useritr}(1,day) == 404 || rnnpara.coldResult.recomm{useritr}(1,day) == 404)
             continue;
        end
        valid = valid+1;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
        userhotResult.watchorder = rnnpara.hotResult.watchorder{useritr,day};
        userhotResult.prediction = rnnpara.hotResult.prediction{useritr,day};
        usercoldResult.watchorder = rnnpara.coldResult.watchorder{useritr,day};
        usercoldResult.prediction = rnnpara.coldResult.prediction{useritr,day};
        %测试集总观看次数
        maxN = max(userhotResult.watchorder );
        maxN = max([usercoldResult.watchorder,maxN] );
        %冷、热第一次推荐的下标
        hotfirstR = userhotResult.watchorder(rnnpara.seqlength-1)+1;
        coldfirstR = usercoldResult.watchorder(rnnpara.seqlength-1)+1;
        %发生的总推荐次数
        recommSum = maxN - min(hotfirstR,coldfirstR)+1;
        %统计当天每次推荐正确的次数(1中1为1，2中1为1/2，3中1为1/3)
        recommCount = zeros(1,maxN);
        %热频道统计 推荐第i个热频道，为第（i-rnnpara.seqlength+1）次推荐,
        for i = rnnpara.seqlength:size(userhotResult.watchorder,2)
            %同时推荐冷热频道，重叠推荐部分
            if userhotResult.watchorder(i) >= max(hotfirstR,coldfirstR)
                recommCount(userhotResult.watchorder(i)) = userhotResult.prediction(1,i-rnnpara.seqlength+1)*(1/(hotTopN+coldTopN));
            else%仅推荐热频道
                 recommCount(userhotResult.watchorder(i)) = userhotResult.prediction(1,i-rnnpara.seqlength+1)*(1/hotTopN);
            end
        end
        %冷频道统计
        for i = rnnpara.seqlength:size(usercoldResult.watchorder,2)
            if usercoldResult.watchorder(i) >= max(hotfirstR,coldfirstR)
                recommCount(usercoldResult.watchorder(i)) = usercoldResult.prediction(1,i-rnnpara.seqlength+1)*(1/(hotTopN+coldTopN));
            else
                recommCount(usercoldResult.watchorder(i)) = usercoldResult.prediction(1,i-rnnpara.seqlength+1)*(1/coldTopN);
            end
        end
        userAOOC(day) = sum(recommCount(:))/recommSum;
    end
    %当前用户的平均AOOC
    if valid>0
        AOOC =AOOC+sum(userAOOC)/valid;
        temp = temp+1;
    end
end
%所有用户的平均值
AOOC = AOOC/temp;                      
end

