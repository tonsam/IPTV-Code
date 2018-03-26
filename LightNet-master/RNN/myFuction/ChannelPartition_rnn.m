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


% channel = channel(1:size(AllChannelList,1),:);
% %channel = sortrows(channel,3);
% channelPercent = zeros(size(AllChannelList,1),1);
% for i = 1:size(AllChannelList,1)
%     channelPercent(i) = sum(channel(1:i,3:3));
% end
% area(channelPercent);
% hold on;
% area(channel(:,3:3));
% %set(gca,'XTick',channel(:,3:3));
 
% t=1:size(AllChannelList,1);
% x;
% y=t*sin(t)*sin(t);
% plot(x, y); 




