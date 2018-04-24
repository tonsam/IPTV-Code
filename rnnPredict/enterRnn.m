function [outputFile] = enterRnn(myGUIdata)
%%%%%%%%
%Ԥ����ڣ��������ڵ�ǰĿ¼�µ�result��
%%%%%%%%

%%%%%%%%%%GUI����%%%%%%%%%%
inputDir = myGUIdata.inputDir;%'C:\Work\IPTV\IPTV Recommendation\dataset\'%ѵ�������������ļ���
outputDir = myGUIdata.outputDir;%'C:\Work\IPTV\IPTV Recommendation\Result\'; %�Ƽ��ʽ�����������ļ���
rnnpara.windows= myGUIdata.windows;    %ѡ���ѵ������7
rnnpara.seqlength = myGUIdata.seqlength; %rnn�����г���5
rnnpara.network_name = myGUIdata.network_name;   %ѡ�������'rnn','lstm','gru'
rnnpara.n_epoch = myGUIdata.n_epoch;    %ѵ������ 7
rnnpara.batch_size = myGUIdata.batch_size;  %ѵ��ʱbatch_size��С5�����ɹ���
rnnpara.UserIDBegin = myGUIdata.UserIDBegin; 
rnnpara.UserIDEnd = myGUIdata.UserIDEnd;

%%%%%%%%%%�ɵ�����%%%%%%%%%%
rnnpara.channeltype = 0; %ѵ��Ƶ�����ͣ�0,�����֣�1.�� 2.��
rnnpara.channelFreqPercent = 4; %Ƶ������Ƶ�ʰٷֱ�
rnnpara.startday = 1;   %��һ��ѵ��������ʼ���ڣ���һ��ѵ��Ϊ1~window�ţ�window+1����Ϊ��һ�β�������
rnnpara.endday = 31 - rnnpara.windows;   %���һ��ѵ��������ʼ���ڣ�w=7����Ϊ24��31����Ϊ���һ�β�������
rnnpara.n_hidden_nodes = 30; %�������ز� 30

%%%%%%%%%%�ļ��������׼��%%%%%%%%%%
% outputFileList={};
fileList=dir(fullfile(inputDir));
fileNum = length(fileList);
%�����������ݼ���������ļ�
for  i = 3:fileNum
    inputFile = fullfile(inputDir,fileList(i,1).name);
    if ~isdir(inputFile)
        %%%%%%%%%%��ʼ��%%%%%%%%%%
        tic; %���浱ǰʱ��
        t1 = clock;%[year month day hour minute seconds]

        %%%%%%%%%%����%%%%%%%%%%
        [someOutput,del1] = totalRnnPredict(rnnpara,inputFile);

        %%%%%%%%%%���н�����%%%%%%%%%%
        disp(someOutput);
        time5 = num2str(etime(clock,t1));
        disp(['����ʱ�䣺',time5]);

        [~,name,~]=fileparts(inputFile);
        %name = strcat(name,'ChannelType',num2str(rnnpara.channeltype),'by',num2str(rnnpara.channelFreqPercent),'%Recomm.mat');
        name = strcat(name,'tempGUI.mat');
        outputFile=fullfile(outputDir,name);
        save(outputFile,'someOutput');
        save(outputFile,'time5','-append');
%         outputFileList = {outputFileList,outputFile};
    end 
end

