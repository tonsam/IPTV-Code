function[ColdChannelList,HotChannelList,AllChannelList] = ChannelPartition_rnn(channelNumber,FreqPercent)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%输入频道列表，根据划分频率百分比，划分出两类频道作为输出
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% channelNumber = cellfun(@str2num,channelNumber);
channel = tabulate(channelNumber);%统计数组中各数字（元素）出现的次数 “数字-频数-频率”
channel = sortrows(channel,-3); %-3表示按第三列（频率）降序排列 
AllChannelList = channel(find(channel(:,3:3)>0 )); %获取该用户所有曾经频道号
%---冷门小于等于FreqPercent%，热门大于FreqPercent%---
ColdChannelList = channel(find(channel(:,3:3)>0 & channel(:,3:3)<=FreqPercent));%获取冷门频道
HotChannelList = channel(find(channel(:,3:3)>FreqPercent));%获取热门频道

