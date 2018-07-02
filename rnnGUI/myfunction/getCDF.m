function [ Ans ] = getCDF( ColVector )
%����һ����������CDF��i=1,2,3��Ӧ������-Ƶ��-Ƶ�ʡ�������
SortedData  = tabulate(ColVector);%ͳ�������и����֣�Ԫ�أ����ֵĴ��� ������-Ƶ��-Ƶ�ʡ�
SortedData  = sortrows(SortedData,1); % 1��ʾ����1�У����֣��������� 
Ans.SortedData = SortedData(:,1)';
Ans.AnsCDF = zeros(fix(max(SortedData(:,1)-1)*10)+2,4);%��0.1Ϊ���仮��
Step = 1.0;
for i = 1:size(SortedData,1) %��0.1���ͳ��CDF
    while SortedData(i,1)>Step %��һ������
        Step = Step+0.1;
        Ans.AnsCDF(int32((Step-1)*10),1) = Step-0.1;
        Ans.AnsCDF(int32((Step-1)*10),2) = i-1;%�ۻ��û�����
        Ans.AnsCDF(int32((Step-1)*10),3) = (i-1)*(1/size(SortedData,1));%CDF
        if Step>1.1  %��ǰ�����û�ͳ�Ƹ���
            Ans.AnsCDF(int32((Step-1)*10),4) = i-1 - Ans.AnsCDF(int32((Step-1)*10)-1,2);
        else
            Ans.AnsCDF(int32((Step-1)*10),4) = i-1;
        end
    end
end
%����ĩ�˲���
Ans.AnsCDF(int32((Step-1)*10)+1,1) = Step;
Ans.AnsCDF(int32((Step-1)*10)+1,2) = i;
Ans.AnsCDF(int32((Step-1)*10)+1,3) = i*(1/size(SortedData,1));
Ans.AnsCDF(int32((Step-1)*10)+1,4) = i - Ans.AnsCDF(int32((Step-1)*10),2);
Ans.AnsCDF = Ans.AnsCDF';
end

