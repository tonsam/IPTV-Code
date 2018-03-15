function [dataset] = mapChannelForRnn(dataset,channelHash)
%新频道编号替代就频道编号
for i = 1:size(dataset,1)
    dataset(i)=channelHash(num2str(dataset(i))); 
end
