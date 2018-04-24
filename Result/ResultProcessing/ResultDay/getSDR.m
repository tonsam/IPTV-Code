function [SingleDayResult] = getSDR(recommchannel,watchorder,datasetorder,prediction,sqlength)
%GETRCL ��ȡ���û�����ĸ��ֽ����Ϣ
%watchorder ����Ƶ����Ӧԭʼ���е�����
SingleDayResult.datasetorder = datasetorder;%������ת������
SingleDayResult.TotalChanNum = size(SingleDayResult.datasetorder,1); %�ۿ���Ƶ����
SingleDayResult.RecommChanNum = size(prediction,2);%�Ƽ�Ƶ�����Σ���
SingleDayResult.AcceptedChanNum =  sum(prediction,2);% �Ƽ����ܵ�Ƶ�����Σ��� ��5��1�У�

%�����ѡƵ�����У���ԭ��ԭʼ�ۿ����г��������Աȣ�
SingleDayResult.recommchannel= zeros(5,SingleDayResult.TotalChanNum );
for i = sqlength:size(watchorder,2)  %��һ���Ƽ�Ƶ��Ϊ��sqlength��
    SingleDayResult.recommchannel(:,watchorder(i)) = recommchannel(:,i-sqlength+1);
end
%δ�����Ƽ�������Ϊ��
for i = 1:size(SingleDayResult.recommchannel,2)
    if SingleDayResult.recommchannel(1,i) ==0
        SingleDayResult.recommchannel(:,i) = NaN;
    end
end
SingleDayResult.recommchannel = SingleDayResult.recommchannel';

%����TopN��Ӧ��acc��recall
SingleDayResult.acc =SingleDayResult.AcceptedChanNum / SingleDayResult.RecommChanNum;
SingleDayResult.recall =SingleDayResult.AcceptedChanNum / SingleDayResult.TotalChanNum;

