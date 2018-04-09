function [ watchorder ] = getWatchOrder( dataset,channelList )
%-获取分类后测试样例对应完整测试集的索引-
watchorder = [];
for i = 1:size(dataset)
    if ismember(dataset(i),channelList)
        watchorder = [watchorder,i];
    end
end
end





