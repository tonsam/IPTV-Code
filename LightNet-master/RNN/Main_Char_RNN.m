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
opts.valid = 1;%������ݼ��Ƿ����ѵ��Ҫ�����г��ȡ�batch_size��Ҫ�󣩣���ʼ��Ϊ1
opts.plot=1;%%��ͼ
%opts.dataDir=['./',opts.dataset_name,'/']; %����ģ��״̬������ģ�ͽ�����Ŀ¼����

% opts.parameters.batch_size=5;
% opts.parameters.n_hidden_nodes=30;
% opts.parameters.n_cell_nodes=30;
opts.parameters.test_batch_size = 1;
opts.parameters.n_input_nodes=148; %����Ĭ��ֵ
opts.parameters.n_output_nodes=148;
if strcmp(opts.network_name,'lstm')
    opts.parameters.n_gates=3; 
end
if strcmp(opts.network_name,'gru')
    opts.parameters.n_gates=2;
end
opts.parameters.n_frames=opts.seqlength;%%%%max sentence length ԭʼֵ64
opts.parameters.learning_method=learning_method;
opts.parameters.selective_sgd=use_selective_sgd;
opts.parameters.lr =sgd_lr;
opts.parameters.mom =0.9; %������

opts.results=[];
opts.results.TrainEpochError=[];
opts.results.TestEpochError=[];
opts.results.TrainEpochLoss=[];
opts.results.TestEpochLoss=[];
opts.results.LastTestEpochError=[];%����
opts.RecordStats=1;
opts.results.TrainLoss=[];
opts.results.TrainError=[];

%%%%%ѵ������׼������
opts=PrepareDataFunc(opts);
if(opts.valid==0) %����׼��δ��ɣ�����Ԥ��
    return;
end

%%%%%��ʼ�����纯������
net=NetInit(opts);
%%%%%��������ļ�
opts=generate_output_filename(opts);
%%%%%ѡ��ѵ��ģʽ
if(opts.use_gpu)       
    for i=1:length(net)
        net{i}=SwitchProcessor(net{i},'gpu');
    end
else
    for i=1:length(net)
        net{i}=SwitchProcessor(net{i},'cpu');
    end
end

opts.n_batch=floor(opts.n_train/opts.parameters.batch_size); %��������ѵ����һ��epoch��Ҫn_batch��
opts.n_test_batch=floor(opts.n_test/opts.parameters.test_batch_size);%�������ݲ�����һ����Ҫn_test_batch��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%stupid settings and initalize above
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%training goes below
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��ͼ
% if opts.plot
%     figure1=figure;
% end
opts.parameters.current_ep=1;     %start_ep=opts.parameters.current_ep;
%��ʼ����N��epochѵ��
for ep=1:opts.n_epoch
    %%%%%����һ��ѵ��
    [net,opts]=train_rnn(net,opts);  
    %��ͼ
%     if opts.plot
%         subplot(1,2,1); plot(opts.results.TrainEpochError);hold on;plot(opts.results.TestEpochError);hold off;title('Error Rate per Epoch')
%         subplot(1,2,2);plot(opts.results.TrainEpochLoss);hold on;plot(opts.results.TestEpochLoss);hold off;title('Loss per Epoch')
%         drawnow;
%     end
    %�ļ���¼ÿ��ѵ��״̬������
    parameters=opts.parameters;    
    results=opts.results;
    save(fullfile(opts.output_dir2,[opts.output_name2,num2str(ep),'.mat']),'net','parameters','results');
    opts.parameters.current_ep=opts.parameters.current_ep+1; 
end
%��������ѵ�����copyfile('source','destination')
copyfile(fullfile(opts.output_dir2,[opts.output_name2,num2str(ep),'.mat']),fullfile(opts.output_dir,opts.output_name));
%%%%%����ģ��
[opts]=test_rnn(net,opts);
%������Խ�����ļ���¼���һ��ѵ�����
disp(['Epoch ',num2str(ep),' testing error: ',num2str(opts.results.TestEpochError(end)), ' testing loss: ',num2str(opts.results.TestEpochLoss(end))])
disp(['Epoch ',num2str(ep),'last testing error: ',num2str(opts.results.LastTestEpochError(end))])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%training goes above
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


