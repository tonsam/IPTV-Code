function [opts] = Main_Char_RNN(opts)
% clear all;
%%%%%%%%%%%%%This example will need to be reorganized
%opts.results.LastTestEpochError store the last channelnumber prediction error
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%provide parameters and inputs below
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('../')
addpath(genpath('../CoreModules'));
%addpath('./lm_data');

%n_epoch=opts.n_epoch; %%training epochs
dataset_name='char'; % dataset name
network_name=opts.network_name;%'gru';'rnn','lstm'

PrepareDataFunc=@PrepareData_Char_RNN; %%function handler to prepare your data

if strcmp(network_name,'lstm')
    NetInit=@net_init_char_lstm;%_bn  %% function to initialize the network
end
if strcmp(network_name,'gru')
    NetInit=@net_init_char_gru;  %% function to initialize the network
end
if strcmp(network_name,'rnn')
    NetInit=@net_init_char_rnn;  %% function to initialize the network
    opts.parameters.Id_w=1;%vanilla rnn:0, rnn with skip links: 1
end

learning_method=@rmsprop; %learning_method=@adam; %training method: @rmsprop;

use_selective_sgd=0; %automatically select learning rates
%%selective-sgd parameters
%ssgd_search_freq=10; %select new coarse-scale learning rates every n epochs
%sgd parameter (unnecessary if selective-sgd is used)
sgd_lr=1e-2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%provide parameters and inputs above
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%stupid settings and initalize below 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%opts.n_epoch=n_epoch; %training epochs 
opts.dataset_name=dataset_name; %dataset name
opts.network_name=network_name; %network name
opts.use_gpu=0; %use gpu or not 
opts.use_cudnn=0;
opts.valid = 1;%标记数据集是否符合训练要求（序列长度、batch_size等要求），初始话为1
opts.plot=1;%%画图
%opts.dataDir=['./',opts.dataset_name,'/']; %网络模型状态、网络模型结果存放目录（）

% opts.parameters.batch_size=5;
% opts.parameters.n_hidden_nodes=30;
% opts.parameters.n_cell_nodes=30;
opts.parameters.test_batch_size = 1;
opts.parameters.n_input_nodes=148; %设置默认值
opts.parameters.n_output_nodes=148;
if strcmp(opts.network_name,'lstm')
    opts.parameters.n_gates=3; 
end
if strcmp(opts.network_name,'gru')
    opts.parameters.n_gates=2;
end
opts.parameters.n_frames=opts.seqlength;%%%%max sentence length 原始值64
opts.parameters.learning_method=learning_method;
opts.parameters.selective_sgd=use_selective_sgd;
opts.parameters.lr =sgd_lr;
opts.parameters.mom =0.9; %？？？

opts.results=[];
opts.results.TrainEpochError=[];
opts.results.TestEpochError=[];
opts.results.TrainEpochLoss=[];
opts.results.TestEpochLoss=[];
opts.results.LastTestEpochError=[];%？？
opts.RecordStats=1;
opts.results.TrainLoss=[];
opts.results.TrainError=[];

%%%%%训练数据准备部分
opts=PrepareDataFunc(opts);
if(opts.valid==0) %数据准备未完成，不予预测
    return;
end

%%%%%初始化网络函数部分
net=NetInit(opts);
%%%%%生成输出文件
opts=generate_output_filename(opts);
%%%%%选择训练模式
if(opts.use_gpu)       
    for i=1:length(net)
        net{i}=SwitchProcessor(net{i},'gpu');
    end
else
    for i=1:length(net)
        net{i}=SwitchProcessor(net{i},'cpu');
    end
end

opts.n_batch=floor(opts.n_train/opts.parameters.batch_size); %所有数据训练完一次epoch需要n_batch次
opts.n_test_batch=floor(opts.n_test/opts.parameters.test_batch_size);%所有数据测试完一次需要n_test_batch次
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%stupid settings and initalize above
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%training goes below
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%画图
% if opts.plot
%     figure1=figure;
% end
opts.parameters.current_ep=1;     %start_ep=opts.parameters.current_ep;
%开始进行N次epoch训练
for ep=1:opts.n_epoch
    %%%%%进行一期训练
    [net,opts]=train_rnn(net,opts);  
    %画图
%     if opts.plot
%         subplot(1,2,1); plot(opts.results.TrainEpochError);hold on;plot(opts.results.TestEpochError);hold off;title('Error Rate per Epoch')
%         subplot(1,2,2);plot(opts.results.TrainEpochLoss);hold on;plot(opts.results.TestEpochLoss);hold off;title('Loss per Epoch')
%         drawnow;
%     end
    %文件记录每期训练状态及参数
    parameters=opts.parameters;    
    results=opts.results;
    save(fullfile(opts.output_dir2,[opts.output_name2,num2str(ep),'.mat']),'net','parameters','results');
    opts.parameters.current_ep=opts.parameters.current_ep+1; 
end
%保存最终训练结果copyfile('source','destination')
copyfile(fullfile(opts.output_dir2,[opts.output_name2,num2str(ep),'.mat']),fullfile(opts.output_dir,opts.output_name));
%%%%%测试模型
[opts]=test_rnn(net,opts);
%输出测试结果及文件记录最后一期训练结果
disp(['Epoch ',num2str(ep),' testing error: ',num2str(opts.results.TestEpochError(end)), ' testing loss: ',num2str(opts.results.TestEpochLoss(end))])
disp(['Epoch ',num2str(ep),'last testing error: ',num2str(opts.results.LastTestEpochError(end))])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%training goes above
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


