function [rt, true] = nntest2(nn, x, y,chanNum)
    labels = nnpredict1(nn, x,chanNum);
    [dummy, expected] = max(y,[],2);
    %true = ismember(expected,labels);
%     disp(labels);
%     disp('---');
%     disp(expected);
    true=[];
    for i = 1:size(x,1)
        true = [true,ismember(expected(i),labels(i:i,:))];
    end
    rt = sum(true) / size(x, 1);
%     er = numel(bad) / size(x, 1);
end