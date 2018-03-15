%%%%%%define your parameters here
%{
%%mnist mlp
opts.dataset_name='mnist-mlp';
PrepareDataFunc=@PrepareData_MNIST_MLP;
NetInit=@net_init_mlp_mnist;
use_selective_sgd=1;
ssgd_search_freq=3;
selection_reset_freq=3;
asgd_reset_freq=10;
asgd_lr=5e-2;
sgd_lr=1e-2;
opts.n_epoch=100;
opts.LoadResults=0;
%}


%{
n_epoch=20; %training epochs
dataset_name='mnist'; %dataset name
network_name='cnn'; %network name
use_gpu=1; %use gpu or not 

%function handle to prepare your data
PrepareDataFunc=@PrepareData_MNIST_CNN;
%function handle to initialize the network
NetInit=@net_init_cnn_mnist;

%automatically select learning rates
use_selective_sgd=1; 
%select a new learning rate every n epochs
ssgd_search_freq=10; 
learning_method=@sgd; %training method: @sgd,@adagrad,@rmsprop,@adam

%sgd parameter 
%(unnecessary if selective-sgd is used)
%sgd_lr=5e-2;
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end 


%opts=[];
%addpath('./CoreModules');
opts.n_epoch=n_epoch; %training epochs
opts.dataset_name=dataset_name; %dataset name
opts.network_name=network_name; %network name
opts.use_gpu=use_gpu; %use gpu or not 


if ~isfield(opts,'LoadNet')
    %
end
opts.LoadNet=0;

opts.dataDir=['./',opts.dataset_name,'/'];
opts=PrepareDataFunc(opts);

%opts.parameters=[];

opts.parameters.current_ep=1;



%%%parameters in the training

opts.parameters.learning_method=learning_method;
opts.parameters.selective_sgd=use_selective_sgd;%call selective-sgd

if(~exist('init_train','var'))
    init_train=0;
end

opts.parameters.init_train=init_train;


if(~exist('selection_reset_freq','var'))
    selection_reset_freq=0;
end

%selective-sgd parameters
if opts.parameters.selective_sgd==1
    if ~isfield(opts.parameters,'search_iterations')
        opts.parameters.search_iterations=30;%iterations used to determine the learning rate
    end
    opts.parameters.ssgd_search_freq=ssgd_search_freq;%%search every n epoch
    opts.parameters.selection_reset_freq=selection_reset_freq;%reset every n searches
    if ~isfield(opts.parameters,'lrs')
        
        opts.parameters.lrs =[1,0.5];%initialize selection range
        if ~strcmp(func2str(opts.parameters.learning_method),'sgd')
            opts.parameters.lrs =opts.parameters.lrs.*1e-2;
        end
        opts.parameters.lrs=[opts.parameters.lrs,opts.parameters.lrs*1e-1,opts.parameters.lrs*1e-2,opts.parameters.lrs*1e-3];%initialize selection range
    end
    opts.parameters.selection_count=0;%initialize
    opts.parameters.selected_lr=[];%initialize
end

if opts.parameters.selective_sgd==0
    opts.parameters.lr =sgd_lr;
end

if (~exist('asgd_reset_freq','var'))
    asgd_reset_freq=0;
end

%adaptive-sgd parameters
if strcmp(func2str(opts.parameters.learning_method),'adaptive_sgd')||strcmp(func2str(opts.parameters.learning_method),'adaptive_sgd_ew')
    opts.parameters.asgd_reset_freq=asgd_reset_freq;
    if opts.parameters.selective_sgd==0
        opts.parameters.lr_max =opts.parameters.lr;
        opts.parameters.lr_min=opts.parameters.lr_max*1e-4;
    end
    

    opts.parameters.asgd_lr=asgd_lr;%learning rate of learning rate
    if ~isfield(opts.parameters,'asgd_lr_decay')
        opts.parameters.asgd_lr_decay=0.9;
    end
    
    if exist('asgd_mom','var')
        opts.parameters.asgd_mom=asgd_mom;
    end
    
end

%%sgd parameters
if ~isfield(opts.parameters,'mom')
    opts.parameters.mom =0.9;
end

%adam parameters
if strcmp(func2str(opts.parameters.learning_method),'adam')
    if ~isfield(opts.parameters,'mom2')
        opts.parameters.mom2 =0.999;
    end
end

if ~isfield(opts.parameters,'batch_size')
    opts.parameters.batch_size=500;
end
if ~isfield(opts.parameters,'weightDecay')
    opts.parameters.weightDecay=1e-4;
end

opts=generate_output_filename(opts);


if ~isfield(opts,'plot')
    opts.plot =1;
end

if ~isfield(opts,'LoadResults')
    opts.LoadResults=0;
end

if ~opts.LoadResults
    TrainingScript();
end
