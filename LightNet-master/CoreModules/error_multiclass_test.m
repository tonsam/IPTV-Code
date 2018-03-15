% -------------------------------------------------------------------------
function err = error_multiclass_test(labels, res)
% -------------------------------------------------------------------------
predictions = gather(res(end-1).x) ;
if length(size(predictions))==4
    predictions=permute(predictions,[3,4,1,2]);
end
[~,predictions] = sort(predictions, 1, 'descend') ;

% be resilient to badly formatted labels
if numel(labels) == size(predictions, 2)
  labels = reshape(labels,1,[]) ;
end
error = ~bsxfun(@eq, predictions, labels) ;
error=gather(error);
for i = 1 : 10
    err(i,1) = sum(error(i,:));
end