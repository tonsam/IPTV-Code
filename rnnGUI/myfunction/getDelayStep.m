function [ AnsDelayStep ] = getDelayStep(someOutput,sqlength )
%��������ѵ��DL����ʱ�Ƽ���ͳ�Ʒ�����ʱ����
%����ƽ����ʱ����DelayStep�����е�ƽ����ʱ����RecommDelayStep
AnsDelayStep.DelayStep = zeros(1,size(someOutput.prediction,1));
AnsDelayStep.RecommDelayStep = zeros(5,size(someOutput.prediction,1));

for U = 1:size(someOutput.prediction,1)%�û�
    UDelayStep = 0;
    URecommDelayStep(:) = zeros(5,1);
    validDay = 0;%��Ч��������
    validRecommDay = zeros(5,1);%��Ч�����Ҵ�����������
    for D = 1:size(someOutput.prediction,2) %����
        %����ۿ���Ƶ����\�ۿ�Ƶ�����г���
        TotalChanNum = size(someOutput.datasetorder{U,D},1);
        RecommChanNum = size(someOutput.prediction{U,D},2);%�Ƽ�Ƶ�����Σ���
        if RecommChanNum == 0
            continue;
        end
        AcceptedChanNum =  sum(someOutput.prediction{U,D},2);% �Ƽ����У��Σ��� ��5��1�У�
        %�����ѡƵ�����У���ԭ��ԭʼ�ۿ�����λ�ã�
        predictionLine = zeros(5,TotalChanNum ); %��ȷ������������
        predictionLine(:,:) = -1;%-1��ʾδ�����Ƽ���0��ʾ�Ƽ�����1��ʾ�Ƽ���ȷ
        for i = sqlength:size(someOutput.watchorder{U,D},2)  %��һ���Ƽ�Ƶ��Ϊ��sqlength��
            predictionLine(:,someOutput.watchorder{U,D}(i)) = someOutput.prediction{U,D}(:,i-sqlength+1);
        end
        %����ƽ����ʱ����dDelayStep�����е�ƽ����ʱ����dRecommDelayStep
        dDelayStep = 0;
        dRecommDelayStep(:) = zeros(5,1);
        count = 0;
        for i = 1:TotalChanNum 
            if predictionLine(1,i)==1||predictionLine(1,i)==0 %����һ���Ƽ�
                if dDelayStep == 0%��һ���Ƽ���Ƶ����ʱ����Ϊ1
                    dDelayStep = 1;
                    dRecommDelayStep(:) = 1*predictionLine(:,i);  
                else
                    dDelayStep = dDelayStep +count;
                    dRecommDelayStep(:) = dRecommDelayStep(:) + count*predictionLine(:,i); 
                end
                count = 1;
            else %û�����Ƽ�������
                count = count+1;
            end
        end
        UDelayStep = UDelayStep + dDelayStep/RecommChanNum;
        t = dRecommDelayStep(:)./AcceptedChanNum(:) ;
        for i = 1:5
            if isnan(t(i)) %���첻���������Ƽ�����δ0
                t(i) = 0;
                validRecommDay(i) =  validRecommDay(i)-1; 
            end
        end
        URecommDelayStep(:) =  URecommDelayStep(:) + t(:) ;
        validDay = validDay + 1;
        validRecommDay(:)= validRecommDay(:)+1;
    end
    AnsDelayStep.DelayStep(U) = UDelayStep /validDay;
    AnsDelayStep.RecommDelayStep(:,U) = URecommDelayStep(:)./validRecommDay(:);
end

