function enterRnn
%%%%%%%%
%Ԥ����ڣ��������ڵ�ǰĿ¼�µ�result��
%%%%%%%%

%%%%%%%%%%�ɵ�����%%%%%%%%%%
rnnpara.channeltype = 2; %ѵ��Ƶ�����ͣ�0,�����֣�1.�� 2.��
rnnpara.channelFreqPercent = 4.5; %Ƶ������Ƶ�ʰٷֱ�
rnnpara.windows= 7;    %ѡ���ѵ������
rnnpara.startday = 1;   %��һ��ѵ��������ʼ���ڣ���һ��ѵ��Ϊ1~window�ţ�window+1����Ϊ��һ�β�������
rnnpara.endday = 31 - rnnpara.windows;   %���һ��ѵ��������ʼ���ڣ�w=7����Ϊ24��31����Ϊ���һ�β�������
rnnpara.seqlength = 5; %rnn�����г���
rnnpara.network_name = 'lstm';   %ѡ�������'rnn','lstm','gru'
rnnpara.n_epoch = 7;    %ѵ������ 7
rnnpara.batch_size = 5; %ѵ��ʱbatch_size��С�����ɹ���
rnnpara.n_hidden_nodes = 30; %�������ز� 30


%%%%%%%%%%�ļ��������׼��%%%%%%%%%%
inputDir = 'C:\Work\IPTV\IPTV Recommendation\dataset\';%ѵ�������������ļ���
outputDir = 'C:\Work\IPTV\IPTV Recommendation\Result\'; %�Ƽ��ʽ�����������ļ���
fileList=dir(fullfile(inputDir));
fileNum = length(fileList);

for channeltype = 1:2
     rnnpara.channeltype = channeltype;
     for fp = 2:0.5:8.5
     rnnpara.channelFreqPercent = fp; 
        %�����������ݼ���������ļ�
        for  i = 3:fileNum
            inputFile = fullfile(inputDir,fileList(i,1).name);
            if ~isdir(inputFile)
                %%%%%%%%%%��ʼ��%%%%%%%%%%
                tic; %���浱ǰʱ��
                t1 = clock;%[year month day hour minute seconds]

                %%%%%%%%%%����%%%%%%%%%%
                [recomm5,del1] = totalRnnPredict(rnnpara,inputFile);

                %%%%%%%%%%���н�����%%%%%%%%%%
                disp(recomm5);
                time5 = num2str(etime(clock,t1));
                disp(['����ʱ�䣺',time5]);

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
