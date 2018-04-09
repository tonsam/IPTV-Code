function [ channelInfo ] = getChannelInfo( )
%获取频道相关信息：每天冷热频道分布、每天冷热频道切换分布、每天冷热频道独特数、相邻冷（热）频道距离统计
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rnnpara.channelFP = 4; %频道冷热划分频率百分比
rnnpara.windows= 7;    %选择的训练窗口
rnnpara.startday = 1;   %第一个训练窗口起始日期，第一次训练为1~window号，window+1号作为第一次测试日期
rnnpara.endday = 31 - rnnpara.windows;   %最后一个训练窗口起始日期，w=7，则为24，31号作为最后一次测试日期
inputFile = 'C:\Work\IPTV\IPTV Recommendation\dataset\Trainingset3000WithDuration[10-3600].txt';
rnnpara.inputfiledata = load(inputFile);  %训练时总输入数据
rnnpara.userid =  [1:10,1001:1010,2001:2010]; %所需用户id
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
countrow = 0;
for useritr  = rnnpara.userid
    countrow = countrow+1; %用户保存处理结果行下标记
    %获取当前用户整个月的频道观看记录序列
    rnnpara.userdataset = rnnpara.inputfiledata(find(rnnpara.inputfiledata(:,1:1)==useritr),:);
    i = fix(countrow/10) + 1;
    j = mod(countrow,10);
    if j==0 
       j = 10; i = i-1;
    end
    channelInfo.daychannelinfo(i,j ) = {getdaychannelinfo(rnnpara)}; %每个cell代表用户一个用户 
end
end

function [daychannelinfo] = getdaychannelinfo(rnnpara)
    for day = rnnpara.startday : rnnpara.endday
        %----获取训练集找出已训练过的频道列表-------
        rnnpara.tdataset = rnnpara.userdataset(find(rnnpara.userdataset(:,4:4)>=day&rnnpara.userdataset(:,4:4)<day+rnnpara.windows),:);
        rnnpara.tdataset = rnnpara.tdataset(:,2:2); %只取当前频道一列
        if size(rnnpara.tdataset,1)==0
            continue;
        end
        [cold,hot,allc] = ChannelPartition_rnn(rnnpara.tdataset,rnnpara.channelFP);
         %------------取出测试当天数据-------------
        Alldataset = rnnpara.userdataset(find(rnnpara.userdataset(:,4:4)==day+rnnpara.windows),:);
        Alldataset = Alldataset(:,2:2);
        tallc = unique(Alldataset); 
        thot = intersect(Alldataset,hot);
        tcold = intersect(Alldataset,cold); 
        %记录原始序列
        daychannelinfo.testrecord(day) = {Alldataset}; 
        %第一列为训练集的频道号（不重复）；第二列为测试频道号
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
        %测试当天冷(1)、热(2)序列及切换(1)、保持(0)序列
        if size(Alldataset,1)>0
            hotcoldsequence = zeros(1,size(Alldataset,1));  %新增的频道（不在前七天训练内）默认为0，冷；
            switchsequence = zeros(1,size(Alldataset,1));
            %冷(1)、热(2)序列
            for i = 1:size(cold,1)
                index = Alldataset==cold(i);
                hotcoldsequence(index) = 1; 
            end
            for i = 1:size(hot,1)
                index = Alldataset==hot(i);
                hotcoldsequence(index) = 2; 
            end
            %统计冷、热次数（占比）
            coldcount = 0;hotcount = 0;
            for i = 1:size(Alldataset,1)
                if hotcoldsequence(i) == 1
                    coldcount =  coldcount + 1;
                end
                if hotcoldsequence(i) == 2
                    hotcount =  hotcount + 1;
                end
            end
            %切换(1)、保持(0)序列
            for i = 2:size(Alldataset,1)
                if hotcoldsequence(i)~=hotcoldsequence(i-1)
                    switchsequence(i) = 1;
                end
            end
            %统计切换、保持次数(占比)
            switchcount =sum(switchsequence,2); 
            keepcount = size(Alldataset,1) - switchcount;
            %记录
            daychannelinfo.hotcoldsequence(day) = {hotcoldsequence};
            daychannelinfo.switchsequence(day) = {switchsequence};
            daychannelinfo.coldhotratio(day,1) = coldcount ;
            daychannelinfo.coldhotratio(day,2) = hotcount ;
            daychannelinfo.coldhotratio(day,3) = size(Alldataset,1)-coldcount-hotcount ;
            daychannelinfo.switchkeepratio(day,1) = switchcount;
            daychannelinfo.switchkeepratio(day,2) = keepcount;
            %冷（热）频道间隔统计(存在0，则该频道为新增频道)
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
            %记录同类间隔数据
            daychannelinfo.distlast(day) ={distlast};
            daychannelinfo.distlastcount(day) ={distlastcount};

        end % if size(Alldataset,1)>0
        
    end
    
    
end






