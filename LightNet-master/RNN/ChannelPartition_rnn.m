function[ColdChannelList,HotChannelList,AllChannelList] = ChannelPartition_rnn(channelNumber,FreqPercent)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%����Ƶ���б����ݻ���Ƶ�ʰٷֱȣ����ֳ�����Ƶ����Ϊ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% channelNumber = cellfun(@str2num,channelNumber);
channel = tabulate(channelNumber);%ͳ�������и����֣�Ԫ�أ����ֵĴ��� ������-Ƶ��-Ƶ�ʡ�
channel = sortrows(channel,-3); %-3��ʾ�������У�Ƶ�ʣ��������� 
AllChannelList = channel(find(channel(:,3:3)>0 )); %��ȡ���û���������Ƶ����
%---����С�ڵ���FreqPercent%�����Ŵ���FreqPercent%---
ColdChannelList = channel(find(channel(:,3:3)>0 & channel(:,3:3)<=FreqPercent));%��ȡ����Ƶ��
HotChannelList = channel(find(channel(:,3:3)>FreqPercent));%��ȡ����Ƶ��

