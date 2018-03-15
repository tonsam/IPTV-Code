function[channel,output] = FindProbability(channelNumber)

%channelNumber = cellfun(@str2num,channelNumber);
channel = tabulate(channelNumber);
channel = sortrows(channel,-3);
totalRecord = size(channel,1);
channel = channel(find(channel(:,3:3)>4));
output = size(channel,1);