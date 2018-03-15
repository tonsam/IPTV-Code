% -------------------------------------------------------------------------
function err = error_multiclass(labels, res)
% -------------------------------------------------------------------------
predictions = gather(res(end-1).x) ;
if length(size(predictions))==4
    predictions=permute(predictions,[3,4,1,2]);
end
[~,predictions] = sort(predictions, 1, 'descend') ; %预测结果

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