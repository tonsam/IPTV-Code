function [ ValidSUR ] = getSUR( recomm5 ,datasetorder,prediction)
%��ȡ���û�������Ч����������ͳ�ƽ��

%������Ԥ��׼ȷ�ʽ����ȥ��404���ݡ�ͳ����Ч������ͳ������Ч����������ƽ��acc
ValidDayNum = 0;
tacc = zeros(5,1);
for i = 1:size(recomm5,2)
     if recomm5(1,i) == 404 
        recomm5(:,i) =NaN;  %ȥ��404����
     else
        ValidDayNum = ValidDayNum + 1;%ͳ����Ч����
        tacc = tacc + recomm5(:,i); %ͳ��ƽ��acc
     end
end

ValidSUR.recomm5 = recomm5';
ValidSUR.ValidDayNum = ValidDayNum;
ValidSUR.Averacc = tacc / ValidDayNum;%ƽ��׼ȷ��

%ͳ�ƻ��ܽ��:��Ƶ�����������Ƽ�Ƶ���������ܲ���Ƶ������������acc�������ٻ���
UserTotalChanNum = 0;
for i = 1: size(datasetorder,2)   %�ۼ�ÿ���Ƶ����
    UserTotalChanNum = UserTotalChanNum + size(datasetorder{1,i},1);%datasetΪ��1*������������cell��cellΪ���ۿ�Ƶ������*1����һ������
end
UserRecommChanNum = 0;
for i = 1: size(prediction,2)   %�ۼ�ÿ����Ƽ�����
    UserRecommChanNum = UserRecommChanNum + size(prediction{1,i},2);
end
UserAcceptedChanNum =zeros(5,1);
trecall  = zeros(5,1);
for i = 1: size(prediction,2)   
    if size(prediction{1,i},2)~= 0
        t = sum(prediction{1,i},2);%t�������������еĸ���
        trecall = trecall  + t/size(datasetorder{1,i},1);%�ۼ�ÿ����ٻ���
        UserAcceptedChanNum = UserAcceptedChanNum  + t;%�ۼ�ÿ����Ƽ�top�Ƽ����д���
    end
end

ValidSUR.UserTotalChanNum  = UserTotalChanNum ;
ValidSUR.UserRecommChanNum = UserRecommChanNum ;
ValidSUR.UserAcceptedChanNum  = UserAcceptedChanNum  ;
ValidSUR.Totalacc =UserAcceptedChanNum / UserRecommChanNum;
ValidSUR.Totalrecall =UserAcceptedChanNum / UserTotalChanNum;
ValidSUR.Averrecall = trecall / ValidDayNum;%ƽ���ٻ���



