function [ AOOC ] = getAOOC( rnnpara,userN,hotTopN,coldTopN)
AOOC = 0;
temp = 0;%��¼��Ч�û���
for useritr = 1:userN
    valid = 0;%��¼��Ч����
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
        %���Լ��ܹۿ�����
        maxN = max(userhotResult.watchorder );
        maxN = max([usercoldResult.watchorder,maxN] );
        %�䡢�ȵ�һ���Ƽ����±�
        hotfirstR = userhotResult.watchorder(rnnpara.seqlength-1)+1;
        coldfirstR = usercoldResult.watchorder(rnnpara.seqlength-1)+1;
        %���������Ƽ�����
        recommSum = maxN - min(hotfirstR,coldfirstR)+1;
        %ͳ�Ƶ���ÿ���Ƽ���ȷ�Ĵ���(1��1Ϊ1��2��1Ϊ1/2��3��1Ϊ1/3)
        recommCount = zeros(1,maxN);
        %��Ƶ��ͳ�� �Ƽ���i����Ƶ����Ϊ�ڣ�i-rnnpara.seqlength+1�����Ƽ�,
        for i = rnnpara.seqlength:size(userhotResult.watchorder,2)
            %ͬʱ�Ƽ�����Ƶ�����ص��Ƽ�����
            if userhotResult.watchorder(i) >= max(hotfirstR,coldfirstR)
                recommCount(userhotResult.watchorder(i)) = userhotResult.prediction(1,i-rnnpara.seqlength+1)*(1/(hotTopN+coldTopN));
            else%���Ƽ���Ƶ��
                 recommCount(userhotResult.watchorder(i)) = userhotResult.prediction(1,i-rnnpara.seqlength+1)*(1/hotTopN);
            end
        end
        %��Ƶ��ͳ��
        for i = rnnpara.seqlength:size(usercoldResult.watchorder,2)
            if usercoldResult.watchorder(i) >= max(hotfirstR,coldfirstR)
                recommCount(usercoldResult.watchorder(i)) = usercoldResult.prediction(1,i-rnnpara.seqlength+1)*(1/(hotTopN+coldTopN));
            else
                recommCount(usercoldResult.watchorder(i)) = usercoldResult.prediction(1,i-rnnpara.seqlength+1)*(1/coldTopN);
            end
        end
        userAOOC(day) = sum(recommCount(:))/recommSum;
    end
    %��ǰ�û���ƽ��AOOC
    if valid>0
        AOOC =AOOC+sum(userAOOC)/valid;
        temp = temp+1;
    end
end
%�����û���ƽ��ֵ
AOOC = AOOC/temp;                      
end

