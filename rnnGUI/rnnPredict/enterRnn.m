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
rnnpara.channeltype = myGUIdata.channeltype; %ѵ��Ƶ�����ͣ�0,�����֣�1.�� 2.��
rnnpara.channelFreqPercent = myGUIdata.channelFreqPercent; %Ƶ������Ƶ�ʰٷֱ�
rnnpara.n_hidden_nodes = myGUIdata.n_hidden_nodes; %�������ز� 30

rnnpara.startday = 1;   %��һ��ѵ��������ʼ���ڣ���һ��ѵ��Ϊ1~window�ţ�window+1����Ϊ��һ�β�������
rnnpara.endday = 31 - rnnpara.windows;   %���һ��ѵ��������ʼ���ڣ�w=7����Ϊ24��31����Ϊ���һ�β�������

%%%%%%%%%%�ļ��������׼��%%%%%%%%%%
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
        [someOutput,~] = totalRnnPredict(rnnpara,inputFile);
        time5 = num2str(etime(clock,t1));
        %%%%%%%%%%���н�����%%%%%%%%%%
        
        [~,name,~]=fileparts(inputFile);
        %name = strcat(name,'ChannelType',num2str(rnnpara.channeltype),'by',num2str(rnnpara.channelFreqPercent),'%Recomm.mat');
        name = strcat(name,'tempGUIVersion2.mat');
        outputFile=fullfile(outputDir,name);
        
        myGUIdata.inputFile = inputFile;
        myGUIdata.outputFile = outputFile;
        save(outputFile,'myGUIdata');
        save(outputFile,'someOutput','-append');
        save(outputFile,'time5','-append');
        disp(myGUIdata);
        disp(someOutput);
        disp(['����ʱ�䣺',time5]);
    end 
end