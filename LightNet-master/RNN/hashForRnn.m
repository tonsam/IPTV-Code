function [channelHash]= hashForRnn(channelnumber)
%channelnumber = cellfun(@str2num, channelnumber);
uniquec = unique(channelnumber);%取集合a的不重复元素构成的向量
channelHash = containers.Map;% 首先声明一个映射表对象变量
for i = 1:size(uniquec,1)
    channelHash(num2str(uniquec(i)))=i;%原频道为key(Type为'char')，新频道为value('any')
end
