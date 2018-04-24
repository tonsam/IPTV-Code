function [outputFile] = enterRnn(myGUIdata)
%%%%%%%%
%预测入口，结果存放在当前目录下的result内
%%%%%%%%

%%%%%%%%%%GUI输入%%%%%%%%%%
inputDir = myGUIdata.inputDir;%'C:\Work\IPTV\IPTV Recommendation\dataset\'%训练集输入所在文件夹
outputDir = myGUIdata.outputDir;%'C:\Work\IPTV\IPTV Recommendation\Result\'; %推荐率结果保存所在文件夹
rnnpara.windows= myGUIdata.windows;    %选择的训练窗口7
rnnpara.seqlength = myGUIdata.seqlength; %rnn的序列长度5
rnnpara.network_name = myGUIdata.network_name;   %选择的网络'rnn','lstm','gru'
rnnpara.n_epoch = myGUIdata.n_epoch;    %训练期数 7
rnnpara.batch_size = myGUIdata.batch_size;  %训练时batch_size大小5，不可过大
rnnpara.UserIDBegin = myGUIdata.UserIDBegin; 
rnnpara.UserIDEnd = myGUIdata.UserIDEnd;

%%%%%%%%%%可调参数%%%%%%%%%%
rnnpara.channeltype = 0; %训练频道类型，0,不区分，1.冷 2.热
rnnpara.channelFreqPercent = 4; %频道划分频率百分比
rnnpara.startday = 1;   %第一个训练窗口起始日期，第一次训练为1~window号，window+1号作为第一次测试日期
rnnpara.endday = 31 - rnnpara.windows;   %最后一个训练窗口起始日期，w=7，则为24，31号作为最后一次测试日期
rnnpara.n_hidden_nodes = 30; %网络隐藏层 30

%%%%%%%%%%文件输入输出准备%%%%%%%%%%
% outputFileList={};
fileList=dir(fullfile(inputDir));
fileNum = length(fileList);
%遍历该组数据集里的所有文件
for  i = 3:fileNum
    inputFile = fullfile(inputDir,fileList(i,1).name);
    if ~isdir(inputFile)
        %%%%%%%%%%初始化%%%%%%%%%%
        tic; %保存当前时间
        t1 = clock;%[year month day hour minute seconds]

        %%%%%%%%%%运行%%%%%%%%%%
        [someOutput,del1] = totalRnnPredict(rnnpara,inputFile);

        %%%%%%%%%%运行结果输出%%%%%%%%%%
        disp(someOutput);
        time5 = num2str(etime(clock,t1));
        disp(['运行时间：',time5]);

        [~,name,~]=fileparts(inputFile);
        %name = strcat(name,'ChannelType',num2str(rnnpara.channeltype),'by',num2str(rnnpara.channelFreqPercent),'%Recomm.mat');
        name = strcat(name,'tempGUI.mat');
        outputFile=fullfile(outputDir,name);
        save(outputFile,'someOutput');
        save(outputFile,'time5','-append');
%         outputFileList = {outputFileList,outputFile};
    end 
end

