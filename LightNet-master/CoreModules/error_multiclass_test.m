% -------------------------------------------------------------------------
function [err,recommchannel] = error_multiclass_test(labels, res)
% -------------------------------------------------------------------------
predictions = gather(res(end-1).x) ;
if length(size(predictions))==4
    predictions=permute(predictions,[3,4,1,2]);%B = permute(A,order)��Nά����A����ָ��������order˳��������������ά��
end
[~,predictions] = sort(predictions, 1, 'descend') ; %Ԥ������1Ϊÿһ���ڶ������򣬽��򣬵ڶ�������ֵΪ������Ӧ�±�

% be resilient to badly formatted labels
if numel(labels) == size(predictions, 2) 
  labels = reshape(labels,1,[]) ;
end
error = ~bsxfun(@eq, predictions, labels) ;
error=gather(error);
err(1,1) = sum(error(1,:)) ;
%�˴������Ƽ�������
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
%���ؾ����Ƽ�����ЩƵ������Ϊӳ����ţ�

if size( predictions,1)>=5 %��ѡƵ���������
    recommchannel =  predictions(1:5);
else
    %��ѡƵ���������
    recommchannel = predictions(1:size( predictions,1));
    for i = size( predictions,1)+1: 5 %�����Ƽ���ͬ��Ƶ��
         recommchannel(i) = predictions(size( predictions,1));
    end
end

    