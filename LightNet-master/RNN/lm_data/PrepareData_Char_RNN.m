function [ opts ] = PrepareData_Char_RNN( opts )
%max_char=156;   %���е�Ƶ���������ɸģ�
%dataset = cellfun(@str2num,dataset);
%˵����ӳ���������Ƶ���ż�1��������ǰ����Ƶ��������Ϊ1����Ϊ��ʼƵ���йء�
opts.valid = 0;  %����׼��δ��ɣ�����ѵ��Ϊ��Ч�������һ��
%%%%%%%%%%%%%%%%%%%%%%%ѵ����Ԥ������%%%%%%%%%%%%%%%%%%%%%%%%
%-------ȡ���û�ѵ�������ڵ�����---------
dataset = opts.dataset(find(opts.dataset(:,4:4)>=opts.starttrain&opts.dataset(:,4:4)<=opts.endtrain),:);
dataset = dataset(:,2:2); %ֻȡ��ǰƵ��һ��
%-----���ݼ�С�����г��ȣ�����׼��-------
if(size(dataset,1)==1||size(dataset,1)<opts.parameters.n_frames)
    return;
end
%--------��Ƶ�ʶ�Ƶ���������Ȼ���--------
[ColdChannelList,HotChannelList,AllChannelList] = ChannelPartition_rnn(dataset,opts.channelFreqPercent);
if opts.channeltype == 0
    channelList = AllChannelList;
elseif opts.channeltype == 1
    channelList = ColdChannelList;
elseif opts.channeltype == 2
    channelList = HotChannelList;
end
%--------��ȡĿ��Ƶ����Ӧѵ����----------
dataset = getChannelRecord_rnn(dataset,channelList);
% %--------ֻ������1����2Ƶ��--------------
% dataset = myClassify(dataset,ColdChannelList,HotChannelList);
%---����Ƶ��ӳ�䲢��������I/O�ڵ���------
channelHash = hashForRnn(dataset);%����ӳ���
dataset = mapChannelForRnn(dataset,channelHash);
trainMaxChar = double(channelHash.Count+1);%����ڵ���ΪƵ����+1
opts.parameters.n_input_nodes = trainMaxChar;
opts.parameters.n_output_nodes = trainMaxChar;
%--------�������г����ع�ѵ����----------
x = SerializeDataset(dataset,opts.seqlength);
%--ѵ���������С��batch_size������׼��--
if(size(x,1)<opts.parameters.batch_size)
    return ;
end
%---�������г��Ƚ��д�����ת��ѵ������ʽ---
opts.train =  word2vecforTrain(x,trainMaxChar);
opts.train_labels=x+1;
opts.n_train=size(opts.train_labels,1);

%%%%%%%%%%%%%%%%%%%%%%%���Լ�Ԥ������%%%%%%%%%%%%%%%%%%%%%%%%
%-------ȡ����testtrain���������--------
dataset = opts.dataset(find(opts.dataset(:,4:4)==opts.testtrain),:);
dataset = dataset(:,2:2);
%-��ŷ�������������Ӧ�������Լ�������-
opts.myOutput.watchorder = getWatchOrder(dataset,channelList); 
%--��ȡĿ��Ƶ����Ӧ���Լ�������Ƶ��ӳ��--
dataset = getChannelRecord_rnn(dataset,channelList);
%-----���ݼ�С�����г��ȣ�����׼��-------
if(size(dataset,1)==1||size(dataset,1)<opts.parameters.n_frames)
    return ;
end
%  %--------ֻ������1����2Ƶ��--------------
% dataset = myClassify(dataset,ColdChannelList,HotChannelList);
%dataset = getChannelRecord_rnn(dataset,ColdChannelList);
dataset = mapChannelForRnn(dataset,channelHash);
%--------�������г����ع�ѵ����----------
x = SerializeDataset(dataset,opts.seqlength);
%--�����������С��batch_size������׼��--
if(size(x,1)<opts.parameters.test_batch_size)
    return ;
end
%---�������г��Ƚ��д�����ת�����Լ���ʽ---
opts.test =  word2vecforTrain(x,trainMaxChar);
opts.test_labels=x+1;
opts.n_test=size(opts.test_labels,1);

opts.valid = 1; %����׼����ɣ�����ѵ����Ч

