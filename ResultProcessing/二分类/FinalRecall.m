function [ FR,hR,cR  ] = FinalRecall(hotchannelresultPath,coldchannelresultPath,channelFreqPercent,inputFile)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ĞèÒªÑ¡È¡rt¾ØÕó
temp = load(hotchannelresultPath);
rnnpara.hotResult = temp.recomm5.rt4 ;
temp = load(coldchannelresultPath);
rnnpara.coldResult = temp.recomm5.rt4;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rnnpara.channelFP = channelFreqPercent; %ÆµµÀ»®·ÖÆµÂÊ°Ù·Ö±È
rnnpara.windows= 7;    %Ñ¡ÔñµÄÑµÁ·´°¿Ú
rnnpara.startday = 1;   %µÚÒ»¸öÑµÁ·´°¿ÚÆğÊ¼ÈÕÆÚ£¬µÚÒ»´ÎÑµÁ·Îª1~windowºÅ£¬window+1ºÅ×÷ÎªµÚÒ»´Î²âÊÔÈÕÆÚ
rnnpara.endday = 31 - rnnpara.windows;   %×îºóÒ»¸öÑµÁ·´°¿ÚÆğÊ¼ÈÕÆÚ£¬w=7£¬ÔòÎª24£¬31ºÅ×÷Îª×îºóÒ»´Î²âÊÔÈÕÆÚ
rnnpara.seqlength = 5; %rnnµÄĞòÁĞ³¤¶È
rnnpara.inputfiledata = load(inputFile);  %ÑµÁ·Ê±×ÜÊäÈëÊı¾İ
userN = 50; %ĞèÒª¼ÆËãµÄÓÃ»§ÊıÁ¿
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FinalRecall = zeros(userN,rnnpara.endday); %Ô¤·ÖÅäÄÚ´æ
hotR = zeros(userN,rnnpara.endday); %Ô¤·ÖÅäÄÚ´æ
coldR = zeros(userN,rnnpara.endday); %Ô¤·ÖÅäÄÚ´æ
fprintf('µ±Ç°ÎÄ¼şÎªÆµÂÊÎª%fµÄÄÇ¸ö...\n',channelFreqPercent);
for useritr = 1:userN
    rnnpara.dataset = rnnpara.inputfiledata(find(rnnpara.inputfiledata(:,1:1)==useritr),:);
    [tempFR,temphotR,tempcoldR] = getUserFR(rnnpara,useritr);
    FinalRecall(useritr,:) = FinalRecall(useritr,:) + tempFR;
    hotR(useritr,:) = hotR(useritr,:) + temphotR;
    coldR(useritr,:) = coldR(useritr,:) + tempcoldR;
end
FR = getMean(FinalRecall,rnnpara,userN);
hR = getMean(hotR,rnnpara,userN);
cR = getMean(coldR,rnnpara,userN);

end


function [anss] = getMean(tempR,rnnpara,userN)
anssum = 0;
for useritr = 1:userN
    sum = 0;
    i = 0;
    for day = rnnpara.startday:rnnpara.endday
        sum = sum + tempR(useritr,day);
        i =i+1;
    end
    if i>0
        anssum = anssum + sum /i;
    end
end
anss = anssum /userN;
end