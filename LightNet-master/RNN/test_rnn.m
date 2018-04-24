function [opts]=test_rnn(net,opts)

    opts.training=0;


    opts.MiniBatchError=[];
    opts.MiniBatchLoss=[];
    opts.myOutput.LastMiniBatchError=[];
    opts.myOutput.LastMiniBatchRecommchannel=[];
    opts.myOutput.AllMiniBatchPrediction=[];
 
    
    for mini_b=1:opts.n_test_batch
        idx=1+(mini_b-1)*opts.parameters.test_batch_size:mini_b*opts.parameters.test_batch_size;%选取每个batch对应的记录
        opts.input_data=opts.test(:,idx,:);
        opts.input_labels=opts.test_labels(idx,:);

        %forward
        if strcmp(opts.network_name,'lstm')
            [ net,res,opts ] = test_lstm_ff( net,opts );
        end
        if strcmp(opts.network_name,'gru')
            [ net,res,opts ] = gru_ff( net,opts );
        end
        if strcmp(opts.network_name,'rnn')
            [ net,res,opts ] = rnn_ff( net,opts );
        end
       
        if isfield(opts,'err')
            opts.MiniBatchError=[opts.MiniBatchError;gather( opts.err(1))];
            %自己加的，计算序列中最后一个预测的准确率及候选频道
            opts.myOutput.LastMiniBatchError=[opts.myOutput.LastMiniBatchError,gather( opts.myOutput.lasterr)];
            opts.myOutput.LastMiniBatchRecommchannel=[opts.myOutput.LastMiniBatchRecommchannel,gather( opts.myOutput.lastrecommchannel)];
        end
        opts.MiniBatchLoss=[opts.MiniBatchLoss;gather( opts.loss)];
        
        
    end
    
    opts.results.TestEpochError=[opts.results.TestEpochError;mean(opts.MiniBatchError(:))];
    opts.results.TestEpochLoss=[opts.results.TestEpochLoss;mean(opts.MiniBatchLoss(:))];
    opts.results.LastTestEpochError=[opts.results.LastTestEpochError;mean(opts.myOutput.LastMiniBatchError,2)];
      
end


