function [channelHash]= hashForRnnTest(channelHash,channelnumber,trainChannelNumber)

sizeHash = channelHash.Count;
diffchannel = setdiff(channelnumber,trainChannelNumber);
for i = 1:size(diffchannel,2)
    channelHash(num2str(diffchannel(i)))=sizeHash + i;
end
