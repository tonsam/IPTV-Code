function [dataset] = delCoolChannel(dataset,channel)

nextChannel = dataset(:,2:2);
%nextChannel = cellfun(@str2num, nextChannel);
diff = setdiff(nextChannel,channel);
% nextChannel = cellfun(@str2num,nextChannel);
for delc = diff'
    %disp(nextChannel);
    index = nextChannel==delc;
    %disp(index);
    dataset(index,:)=[];
    nextChannel(index,:)=[];
end