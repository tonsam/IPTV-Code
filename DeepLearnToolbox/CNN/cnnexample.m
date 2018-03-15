clear all; close all; clc; 
           
        load mnist_uint8;
        train_x = double(reshape(train_x',28,28,60000))/255;  
        test_x = double(reshape(test_x',28,28,10000))/255;  
        train_y = double(train_y');  
        test_y = double(test_y');  

        
        cnn.layers = {  
            struct('type', 'i') %input layer  
            struct('type', 'c', 'outputmaps', 6, 'kernelsize', 5) %convolution layer  
            struct('type', 's', 'scale', 2) %sub sampling layer  
            struct('type', 'c', 'outputmaps', 12, 'kernelsize', 5) %convolution layer  
            struct('type', 's', 'scale', 2) %subsampling layer  
        };    
% �����cnn�����ø�cnnsetup������ݴ˹���һ��������CNN���磬������  
        cnn = cnnsetup(cnn, train_x, train_y);   
% ѧϰ��  
        opts.alpha = 1;  
% ÿ������һ��batchsize��batch��ѵ����Ҳ����ÿ��batchsize�������͵���һ��Ȩֵ��������  
% �����������������ˣ�������������������˲ŵ���һ��Ȩֵ  
        opts.batchsize = 50;   
% ѵ����������ͬ��������������ѵ����ʱ��  
% 1��ʱ�� 11.41% error  
% 5��ʱ�� 4.2% error  
% 10��ʱ�� 2.73% error  
        opts.numepochs = 1;  
% Ȼ��ʼ��ѵ��������������ʼѵ�����CNN����  
        cnn = cnntrain(cnn, train_x, train_y, opts);    
% Ȼ����ò�������������  
        [er, bad] = cnntest(cnn, test_x, test_y);    
%plot mean squared error  
        %plot(cnn.rL);  
%show test error

    disp([num2str(er*100) '% error']);
    error=er*100;
