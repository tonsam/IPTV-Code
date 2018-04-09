function [ hotrealRecomm,coldrealRecomm,hotcoldRecomm ] = getrealRecomm( rnnpara,userN,hotTopN,coldTopN )
hotrealRecomm = zeros(5,1);
coldrealRecomm = zeros(5,1);
hotcoldRecomm = 0;
temp = 0;%��¼��Ч�û���
for useritr = 1:userN
    hotdayRecomm = zeros(5,rnnpara.endday);
    colddayRecomm = zeros(5,rnnpara.endday);
    hotcolddayRecomm = zeros(1,rnnpara.endday);
    valid = 0;%��¼��Ч����
    for day = rnnpara.startday:rnnpara.endday
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if ( rnnpara.hotResult.recomm{useritr}(1,day) == 404 || rnnpara.coldResult.recomm{useritr}(1,day) == 404)
            continue;
        end
        valid = valid+1;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        userhotResult.watchorder = rnnpara.hotResult.watchorder{useritr,day};%1��
        userhotResult.prediction = rnnpara.hotResult.prediction{useritr,day};%5��
        usercoldResult.watchorder = rnnpara.coldResult.watchorder{useritr,day};
        usercoldResult.prediction = rnnpara.coldResult.prediction{useritr,day};
        %���Լ��ܹۿ�����
        maxN = max(userhotResult.watchorder );
        maxN = max([usercoldResult.watchorder,maxN] );
        %�䡢�ȵ�һ���Ƽ����±�
        hotfirstR = userhotResult.watchorder(rnnpara.seqlength-1)+1;
        coldfirstR = usercoldResult.watchorder(rnnpara.seqlength-1)+1;
        %�䡢�ȡ���ϸ����������Ƽ�����
        hotrecommSum = maxN - hotfirstR+1;
        coldrecommSum = maxN - coldfirstR+1;
        recommSum = maxN - min(hotfirstR,coldfirstR)+1;
        %�䡢�ȡ����Ƶ����ͳ���Ƽ��ɹ�����
        hotcount = sum(userhotResult.prediction,2);%�������
        coldcount = sum(usercoldResult.prediction,2);%�������
        recommCount = sum(userhotResult.prediction(hotTopN,:)) + sum(usercoldResult.prediction(coldTopN,:)) ;
        %��¼�����䡢�ȡ�����Ƽ���
        hotdayRecomm(:,valid) = hotcount/hotrecommSum;
        colddayRecomm(:,valid) = coldcount/coldrecommSum;
        hotcolddayRecomm(day) = recommCount/recommSum;
    end
    %��ǰ�û���ƽ���Ƽ���

    if valid>0
        hotrealRecomm = hotrealRecomm + sum(hotdayRecomm,2)/valid;
        coldrealRecomm = coldrealRecomm +sum(colddayRecomm,2)/valid;
        hotcoldRecomm = hotcoldRecomm + sum(hotcolddayRecomm)/valid;
        temp = temp+1;
    end
end
%�����û���ƽ��ֵ
hotrealRecomm = hotrealRecomm/temp;
coldrealRecomm = coldrealRecomm/temp;
hotcoldRecomm = hotcoldRecomm/temp;

end

