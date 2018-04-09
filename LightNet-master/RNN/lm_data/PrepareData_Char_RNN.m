function [ opts ] = PrepareData_Char_RNN( opts )
%max_char=156;   %所有的频道数，不可改！
%dataset = cellfun(@str2num,dataset);
%说明：映射完后，所有频道号加1【跟补充前置零频道（调整为1）作为初始频道有关】
opts.valid = 0;  %数据准备未完成，设置训练为无效，见最后一行
%%%%%%%%%%%%%%%%%%%%%%%训练集预处理部分%%%%%%%%%%%%%%%%%%%%%%%%
%-------取出用户训练窗口内的数据---------
dataset = opts.dataset(find(opts.dataset(:,4:4)>=opts.starttrain&opts.dataset(:,4:4)<=opts.endtrain),:);
dataset = dataset(:,2:2); %只取当前频道一列
%-----数据集小于序列长度，结束准备-------
if(size(dataset,1)==1||size(dataset,1)<opts.parameters.n_frames)
    return;
end
%--------按频率对频道进行冷热划分--------
[ColdChannelList,HotChannelList,AllChannelList] = ChannelPartition_rnn(dataset,opts.channelFreqPercent);
if opts.channeltype == 0
    channelList = AllChannelList;
elseif opts.channeltype == 1
    channelList = ColdChannelList;
elseif opts.channeltype == 2
    channelList = HotChannelList;
end
%--------获取目标频道对应训练集----------
dataset = getChannelRecord_rnn(dataset,channelList);
% %--------只区分冷1、热2频道--------------
% dataset = myClassify(dataset,ColdChannelList,HotChannelList);
%---进行频道映射并设置网络I/O节点数------
channelHash = hashForRnn(dataset);%返回映射表
dataset = mapChannelForRnn(dataset,channelHash);
trainMaxChar = double(channelHash.Count+1);%输入节点数为频道数+1
opts.parameters.n_input_nodes = trainMaxChar;
opts.parameters.n_output_nodes = trainMaxChar;
%--------按照序列长度重构训练集----------
x = SerializeDataset(dataset,opts.seqlength);
%--训练输入矩阵小于batch_size，结束准备--
if(size(x,1)<opts.parameters.batch_size)
    return ;
end
%---按照序列长度进行词向量转换训练集格式---
opts.train =  word2vecforTrain(x,trainMaxChar);
opts.train_labels=x+1;
opts.n_train=size(opts.train_labels,1);

%%%%%%%%%%%%%%%%%%%%%%%测试集预处理部分%%%%%%%%%%%%%%%%%%%%%%%%
%-------取出第testtrain天测试数据--------
dataset = opts.dataset(find(opts.dataset(:,4:4)==opts.testtrain),:);
dataset = dataset(:,2:2);
%-存放分类后测试样例对应完整测试集的索引-
opts.myOutput.watchorder = getWatchOrder(dataset,channelList); 
%--获取目标频道对应测试集并进行频道映射--
dataset = getChannelRecord_rnn(dataset,channelList);
%-----数据集小于序列长度，结束准备-------
if(size(dataset,1)==1||size(dataset,1)<opts.parameters.n_frames)
    return ;
end
%  %--------只区分冷1、热2频道--------------
% dataset = myClassify(dataset,ColdChannelList,HotChannelList);
%dataset = getChannelRecord_rnn(dataset,ColdChannelList);
dataset = mapChannelForRnn(dataset,channelHash);
%--------按照序列长度重构训练集----------
x = SerializeDataset(dataset,opts.seqlength);
%--测试输入矩阵小于batch_size，结束准备--
if(size(x,1)<opts.parameters.test_batch_size)
    return ;
end
%---按照序列长度进行词向量转换测试集格式---
opts.test =  word2vecforTrain(x,trainMaxChar);
opts.test_labels=x+1;
opts.n_test=size(opts.test_labels,1);

opts.valid = 1; %数据准备完成，设置训练有效

