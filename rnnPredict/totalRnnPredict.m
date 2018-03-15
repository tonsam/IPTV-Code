function [recomm,del] = totalRnnPredict(rnnpara,inputFile)
%%%%%%%%%%%%%%%%%%%%%
%滑动窗口主体，使用2014.8的数据，共3000个用户
%预测结果存放在recomm中，recomm.rt1表示推荐1个频道的准确率，以此类推，如若该天用户未观看电视级即无预测结果，以404表示。
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
opts.parameters.n_cell_nodes=rnnpara.n_hidden_nodes; %？
opts.usedataset = load(inputFile);%加载训练数据文件（.txt）

del = [];%记录存在404（训练数据不足）结果的设备
%h = waitbar(0,'算，等！');
%枚举所有用户，deviceitr表示当前用户编号 最多3000
for deviceitr = 1:100  
    %waitbar((3000-deviceitr)/3000);
    fprintf('当前训练用户编号为%d\n',deviceitr)
    %取出该当前用户这个月的所有记录
    opts.current_device = deviceitr;
    opts.dataset = opts.usedataset(find(opts.usedataset(:,1:1)==opts.current_device),:);
    
    %枚举训练窗口起始日期，滑动窗口开始，Main_Char_RNN为进入rnn的函数
    for dayitr = rnnpara.startday:rnnpara.endday   
        %训练窗口[opts.start,opts.endtrain-1]
        opts.start =dayitr;   
        opts.endtrain = opts.start+rnnpara.windows-1;
        opts.testtrain = opts.start+rnnpara.windows;

        opts = Main_Char_RNN(opts); %训练并返回训练结果
        
        %对于当天观看记录为0的人，不予预测，将其当天的预测率设置为404
        if(isempty(opts.results.LastTestEpochError))
            del = [del,deviceitr];
            recomm.rt1(deviceitr,dayitr) = 404;
            recomm.rt2(deviceitr,dayitr) = 404;
            recomm.rt3(deviceitr,dayitr) = 404;
            %-----加top4,5
            recomm.rt4(deviceitr,dayitr) = 404;
            recomm.rt5(deviceitr,dayitr) = 404;
            %--------------end
        else
            rt = 1-opts.results.LastTestEpochError;
            recomm.rt1(deviceitr,dayitr) = rt(1);
            recomm.rt2(deviceitr,dayitr) = rt(2);
            recomm.rt3(deviceitr,dayitr) = rt(3);
            %-----加top4,5
            recomm.rt4(deviceitr,dayitr) = rt(4);
            recomm.rt5(deviceitr,dayitr) = rt(5);
            %--------------end
        end
    end
    
    %%%%%%%%临时存放训练结果文件%%%%%%%%%%
    [~,name,~]=fileparts(inputFile);
    name = strcat(name,'Temp.mat');
    outputFile=fullfile('C:\Work\IPTV\IPTV Recommendation\Result\',name);
    if ~exist(outputFile,'file') 
        save(outputFile,'recomm');
    end
    save(outputFile,'recomm','-append');
    save(outputFile,'del','-append');
    % save('C:\Work\IPTV\IPTV Recommendation\Result\3000usrAutoColdchannelTemp.mat','del','-append');
end
% close(h);