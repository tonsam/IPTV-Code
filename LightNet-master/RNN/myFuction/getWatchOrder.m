function [ watchorder ] = getWatchOrder( dataset,channelList )
%-��ȡ��������������Ӧ�������Լ�������-
watchorder = [];
for i = 1:size(dataset)
    if ismember(dataset(i),channelList)
        watchorder = [watchorder,i];
    end
end
end





