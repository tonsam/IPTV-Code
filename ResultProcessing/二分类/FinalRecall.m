function [ FR,hR,cR  ] = FinalRecall(hotchannelresultPath,coldchannelresultPath,channelFreqPercent,inputFile)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��Ҫѡȡrt����
temp = load(hotchannelresultPath);
rnnpara.hotResult = temp.recomm5.rt4 ;
temp = load(coldchannelresultPath);
rnnpara.coldResult = temp.recomm5.rt4;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rnnpara.channelFP = channelFreqPercent; %Ƶ������Ƶ�ʰٷֱ�
rnnpara.windows= 7;    %ѡ���ѵ������
rnnpara.startday = 1;   %��һ��ѵ��������ʼ���ڣ���һ��ѵ��Ϊ1~window�ţ�window+1����Ϊ��һ�β�������
rnnpara.endday = 31 - rnnpara.windows;   %���һ��ѵ��������ʼ���ڣ�w=7����Ϊ24��31����Ϊ���һ�β�������
rnnpara.seqlength = 5; %rnn�����г���
rnnpara.inputfiledata = load(inputFile);  %ѵ��ʱ����������
userN = 50; %��Ҫ������û�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FinalRecall = zeros(userN,rnnpara.endday); %Ԥ�����ڴ�
hotR = zeros(userN,rnnpara.endday); %Ԥ�����ڴ�
coldR = zeros(userN,rnnpara.endday); %Ԥ�����ڴ�
fprintf('��ǰ�ļ�ΪƵ��Ϊ%f���Ǹ�...\n',channelFreqPercent);
for useritr = 1:userN
    rnnpara.dataset = rnnpara.inputfiledata(find(rnnpara.inputfiledata(:,1:1)==useritr),:);
    [tempFR,temphotR,tempcoldR] = getUserFR(rnnpara,useritr);
    FinalRecall(useritr,:) = FinalRecall(useritr,:) + tempFR;
    hotR(useritr,:) = hotR(useritr,:) + temphotR;
    coldR(useritr,:) = coldR(useritr,:) + tempcoldR;
end
FR = getMean(FinalRecall,rnnpara,userN);
hR = getMean(hotR,rnnpara,userN);
cR = getMean(coldR,rnnpara,userN);

end


function [anss] = getMean(tempR,rnnpara,userN)
anssum = 0;
for useritr = 1:userN
    sum = 0;
    i = 0;
    for day = rnnpara.startday:rnnpara.endday
        sum = sum + tempR(useritr,day);
        i =i+1;
    end
    if i>0
        anssum = anssum + sum /i;
    end
end
anss = anssum /userN;
end