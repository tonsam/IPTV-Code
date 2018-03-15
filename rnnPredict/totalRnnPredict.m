function [recomm,del] = totalRnnPredict(rnnpara,inputFile)
%%%%%%%%%%%%%%%%%%%%%
%�����������壬ʹ��2014.8�����ݣ���3000���û�
%Ԥ���������recomm�У�recomm.rt1��ʾ�Ƽ�1��Ƶ����׼ȷ�ʣ��Դ����ƣ����������û�δ�ۿ����Ӽ�����Ԥ��������404��ʾ��
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
opts.parameters.n_cell_nodes=rnnpara.n_hidden_nodes; %��
opts.usedataset = load(inputFile);%����ѵ�������ļ���.txt��

del = [];%��¼����404��ѵ�����ݲ��㣩������豸
%h = waitbar(0,'�㣬�ȣ�');
%ö�������û���deviceitr��ʾ��ǰ�û���� ���3000
for deviceitr = 1:100  
    %waitbar((3000-deviceitr)/3000);
    fprintf('��ǰѵ���û����Ϊ%d\n',deviceitr)
    %ȡ���õ�ǰ�û�����µ����м�¼
    opts.current_device = deviceitr;
    opts.dataset = opts.usedataset(find(opts.usedataset(:,1:1)==opts.current_device),:);
    
    %ö��ѵ��������ʼ���ڣ��������ڿ�ʼ��Main_Char_RNNΪ����rnn�ĺ���
    for dayitr = rnnpara.startday:rnnpara.endday   
        %ѵ������[opts.start,opts.endtrain-1]
        opts.start =dayitr;   
        opts.endtrain = opts.start+rnnpara.windows-1;
        opts.testtrain = opts.start+rnnpara.windows;

        opts = Main_Char_RNN(opts); %ѵ��������ѵ�����
        
        %���ڵ���ۿ���¼Ϊ0���ˣ�����Ԥ�⣬���䵱���Ԥ��������Ϊ404
        if(isempty(opts.results.LastTestEpochError))
            del = [del,deviceitr];
            recomm.rt1(deviceitr,dayitr) = 404;
            recomm.rt2(deviceitr,dayitr) = 404;
            recomm.rt3(deviceitr,dayitr) = 404;
            %-----��top4,5
            recomm.rt4(deviceitr,dayitr) = 404;
            recomm.rt5(deviceitr,dayitr) = 404;
            %--------------end
        else
            rt = 1-opts.results.LastTestEpochError;
            recomm.rt1(deviceitr,dayitr) = rt(1);
            recomm.rt2(deviceitr,dayitr) = rt(2);
            recomm.rt3(deviceitr,dayitr) = rt(3);
            %-----��top4,5
            recomm.rt4(deviceitr,dayitr) = rt(4);
            recomm.rt5(deviceitr,dayitr) = rt(5);
            %--------------end
        end
    end
    
    %%%%%%%%��ʱ���ѵ������ļ�%%%%%%%%%%
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