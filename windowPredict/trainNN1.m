function [opts] = trainNN1(train_x1,test_x1,train_y1,test_y1,NNoutput,opts)

train_x = double(train_x1);
test_x  = double(test_x1);
train_y = double(train_y1);
test_y  = double(test_y1);
%´æ·Å½á¹û

%% ex4 neural net with sigmoid activation function
rand('state',0)
nn = nnsetup([1 50 NNoutput]);

nn.activation_function = 'sigm';    %  Sigmoid activation function
nn.learningRate = opts.learningRate;                %  Sigm require a lower learning rate
% opts.numepochs =  500;                %  Number of full sweeps through data
% opts.batchsize = opts.batch_size;               %  Take a mean gradient step over this many samples

nn = nntrain(nn, train_x, train_y, opts);

[er, bad] = nntest(nn, test_x, test_y);
opts.LastTestEpochError(1,1) = 1-er;
[opts.LastTestEpochError(2,1),true] = nntest2(nn,test_x,test_y,2);
[opts.LastTestEpochError(3,1),true] = nntest2(nn,test_x,test_y,3);
[opts.LastTestEpochError(4,1),true] = nntest2(nn,test_x,test_y,4);
[opts.LastTestEpochError(5,1),true] = nntest2(nn,test_x,test_y,5);

