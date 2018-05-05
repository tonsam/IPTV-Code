function [SingleDayResult] = getSDR(recommchannel,watchorder,datasetorder,prediction,sqlength)
%��ȡ���û�����ĸ��ֽ����Ϣ
%watchorder ����Ƶ����Ӧԭʼ���е�����
SingleDayResult.datasetorder = datasetorder;
SingleDayResult.TotalChanNum = size(SingleDayResult.datasetorder,1); %�ۿ���Ƶ����
SingleDayResult.RecommChanNum = size(prediction,2);%�Ƽ�Ƶ�����Σ���
SingleDayResult.AcceptedChanNum =  sum(prediction,2);% �Ƽ����ܵ�Ƶ�����Σ��� ��5��1�У�

%�����ѡƵ�����У���ԭ��ԭʼ�ۿ����������Աȣ�
SingleDayResult.recommchannel = zeros(5,SingleDayResult.TotalChanNum );
SingleDayResult.prediction = zeros(5,SingleDayResult.TotalChanNum ); %��ȷ������������
SingleDayResult.prediction(:,:) = -1;%-1��ʾδ�����Ƽ���0��ʾ�Ƽ�����1��ʾ�Ƽ���ȷ
for i = sqlength:size(watchorder,2)  %��һ���Ƽ�Ƶ��Ϊ��sqlength��
    SingleDayResult.recommchannel(:,watchorder(i)) = recommchannel(:,i-sqlength+1);
    SingleDayResult.prediction(:,watchorder(i)) = prediction(:,i-sqlength+1);
end
%δ�����Ƽ�������Ϊ��
for i = 1:size(SingleDayResult.recommchannel,2)
    if SingleDayResult.recommchannel(1,i) ==0
        SingleDayResult.recommchannel(:,i) = NaN;
    end
end
%Ϊ�˻�ͼ��ת����5����������
SingleDayResult.recommchannel = SingleDayResult.recommchannel';
SingleDayResult.prediction = SingleDayResult.prediction';

%����TopN��Ӧ��acc��recall
SingleDayResult.acc =SingleDayResult.AcceptedChanNum / SingleDayResult.RecommChanNum;
SingleDayResult.recall =SingleDayResult.AcceptedChanNum / SingleDayResult.TotalChanNum;

