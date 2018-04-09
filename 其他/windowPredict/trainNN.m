function [rt1,rt2,rt3,true1,true2,true3] = trainNN(train_x1,test_x1,train_y1,test_y1,NNoutput)

train_x = double(train_x1);
test_x  = double(test_x1);
train_y = double(train_y1);
test_y  = double(test_y1);
%% ex4 neural net with sigmoid activation function
rand('state',0)
nn = nnsetup([3 100 NNoutput]);

nn.activation_function = 'sigm';    %  Sigmoid activation function
nn.learningRate = 0.5;                %  Sigm require a lower learning rate
opts.numepochs =  200;                %  Number of full sweeps through data
opts.batchsize = 1;               %  Take a mean gradient step over this many samples

nn = nntrain(nn, train_x, train_y, opts);
% [er, true] = nntest(nn, test_x, test_y);
% rt1 = 1-er;
% disp(rt);
[rt1,true1] = nntest2(nn, test_x, test_y,1);
rt2 = rt1;
true2 = true1;
if(NNoutput>=2)
    [rt2,true2] = nntest2(nn, test_x, test_y,2);
end
rt3 = rt2;
true3 = true2;
if(NNoutput>=3)
    [rt3,true3] = nntest2(nn, test_x, test_y,3);
end
% [rt2,true] = nntest2(nn, test_x, test_y,2);
% [rt3,true] = nntest2(nn, test_x, test_y,3);
%assert(er < 0.8, 'Too big error');

