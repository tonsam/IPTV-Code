function [er, bad] = cnntest(net, x, y)
bad=0;
for i=1:5
    x1=x(:,:,2000*(i-1)+1:2000*i);
    y1=y(:,2000*(i-1)+1:2000*i);
    net = cnnff(net, x1);

    [~, h] = max(net.o);
    [~, a] = max(y1);
    bad = bad+numel(find(h ~= a));
end
    
    er = bad / size(y, 2);
end
