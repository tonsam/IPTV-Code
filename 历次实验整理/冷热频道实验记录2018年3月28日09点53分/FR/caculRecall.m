allRecall = zeros(3,14);
[ans2,hR2,cR2] = FinalRecall('C:\Work\IPTV\IPTV Recommendation\Result\频道二分类阈值实验结果\Trainingset3000WithDuration[10-3600]ChannelType2by2%Result.mat','C:\Work\IPTV\IPTV Recommendation\Result\频道二分类阈值实验结果\Trainingset3000WithDuration[10-3600]ChannelType1by2%Result.mat',2,'C:\Work\IPTV\IPTV Recommendation\dataset\Trainingset3000WithDuration[10-3600].txt');
allRecall(:,1) = allRecall(:,1) + [ans2,hR2,cR2]';
[ans25,hR25,cR25] = FinalRecall('C:\Work\IPTV\IPTV Recommendation\Result\频道二分类阈值实验结果\Trainingset3000WithDuration[10-3600]ChannelType2by2.5%Result.mat','C:\Work\IPTV\IPTV Recommendation\Result\频道二分类阈值实验结果\Trainingset3000WithDuration[10-3600]ChannelType1by2.5%Result.mat',2.5,'C:\Work\IPTV\IPTV Recommendation\dataset\Trainingset3000WithDuration[10-3600].txt');
allRecall(:,2) = allRecall(:,2) + [ans25,hR25,cR25]';
[ans3,hR3,cR3] = FinalRecall('C:\Work\IPTV\IPTV Recommendation\Result\频道二分类阈值实验结果\Trainingset3000WithDuration[10-3600]ChannelType2by3%Result.mat','C:\Work\IPTV\IPTV Recommendation\Result\频道二分类阈值实验结果\Trainingset3000WithDuration[10-3600]ChannelType1by3%Result.mat',3,'C:\Work\IPTV\IPTV Recommendation\dataset\Trainingset3000WithDuration[10-3600].txt');
allRecall(:,3) = allRecall(:,3) + [ans3,hR3,cR3]';
[ans35,hR35,cR35]= FinalRecall('C:\Work\IPTV\IPTV Recommendation\Result\频道二分类阈值实验结果\Trainingset3000WithDuration[10-3600]ChannelType2by3.5%Result.mat','C:\Work\IPTV\IPTV Recommendation\Result\频道二分类阈值实验结果\Trainingset3000WithDuration[10-3600]ChannelType1by3.5%Result.mat',3.5,'C:\Work\IPTV\IPTV Recommendation\dataset\Trainingset3000WithDuration[10-3600].txt');
allRecall(:,4) = allRecall(:,4) + [ans35,hR35,cR35]';
[ans4,hR4,cR4]= FinalRecall('C:\Work\IPTV\IPTV Recommendation\Result\频道二分类阈值实验结果\Trainingset3000WithDuration[10-3600]ChannelType2by4%Result.mat','C:\Work\IPTV\IPTV Recommendation\Result\频道二分类阈值实验结果\Trainingset3000WithDuration[10-3600]ChannelType1by4%Result.mat',4,'C:\Work\IPTV\IPTV Recommendation\dataset\Trainingset3000WithDuration[10-3600].txt');
allRecall(:,5) = allRecall(:,5) + [ans4,hR4,cR4]';
[ans45,hR45,cR45]= FinalRecall('C:\Work\IPTV\IPTV Recommendation\Result\频道二分类阈值实验结果\Trainingset3000WithDuration[10-3600]ChannelType2by4.5%Result.mat','C:\Work\IPTV\IPTV Recommendation\Result\频道二分类阈值实验结果\Trainingset3000WithDuration[10-3600]ChannelType1by4.5%Result.mat',4.5,'C:\Work\IPTV\IPTV Recommendation\dataset\Trainingset3000WithDuration[10-3600].txt');
allRecall(:,6) = allRecall(:,6) + [ans45,hR45,cR45]';
[ans5,hR5,cR5]= FinalRecall('C:\Work\IPTV\IPTV Recommendation\Result\频道二分类阈值实验结果\Trainingset3000WithDuration[10-3600]ChannelType2by5%Result.mat','C:\Work\IPTV\IPTV Recommendation\Result\频道二分类阈值实验结果\Trainingset3000WithDuration[10-3600]ChannelType1by5%Result.mat',5,'C:\Work\IPTV\IPTV Recommendation\dataset\Trainingset3000WithDuration[10-3600].txt');
allRecall(:,7) = allRecall(:,7) + [ans5,hR5,cR5]';
[ans55,hR55,cR55]= FinalRecall('C:\Work\IPTV\IPTV Recommendation\Result\频道二分类阈值实验结果\Trainingset3000WithDuration[10-3600]ChannelType2by5.5%Result.mat','C:\Work\IPTV\IPTV Recommendation\Result\频道二分类阈值实验结果\Trainingset3000WithDuration[10-3600]ChannelType1by5.5%Result.mat',5.5,'C:\Work\IPTV\IPTV Recommendation\dataset\Trainingset3000WithDuration[10-3600].txt');
allRecall(:,8) = allRecall(:,8) + [ans55,hR55,cR55]';
[ans6,hR6,cR6]= FinalRecall('C:\Work\IPTV\IPTV Recommendation\Result\频道二分类阈值实验结果\Trainingset3000WithDuration[10-3600]ChannelType2by6%Result.mat','C:\Work\IPTV\IPTV Recommendation\Result\频道二分类阈值实验结果\Trainingset3000WithDuration[10-3600]ChannelType1by6%Result.mat',6,'C:\Work\IPTV\IPTV Recommendation\dataset\Trainingset3000WithDuration[10-3600].txt');
allRecall(:,9) = allRecall(:,9) + [ans6,hR6,cR6]';
[ans65,hR65,cR65]= FinalRecall('C:\Work\IPTV\IPTV Recommendation\Result\频道二分类阈值实验结果\Trainingset3000WithDuration[10-3600]ChannelType2by6.5%Result.mat','C:\Work\IPTV\IPTV Recommendation\Result\频道二分类阈值实验结果\Trainingset3000WithDuration[10-3600]ChannelType1by6.5%Result.mat',6.5,'C:\Work\IPTV\IPTV Recommendation\dataset\Trainingset3000WithDuration[10-3600].txt');
allRecall(:,10) = allRecall(:,10) + [ans65,hR65,cR65]';
[ans7,hR7,cR7]= FinalRecall('C:\Work\IPTV\IPTV Recommendation\Result\频道二分类阈值实验结果\Trainingset3000WithDuration[10-3600]ChannelType2by7%Result.mat','C:\Work\IPTV\IPTV Recommendation\Result\频道二分类阈值实验结果\Trainingset3000WithDuration[10-3600]ChannelType1by7%Result.mat',7,'C:\Work\IPTV\IPTV Recommendation\dataset\Trainingset3000WithDuration[10-3600].txt');
allRecall(:,11) = allRecall(:,11) + [ans7,hR7,cR7]';
[ans75,hR75,cR75] = FinalRecall('C:\Work\IPTV\IPTV Recommendation\Result\频道二分类阈值实验结果\Trainingset3000WithDuration[10-3600]ChannelType2by7.5%Result.mat','C:\Work\IPTV\IPTV Recommendation\Result\频道二分类阈值实验结果\Trainingset3000WithDuration[10-3600]ChannelType1by7.5%Result.mat',7.5,'C:\Work\IPTV\IPTV Recommendation\dataset\Trainingset3000WithDuration[10-3600].txt');
allRecall(:,12) = allRecall(:,12) +[ans75,hR75,cR75]';
[ans8,hR8,cR8]= FinalRecall('C:\Work\IPTV\IPTV Recommendation\Result\频道二分类阈值实验结果\Trainingset3000WithDuration[10-3600]ChannelType2by8%Result.mat','C:\Work\IPTV\IPTV Recommendation\Result\频道二分类阈值实验结果\Trainingset3000WithDuration[10-3600]ChannelType1by8%Result.mat',8,'C:\Work\IPTV\IPTV Recommendation\dataset\Trainingset3000WithDuration[10-3600].txt');
allRecall(:,13) = allRecall(:,13) + [ans8,hR8,cR8]';
[ans85,hR85,cR85]= FinalRecall('C:\Work\IPTV\IPTV Recommendation\Result\频道二分类阈值实验结果\Trainingset3000WithDuration[10-3600]ChannelType2by8.5%Result.mat','C:\Work\IPTV\IPTV Recommendation\Result\频道二分类阈值实验结果\Trainingset3000WithDuration[10-3600]ChannelType1by8.5%Result.mat',8.5,'C:\Work\IPTV\IPTV Recommendation\dataset\Trainingset3000WithDuration[10-3600].txt');
allRecall(:,14) = allRecall(:,14) + [ans85,hR85,cR85]';




