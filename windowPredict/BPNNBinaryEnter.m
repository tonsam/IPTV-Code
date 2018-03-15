function BPNNBinaryEnter
%%%%%%%%%%%%%%%
%BPNN预测入口，输入频道号10进制，输出频道号十进制
%%%%%%%%%%%%%%%

%%%可变参数%%%%%%%%%%%
startDay = 8;   %训练的起始日期，由于1~7号训练，所以从8号开始
endDay = 31;    %训练的结束日期
window1 = 7;    %选择的训练窗口
opts.batchsize = 20; %训练batchsize大小
opts.numepochs = 300;   %训练次数
opts.learningRate = 0.5;    %学习速率
%%%%%%%%%%%%%%%%%%%%%

%参数初始化
opts.max_char = 155;



s1 = startDay-window1;
t1 = clock;
recomm = BPNNS2(s1,endDay,window1,opts);
tic;
time1 = num2str(etime(clock,t1));
disp(['运行时间：',time1]);
save('F:\IPTV\result\BPNNS2HotTOP5.mat','recomm','-append');
save('F:\IPTV\result\BPNNS2HotTOP5.mat','time1','-append');
