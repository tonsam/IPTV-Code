function labels = nnpredict1(nn, x,chanNum)
    nn.testing = 1;
    nn = nnff(nn, x, zeros(size(x,1), nn.size(end)));
    nn.testing = 0;
    labels = [];
    for j = 1:chanNum
        [dummy, i] = max(nn.a{end},[],2);
        labels = [labels,i];
        for j1 = 1:size(i,1)
            nn.a{end}(j1,i(j1,1)) = 0;
        end
    end
end
