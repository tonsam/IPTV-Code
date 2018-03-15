function [dataset] = getChannelRecord_rnn(dataset,channelList)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%从dataset获取channelList中的频道观看记录
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%diff存放channelList外的频道列表
diff = setdiff(dataset,channelList); % c = setdiff(A, B) 返回在A中有，而B中没有的值，结果向量将以升序排序返回
%去掉diff频道列表的记录
for delc = diff'
    index = dataset==delc;
    dataset(index,:)=[];
end