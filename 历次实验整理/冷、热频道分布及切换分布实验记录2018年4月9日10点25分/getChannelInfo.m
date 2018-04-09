function [ channelInfo ] = getChannelInfo( )
%��ȡƵ�������Ϣ��ÿ������Ƶ���ֲ���ÿ������Ƶ���л��ֲ���ÿ������Ƶ���������������䣨�ȣ�Ƶ������ͳ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rnnpara.channelFP = 4; %Ƶ�����Ȼ���Ƶ�ʰٷֱ�
rnnpara.windows= 7;    %ѡ���ѵ������
rnnpara.startday = 1;   %��һ��ѵ��������ʼ���ڣ���һ��ѵ��Ϊ1~window�ţ�window+1����Ϊ��һ�β�������
rnnpara.endday = 31 - rnnpara.windows;   %���һ��ѵ��������ʼ���ڣ�w=7����Ϊ24��31����Ϊ���һ�β�������
inputFile = 'C:\Work\IPTV\IPTV Recommendation\dataset\Trainingset3000WithDuration[10-3600].txt';
rnnpara.inputfiledata = load(inputFile);  %ѵ��ʱ����������
rnnpara.userid =  [1:10,1001:1010,2001:2010]; %�����û�id
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
countrow = 0;
for useritr  = rnnpara.userid
    countrow = countrow+1; %�û����洦�������±��
    %��ȡ��ǰ�û������µ�Ƶ���ۿ���¼����
    rnnpara.userdataset = rnnpara.inputfiledata(find(rnnpara.inputfiledata(:,1:1)==useritr),:);
    i = fix(countrow/10) + 1;
    j = mod(countrow,10);
    if j==0 
       j = 10; i = i-1;
    end
    channelInfo.daychannelinfo(i,j ) = {getdaychannelinfo(rnnpara)}; %ÿ��cell�����û�һ���û� 
end
end

function [daychannelinfo] = getdaychannelinfo(rnnpara)
    for day = rnnpara.startday : rnnpara.endday
        %----��ȡѵ�����ҳ���ѵ������Ƶ���б�-------
        rnnpara.tdataset = rnnpara.userdataset(find(rnnpara.userdataset(:,4:4)>=day&rnnpara.userdataset(:,4:4)<day+rnnpara.windows),:);
        rnnpara.tdataset = rnnpara.tdataset(:,2:2); %ֻȡ��ǰƵ��һ��
        if size(rnnpara.tdataset,1)==0
            continue;
        end
        [cold,hot,allc] = ChannelPartition_rnn(rnnpara.tdataset,rnnpara.channelFP);
         %------------ȡ�����Ե�������-------------
        Alldataset = rnnpara.userdataset(find(rnnpara.userdataset(:,4:4)==day+rnnpara.windows),:);
        Alldataset = Alldataset(:,2:2);
        tallc = unique(Alldataset); 
        thot = intersect(Alldataset,hot);
        tcold = intersect(Alldataset,cold); 
        %��¼ԭʼ����
        daychannelinfo.testrecord(day) = {Alldataset}; 
        %��һ��Ϊѵ������Ƶ���ţ����ظ������ڶ���Ϊ����Ƶ����
        daychannelinfo.allchannellist(day,1) = {unique(allc)};
        daychannelinfo.hotchannellist(day,1) = {unique(hot)};
        daychannelinfo.coldchannellist(day,1) = {unique(cold)};
        daychannelinfo.allchannelnum(day,1) = size(allc,1);
        daychannelinfo.hotchannelnum(day,1) = size(hot,1);
        daychannelinfo.coldchannelnum(day,1) = size(cold,1);
        daychannelinfo.allchannellist(day,2) = {tallc};
        daychannelinfo.hotchannellist(day,2) = {thot};
        daychannelinfo.coldchannellist(day,2) = {tcold};
        daychannelinfo.allchannelnum(day,2) = size(tallc,1);
        daychannelinfo.hotchannelnum(day,2) = size(thot,1);
        daychannelinfo.coldchannelnum(day,2) = size(tcold,1);
        %���Ե�����(1)����(2)���м��л�(1)������(0)����
        if size(Alldataset,1)>0
            hotcoldsequence = zeros(1,size(Alldataset,1));  %������Ƶ��������ǰ����ѵ���ڣ�Ĭ��Ϊ0���䣻
            switchsequence = zeros(1,size(Alldataset,1));
            %��(1)����(2)����
            for i = 1:size(cold,1)
                index = Alldataset==cold(i);
                hotcoldsequence(index) = 1; 
            end
            for i = 1:size(hot,1)
                index = Alldataset==hot(i);
                hotcoldsequence(index) = 2; 
            end
            %ͳ���䡢�ȴ�����ռ�ȣ�
            coldcount = 0;hotcount = 0;
            for i = 1:size(Alldataset,1)
                if hotcoldsequence(i) == 1
                    coldcount =  coldcount + 1;
                end
                if hotcoldsequence(i) == 2
                    hotcount =  hotcount + 1;
                end
            end
            %�л�(1)������(0)����
            for i = 2:size(Alldataset,1)
                if hotcoldsequence(i)~=hotcoldsequence(i-1)
                    switchsequence(i) = 1;
                end
            end
            %ͳ���л������ִ���(ռ��)
            switchcount =sum(switchsequence,2); 
            keepcount = size(Alldataset,1) - switchcount;
            %��¼
            daychannelinfo.hotcoldsequence(day) = {hotcoldsequence};
            daychannelinfo.switchsequence(day) = {switchsequence};
            daychannelinfo.coldhotratio(day,1) = coldcount ;
            daychannelinfo.coldhotratio(day,2) = hotcount ;
            daychannelinfo.coldhotratio(day,3) = size(Alldataset,1)-coldcount-hotcount ;
            daychannelinfo.switchkeepratio(day,1) = switchcount;
            daychannelinfo.switchkeepratio(day,2) = keepcount;
            %�䣨�ȣ�Ƶ�����ͳ��(����0�����Ƶ��Ϊ����Ƶ��)
            distlast = zeros(1,size(Alldataset,1)) ;
            distlastcount = zeros(1,size(Alldataset,1)) ;
            lasthot = 0; lastcold = 0;
            for i = 1:size(Alldataset,1)
                if hotcoldsequence(i) == 2 
                    if lasthot == 0
                        distlast(i) = 1;
                        lasthot = i;
                    else
                        distlast(i) = i-lasthot;
                        lasthot = i;
                    end
                    distlastcount(distlast(i)) = distlastcount(distlast(i)) +1;
                end
                if hotcoldsequence(i) == 1 
                    if lastcold == 0
                        distlast(i) = 1;
                        lastcold = i;
                    else
                        distlast(i) = i-lastcold;
                        lastcold = i;
                    end
                    distlastcount(distlast(i)) = distlastcount(distlast(i)) +1;
                end
               
            end
            %��¼ͬ��������
            daychannelinfo.distlast(day) ={distlast};
            daychannelinfo.distlastcount(day) ={distlastcount};

        end % if size(Alldataset,1)>0
        
    end
    
    
end






