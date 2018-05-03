function [someOutput,del] = totalRnnPredict(rnnpara,inputFile)
%%%%%%%%%%%%%%%%%%%%%
%�����������壬ʹ��2014.8�����ݣ���3000���û�
%Ԥ���������someOutput.recomm�У�recomm{3}(2,:)��ʾ���û�3�Ƽ�2��Ƶ����׼ȷ�ʣ��Դ����ƣ����������û�δ�ۿ����Ӽ�����Ԥ��������404��ʾ��
%someOutput.watchorder���ÿ�����Լ�(�����䡢��Ƶ����)������������Ӧԭʼ���У��������Լ���������
%someOutput.prediction���ÿ�����Լ�(�����䡢��Ƶ����)�����������Ķ�Ӧÿ���Ƽ����
%someOutput.datasetorder���ÿ�����Լ�ԭʼƵ���ۿ�����
%Ϊ��ֹ��������ֹͣ��ÿ���Ԥ���������ڵ�ǰĿ¼��result�ļ�����
%%%%%%%%%%%%%%%%%%%%%
clear opts;
%������ʼ����optsΪÿһ��ѵ�����ڽ���ʵ��ѵ���Ĳ���
opts.channeltype = rnnpara.channeltype;
opts.channelFreqPercent = rnnpara.channelFreqPercent;
opts.n_epoch = rnnpara.n_epoch;
opts.network_name = rnnpara.network_name;
opts.seqlength = rnnpara.seqlength;
opts.parameters.batch_size = rnnpara.batch_size;
opts.parameters.n_hidden_nodes = rnnpara.n_hidden_nodes;
opts.parameters.n_cell_nodes=rnnpara.n_hidden_nodes; 
opts.inputfiledata = load(inputFile);%����ѵ�������ļ���.txt��

del = [];%��¼����404��ѵ�����ݲ��㣩������豸
h = waitbar(0,'�㣬�ȣ�');
%ö�������û���deviceitr��ʾ��ǰ�û���� ���3000
t = 0;
for deviceitr = rnnpara.UserIDBegin:rnnpara.UserIDEnd
    waitbar(t/(rnnpara.UserIDEnd-rnnpara.UserIDBegin+1),h,['�㣬�ȣ�����ɣ�',num2str(t),'/',num2str(rnnpara.UserIDEnd-rnnpara.UserIDBegin+1)]);
    t = t+1;
    fprintf('��ǰѵ���û����Ϊ%d\n',deviceitr)
    %ȡ���õ�ǰ�û�����µ����м�¼
    
    opts.current_device = deviceitr;
    opts.dataset = opts.inputfiledata(find(opts.inputfiledata(:,1:1)==opts.current_device),:);
    
    someOutput.recomm(t) = {zeros(5,rnnpara.endday)};  %��ʼ��׼ȷ�ʣ�5�������Ƽ�Ƶ������
    
    %ö��ѵ��������ʼ���ڣ��������ڿ�ʼ��Main_Char_RNNΪ����rnn�ĺ���
    for dayitr = rnnpara.startday:rnnpara.endday   
        %ѵ������[opts.start,opts.endtrain-1]
        opts.starttrain =dayitr;   
        opts.endtrain = opts.starttrain+rnnpara.windows-1;
        opts.testtrain = opts.starttrain+rnnpara.windows;

        opts = Main_Char_RNN(opts); %ѵ��
        
        %��ȡ������
        %���ڵ���ۿ���¼������ˣ�����Ԥ�⣬���䵱���Ԥ��������Ϊ404
        if(isempty(opts.results.LastTestEpochError))
            del = [del,deviceitr];
            someOutput.recomm{t}(:,dayitr) = 404; %���첻���Ƽ�
        else
            rt = 1-opts.results.LastTestEpochError;
            someOutput.recomm{t}(:,dayitr) = rt;  %��¼�����Ƽ�׼ȷ�ʣ�������������top1~5
            %someOutput.prediction���ÿ�����Լ�(�����䡢��Ƶ����)�����������Ķ�Ӧÿ���Ƽ����
            someOutput.prediction(t,dayitr) = {1- opts.myOutput.LastMiniBatchError };
            %someOutput.recommchannel���ÿ�����Լ�(�����䡢��Ƶ����)�����������Ķ�Ӧÿ���Ƽ���ѡƵ�����
            someOutput.recommchannel(t,dayitr) = {opts.myOutput.LastMiniBatchRecommchannel};
            someOutput.tprediction(t,dayitr) = {opts.myOutput.AllMiniBatchPrediction };
            %someOutput.watchorder���ÿ�����Լ�(�����䡢��Ƶ����)������������Ӧԭʼ���У��������Լ���������
            someOutput.watchorder(t,dayitr) = {opts.myOutput.watchorder};
            someOutput.datasetorder(t,dayitr) = {opts.myOutput.datasetorder};
        end
    end
   
    %%%%%%%%��ʱ���ѵ������ļ�%%%%%%%%%%
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