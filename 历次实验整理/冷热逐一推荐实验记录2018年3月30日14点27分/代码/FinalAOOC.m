function [ hotrealRecomm,coldrealRecomm,hotcoldRecomm,AOOC] = FinalAOOC( hotchannelresultPath,coldchannelresultPath )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
temp = load(hotchannelresultPath);
rnnpara.hotResult.watchorder = temp.someOutput.watchorder ;
rnnpara.hotResult.prediction = temp.someOutput.prediction ;
rnnpara.hotResult.recomm = temp.someOutput.recomm ;
temp = load(coldchannelresultPath);
rnnpara.coldResult.watchorder = temp.someOutput.watchorder ;
rnnpara.coldResult.prediction = temp.someOutput.prediction ;
rnnpara.coldResult.recomm = temp.someOutput.recomm ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rnnpara.windows= 7;    %ѡ���ѵ������
rnnpara.startday = 1;   %��һ��ѵ��������ʼ���ڣ���һ��ѵ��Ϊ1~window�ţ�window+1����Ϊ��һ�β�������
rnnpara.endday = 31 - rnnpara.windows;   %���һ��ѵ��������ʼ���ڣ�w=7����Ϊ24��31����Ϊ���һ�β�������
rnnpara.seqlength = 5; %rnn�����г�
userN = 10; %��Ҫ������û�����
hotTopN = 3;
coldTopN = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[hotrealRecomm,coldrealRecomm,hotcoldRecomm] = getrealRecomm(rnnpara,userN,hotTopN,coldTopN);

AOOC = getAOOC(rnnpara,userN,hotTopN,coldTopN);%�Ƽ�һ����Ƶ�����Ƽ�һ����Ƶ��



end

