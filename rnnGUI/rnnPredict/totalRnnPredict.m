function [someOutput,del] = totalRnnPredict(rnnpara,inputFile)
%%%%%%%%%%%%%%%%%%%%%
%滑动窗口主体，使用2014.8的数据，共3000个用户
%预测结果存放在someOutput.recomm中，recomm{3}(2,:)表示给用户3推荐2个频道的准确率，以此类推，如若该天用户未观看电视级即无预测结果，以404表示。
%someOutput.watchorder存放每个测试集(区分冷、热频道后)中所有样例对应原始序列（完整测试集）的索引
%someOutput.prediction存放每个测试集(区分冷、热频道后)中所有样例的对应每次推荐结果
%someOutput.datasetorder存放每个测试集原始频道观看序列
%为防止程序意外停止，每天的预测结果会存放在当前目录下result文件夹内
%%%%%%%%%%%%%%%%%%%%%
clear opts;
%参数初始化：opts为每一次训练窗口进行实际训练的参数
opts.channeltype = rnnpara.channeltype;
opts.channelFreqPercent = rnnpara.channelFreqPercent;
opts.n_epoch = rnnpara.n_epoch;
opts.network_name = rnnpara.network_name;
opts.seqlength = rnnpara.seqlength;
opts.parameters.batch_size = rnnpara.batch_size;
opts.parameters.n_hidden_nodes = rnnpara.n_hidden_nodes;
opts.parameters.n_cell_nodes=rnnpara.n_hidden_nodes; 
opts.inputfiledata = load(inputFile);%加载训练数据文件（.txt）

del = [];%记录存在404（训练数据不足）结果的设备
h = waitbar(0,'算，等！');
%枚举所有用户，deviceitr表示当前用户编号 最多3000
t = 0;
for deviceitr = rnnpara.UserIDBegin:rnnpara.UserIDEnd
    waitbar(t/(rnnpara.UserIDEnd-rnnpara.UserIDBegin+1),h,['算，等！已完成：',num2str(t),'/',num2str(rnnpara.UserIDEnd-rnnpara.UserIDBegin+1)]);
    t = t+1;
    fprintf('当前训练用户编号为%d\n',deviceitr)
    %取出该当前用户这个月的所有记录
    
    opts.current_device = deviceitr;
    opts.dataset = opts.inputfiledata(find(opts.inputfiledata(:,1:1)==opts.current_device),:);
    
    someOutput.recomm(t) = {zeros(5,rnnpara.endday)};  %初始化准确率，5代表单次推荐频道个数
    
    %枚举训练窗口起始日期，滑动窗口开始，Main_Char_RNN为进入rnn的函数
    for dayitr = rnnpara.startday:rnnpara.endday   
        %训练窗口[opts.start,opts.endtrain-1]
        opts.starttrain =dayitr;   
        opts.endtrain = opts.starttrain+rnnpara.windows-1;
        opts.testtrain = opts.starttrain+rnnpara.windows;

        opts = Main_Char_RNN(opts); %训练
        
        %获取输出结果
        %对于当天观看记录不足的人，不予预测，将其当天的预测率设置为404
        if(isempty(opts.results.LastTestEpochError))
            del = [del,deviceitr];
            someOutput.recomm{t}(:,dayitr) = 404; %当天不予推荐
        else
            rt = 1-opts.results.LastTestEpochError;
            someOutput.recomm{t}(:,dayitr) = rt;  %记录当天推荐准确率（列向量）包括top1~5
            %someOutput.prediction存放每个测试集(区分冷、热频道后)中所有样例的对应每次推荐结果
            someOutput.prediction(t,dayitr) = {1- opts.myOutput.LastMiniBatchError };
            %someOutput.recommchannel存放每个测试集(区分冷、热频道后)中所有样例的对应每次推荐候选频道结果
            someOutput.recommchannel(t,dayitr) = {opts.myOutput.LastMiniBatchRecommchannel};
            someOutput.tprediction(t,dayitr) = {opts.myOutput.AllMiniBatchPrediction };
            %someOutput.watchorder存放每个测试集(区分冷、热频道后)中所有样例对应原始序列（完整测试集）的索引
            someOutput.watchorder(t,dayitr) = {opts.myOutput.watchorder};
            someOutput.datasetorder(t,dayitr) = {opts.myOutput.datasetorder};
        end
    end
   
    %%%%%%%%临时存放训练结果文件%%%%%%%%%%
%     [~,name,~]=fileparts(inputFile);
%     name = strcat(name,'Temp.mat');
%     outputFile=fullfile('C:\Work\IPTV\IPTV Recommendation\Result\',name);
%     if ~exist(outputFile,'file') 
%         save(outputFile,'someOutput');
%     end
%     save(outputFile,'someOutput','-append');
%     save(outputFile,'del','-append');
end
close(h);