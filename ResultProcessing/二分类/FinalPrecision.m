function [ anss ] = FinalPrecision(hotchannelresultPath,coldchannelresultPath,channelFreqPercent,inputFile)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��Ҫѡȡrt����
temp = load(hotchannelresultPath);
rnnpara.hotResult = temp.recomm5.rt5 ;
temp = load(coldchannelresultPath);
rnnpara.coldResult = temp.recomm5.rt5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rnnpara.channelFP = channelFreqPercent; %Ƶ������Ƶ�ʰٷֱ�
rnnpara.windows= 7;    %ѡ���ѵ������
rnnpara.startday = 1;   %��һ��ѵ��������ʼ���ڣ���һ��ѵ��Ϊ1~window�ţ�window+1����Ϊ��һ�β�������
rnnpara.endday = 31 - rnnpara.windows;   %���һ��ѵ��������ʼ���ڣ�w=7����Ϊ24��31����Ϊ���һ�β�������
rnnpara.seqlength = 5; %rnn�����г���
rnnpara.inputfiledata = load(inputFile);  %ѵ��ʱ����������
userN = 50; %��Ҫ������û�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FinalPrecision = zeros(userN,rnnpara.endday); %Ԥ�����ڴ�
fprintf('��ǰ�ļ�ΪƵ��Ϊ%f���Ǹ�...\n',channelFreqPercent);
for useritr = 1:userN
    rnnpara.dataset = rnnpara.inputfiledata(find(rnnpara.inputfiledata(:,1:1)==useritr),:);
    FinalPrecision(useritr,:) = FinalPrecision(useritr,:) + getUserFP(rnnpara,useritr);
end
anssum = 0;
temp  = 0;
for useritr = 1:userN
    sum = 0;
    i = 0;
    for day = rnnpara.startday:rnnpara.endday
        if FinalPrecision(useritr,day) ~= 404
            sum = sum + FinalPrecision(useritr,day);
            i =i+1;
        end
    end
    if i>0
        anssum = anssum + sum /i;
        temp =temp+1;
    end
end
anss = anssum / temp;
end

