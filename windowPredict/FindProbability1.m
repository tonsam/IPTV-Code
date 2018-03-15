function[delchannel,output,topChannel] = FindProbability1(channelNumber,topn)
output = 0;
channel = tabulate(channelNumber);
channel = sortrows(channel,-3);
delchannel=[];
if(size(channel,1)<topn)
    topChannel = channel(:,1:1);
    channel = [];
    return;
end
topChannel = channel(1:topn,:);
topChannel = topChannel(:,1:1);
totalRecord = size(channel,1);
delchannel = channel(find(channel(:,3:3)<=4));
output = size(channel,1);
