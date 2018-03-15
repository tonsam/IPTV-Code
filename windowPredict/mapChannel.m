function [dataset] = mapChannel(dataset,channelHash)

% uniquec = unique(dataset);
% i =1;
% for change = uniquec'
%     dataset(dataset==change)=i;
%     i=i+1;
% end
%dataset = cellfun(@str2num, dataset);
for i = 1:size(dataset,1)
    dataset(i)=channelHash(num2str(dataset(i)));
end
