function enterRnn
%%%%%%%%
%预测入口，结果存放在当前目录下的result内
%%%%%%%%

%%%%%%%%%%可调参数%%%%%%%%%%
rnnpara.channeltype = 2; %训练频道类型，0,不区分，1.冷 2.热
rnnpara.channelFreqPercent = 4.5; %频道划分频率百分比
rnnpara.windows= 7;    %选择的训练窗口
rnnpara.startday = 1;   %第一个训练窗口起始日期，第一次训练为1~window号，window+1号作为第一次测试日期
rnnpara.endday = 31 - rnnpara.windows;   %最后一个训练窗口起始日期，w=7，则为24，31号作为最后一次测试日期
rnnpara.seqlength = 5; %rnn的序列长度
rnnpara.network_name = 'lstm';   %选择的网络'rnn','lstm','gru'
rnnpara.n_epoch = 7;    %训练期数 7
rnnpara.batch_size = 5; %训练时batch_size大小，不可过大
rnnpara.n_hidden_nodes = 30; %网络隐藏层 30


%%%%%%%%%%文件输入输出准备%%%%%%%%%%
inputDir = 'C:\Work\IPTV\IPTV Recommendation\dataset\';%训练集输入所在文件夹
outputDir = 'C:\Work\IPTV\IPTV Recommendation\Result\'; %推荐率结果保存所在文件夹
fileList=dir(fullfile(inputDir));
fileNum = length(fileList);

for channeltype = 1:2
     rnnpara.channeltype = channeltype;
     for fp = 2:0.5:8.5
     rnnpara.channelFreqPercent = fp; 
        %遍历该组数据集里的所有文件
        for  i = 3:fileNum
            inputFile = fullfile(inputDir,fileList(i,1).name);
            if ~isdir(inputFile)
                %%%%%%%%%%初始化%%%%%%%%%%
                tic; %保存当前时间
                t1 = clock;%[year month day hour minute seconds]

                %%%%%%%%%%运行%%%%%%%%%%
                [recomm5,del1] = totalRnnPredict(rnnpara,inputFile);

                %%%%%%%%%%运行结果输出%%%%%%%%%%
                disp(recomm5);
                time5 = num2str(etime(clock,t1));
                disp(['运行时间：',time5]);

                [~,name,~]=fileparts(inputFile);
%                 if rnnpara.channeltype == 0 
%                     name = strcat(name,'ChannelType',num2str(rnnpara.channeltype),'Result.mat');
%                 else
%                     name = strcat(name,'ChannelType',num2str(rnnpara.channeltype),'by',num2str(rnnpara.channelFreqPercent),'%Result.mat');
%                 end
                name = strcat(name,'ChannelType',num2str(rnnpara.channeltype),'by',num2str(rnnpara.channelFreqPercent),'%Result.mat');
             
                outputFile=fullfile(outputDir,name);
                save(outputFile,'recomm5');
                save(outputFile,'time5','-append');
            end 
        end
     end
 end
