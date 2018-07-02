% -------------------------------------------------------------------------
function [err,recommchannel] = error_multiclass_test(labels, res)
% -------------------------------------------------------------------------
predictions = gather(res(end-1).x) ;
if length(size(predictions))==4
    predictions=permute(predictions,[3,4,1,2]);%B = permute(A,order)对N维数组A按照指定的向量order顺序来重新排列其维数
end
[~,predictions] = sort(predictions, 1, 'descend') ; %预测结果，1为每一列内独自排序，降序，第二个返回值为排序后对应下标

% be resilient to badly formatted labels
if numel(labels) == size(predictions, 2) 
  labels = reshape(labels,1,[]) ;
end
error = ~bsxfun(@eq, predictions, labels) ;
error=gather(error);
err(1,1) = sum(error(1,:)) ;
%此处可以推荐多个结果
if size(error,1)>=5
err(2,1) = sum(min(error(1:2,:),[],1)) ;
err(3,1) = sum(min(error(1:3,:),[],1)) ;
err(4,1) = sum(min(error(1:4,:),[],1)) ;
err(5,1) = sum(min(error(1:5,:),[],1)) ;
else
    err(2,1)=sum(min(error(1:end,:),[],1)) ;
    err(3,1)=sum(min(error(1:end,:),[],1)) ;
    err(4,1)=sum(min(error(1:end,:),[],1)) ;
    err(5,1)=sum(min(error(1:end,:),[],1)) ;
end
%返回具体推荐了那些频道（暂为映射后编号）

if size( predictions,1)>=5 %可选频道多于五个
    recommchannel =  predictions(1:5);
else
    %可选频道少于五个
    recommchannel = predictions(1:size( predictions,1));
    for i = size( predictions,1)+1: 5 %后续推荐相同的频道
         recommchannel(i) = predictions(size( predictions,1));
    end
end

    