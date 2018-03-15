function [recomm] = BPNNS2 (startDay,endDay,window,opts)
%%%%%%
%训练集和测试级的处理，如若用户该天没观看，预测结果存为404
%trainNN1为训练入口
%%%%%%
usedataset = load('F:\IPTV\dataset\maatlabdatasetout10.txt');

t3 = clock;
opts.LastTestEpochError = [];
deviceitr = 1;
recomm.rt1 = [];
recomm.rt2 = [];
recomm.rt3 = [];
del = [];
compareList = [];

for j = 1:300
    dayitr = 1;
    userdataset = usedataset(find(usedataset(:,1:1)==j),:);
    for day = startDay:endDay
        %训练窗口为7天
        s1 = day;
        s2 = day+window;
        %训练集
        if(day+window<=endDay)
            %取得窗口内的训练集
            dataset = userdataset(find(userdataset(:,4:4)>s1-1&userdataset(:,4:4)<s2),:);
            dataset = dataset(:,2:3);
            
            %取得测试集
            testdataset = userdataset(find(userdataset(:,4:4)==s2),:);
            testdataset = testdataset(:,2:3);
            
            if(size(dataset,1) == 0 || size(testdataset,1) == 0) 
                recomm.rt1(deviceitr,dayitr) = 404;
                recomm.rt2(deviceitr,dayitr) = 404;
                recomm.rt3(deviceitr,dayitr) = 404;
                dayitr = dayitr + 1;
                del = [del,deviceitr];
                continue;
            end
            
            %根据频道观看频率决定删除那些频道
            [UseChannel,NNoutput] = FindProbability(dataset(:,2:2));
            dataset = delCoolChannel(dataset,UseChannel);
            %对频道号进行映射，先存储为hash模式
            channelHash = hashTab(dataset(:,2:2));
            
            train = dataset(:,1:1);
            sizeT = size(train,1);
            delT = rem(size(train,1),opts.batchsize);
            train = train(1:sizeT-delT,:);
            if(size(train,1) == 0)
                recomm.rt1(deviceitr,dayitr) = 404;
                recomm.rt2(deviceitr,dayitr) = 404;
                recomm.rt3(deviceitr,dayitr) = 404;
                dayitr = dayitr + 1;
                continue;
            end
            %归一化处理

            [train_x,settings] = mapminmax(train',0,1);
            train_x = train_x';
            trainy = dataset(:,2:2);
            %频道号的hashmap进行映射
            trainy = mapChannel(trainy,channelHash);
            %trainy = cellfun(@str2num, trainy);
            m1 = size(train,1);
            train_y = zeros(m1,NNoutput);
            for i =1:m1
                train_y(i,trainy(i,1))=1;
            end
            comparesta = 1/NNoutput;
            
            
            %测试集处理
            %删除冷门频道
            testdataset = delCoolChannel(testdataset,UseChannel);
            if(size(testdataset,1)==0)
                recomm.rt1(deviceitr,dayitr) = 404;
                recomm.rt2(deviceitr,dayitr) = 404;
                recomm.rt3(deviceitr,dayitr) = 404;
                dayitr = dayitr + 1;
                continue;
            end
            
            test = testdataset(:,1:1);   
            %归一化处理
            test_x = mapminmax('apply',test',settings)';
            testy = testdataset(:,2:2);
            
            %频道映射
            testy = mapChannel(testy,channelHash);
            %testy = cellfun(@str2num, testy);
            m2 = size(test,1);
            test_y = zeros(m2,NNoutput);
            for i =1:m2
                test_y(i,testy(i,1))=1;
            end
            
            opts = trainNN1(train_x,test_x,train_y,test_y,NNoutput,opts);
            recomm.rt1(deviceitr,dayitr) = opts.LastTestEpochError(1);
            recomm.rt2(deviceitr,dayitr) = opts.LastTestEpochError(2);
            recomm.rt3(deviceitr,dayitr) = opts.LastTestEpochError(3);
            recomm.rt4(deviceitr,dayitr) = opts.LastTestEpochError(4);
            recomm.rt5(deviceitr,dayitr) = opts.LastTestEpochError(5);
        end
        dayitr = dayitr + 1;
    end
    
    tic;
    time3 = num2str(etime(clock,t3));
    save('F:\IPTV\result\BPNNS2TOP5HotTEMP2.mat','recomm','-append');
    save('F:\IPTV\result\BPNNS2TOP5HotTEMP2.mat','del','-append');
    save('F:\IPTV\result\BPNNS2TOP5HotTEMP2.mat','time3','-append');
    deviceitr = deviceitr + 1;
    
    
end
