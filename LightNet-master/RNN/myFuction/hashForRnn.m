function [channelHash,channelHashBack]= hashForRnn(channelnumber)
%channelnumber = cellfun(@str2num, channelnumber);
uniquec = unique(channelnumber);%取集合a的不重复元素构成的向量
channelHash = containers.Map;% 首先声明一个映射表对象变量
channelHashBack = containers.Map;
for i = 1:size(uniquec,1)
    channelHash(num2str(uniquec(i)))=i;%原频道为key(Type为'char')，新频道为value('any')
    channelHashBack(num2str(i+1)) =  uniquec(i); %原频道为value(Type为'any')，新频道为key('any'),用于还原映射，
    %+1是预留新频道1编号为默认前置频道（看后面词向量转换操作）
end
channelHashBack(num2str(1)) =  0;
% disp(channelHashBack);
