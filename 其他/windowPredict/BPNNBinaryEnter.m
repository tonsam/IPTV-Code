function BPNNBinaryEnter
%%%%%%%%%%%%%%%
%BPNNԤ����ڣ�����Ƶ����10���ƣ����Ƶ����ʮ����
%%%%%%%%%%%%%%%

%%%�ɱ����%%%%%%%%%%%
startDay = 8;   %ѵ������ʼ���ڣ�����1~7��ѵ�������Դ�8�ſ�ʼ
endDay = 31;    %ѵ���Ľ�������
window1 = 7;    %ѡ���ѵ������
opts.batchsize = 20; %ѵ��batchsize��С
opts.numepochs = 300;   %ѵ������
opts.learningRate = 0.5;    %ѧϰ����
%%%%%%%%%%%%%%%%%%%%%

%������ʼ��
opts.max_char = 155;



s1 = startDay-window1;
t1 = clock;
recomm = BPNNS2(s1,endDay,window1,opts);
tic;
time1 = num2str(etime(clock,t1));
disp(['����ʱ�䣺',time1]);
save('F:\IPTV\result\BPNNS2HotTOP5.mat','recomm','-append');
save('F:\IPTV\result\BPNNS2HotTOP5.mat','time1','-append');
