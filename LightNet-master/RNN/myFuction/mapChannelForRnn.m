function [dataset] = mapChannelForRnn(dataset,channelHash)
%��Ƶ����������Ƶ�����
for i = 1:size(dataset,1)
    dataset(i)=channelHash(num2str(dataset(i))); 
end
