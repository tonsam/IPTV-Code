function [channelHash]= hashTab(channelnumber)

%channelnumber = cellfun(@str2num, channelnumber);
uniquec = unique(channelnumber);
channelHash = containers.Map;
for i = 1:size(uniquec,1)
    channelHash(num2str(uniquec(i)))=i;
end
