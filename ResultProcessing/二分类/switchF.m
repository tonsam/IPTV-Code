function [ anss,A,B] = switchF()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rnnpara.channelFP = 4; %Ƶ������Ƶ�ʰٷֱ�,����ȡ������޹�
rnnpara.windows= 7;    %ѡ���ѵ������
rnnpara.startday = 1;   %��һ��ѵ��������ʼ���ڣ���һ��ѵ��Ϊ1~window�ţ�window+1����Ϊ��һ�β�������
rnnpara.endday = 31 - rnnpara.windows;   %���һ��ѵ��������ʼ���ڣ�w=7����Ϊ24��31����Ϊ���һ�β�������
rnnpara.seqlength = 5; %rnn�����г���
inputFile = 'C:\Work\IPTV\IPTV Recommendation\dataset\Trainingset3000WithDuration[10-3600].txt';
rnnpara.inputfiledata = load(inputFile);  %ѵ��ʱ����������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A = [];
B =[];
for U = 1:50
    valid = 0;    anss = 0;
    rnnpara.dataset = rnnpara.inputfiledata(find(rnnpara.inputfiledata(:,1:1)==U),:);
    for day = rnnpara.startday : rnnpara.endday
        flag = 0;
        %-----����ѵ�����ҳ���ѵ������Ƶ���б�-------
        dataset = rnnpara.dataset(find(rnnpara.dataset(:,4:4)>=day&rnnpara.dataset(:,4:4)<day+rnnpara.windows),:);
        dataset = dataset(:,2:2); %ֻȡ��ǰƵ��һ��
        if size(dataset,1)==0
            continue;
        end
        [cold,hot,~] = ChannelPartition_rnn(dataset,rnnpara.channelFP);
        %-----ȡ�����Ե������ݼ���Ƶ���������Ƽ�����-------
        Alldataset = rnnpara.dataset(find(rnnpara.dataset(:,4:4)==day+rnnpara.windows),:);
        Alldataset = Alldataset(:,2:2);
        if size(Alldataset,1)>0
            for i = 1:size(cold,1)
                 index = Alldataset==cold(i);
                Alldataset(index) = 0; 
            end
             for i = 1:size(hot,1)
                index = Alldataset==hot(i);
                Alldataset(index) = 1; 
             end
            for i = 1:size(Alldataset,1)-1;
                if Alldataset(i)~=Alldataset(i+1)
                    flag = flag + 1;
                end
            end
            anss = anss+flag/size(Alldataset,1);
            valid = valid +1;
        end
    end
            anss = anss/valid;
            A = [A;anss];
            B = [B;1-anss];
            fprintf('---%d-%f--\n',U,anss);
end
end


