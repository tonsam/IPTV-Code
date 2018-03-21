function [AllRecommMean] = getAllMean5(recomm5)
%求所有（50个）用户的平均准确率
AllRecommMean = [];
temp = getEachUserMean(recomm5.rt1);
AllRecommMean = [AllRecommMean;mean(temp(temp~=404))];
temp = getEachUserMean(recomm5.rt2);
AllRecommMean = [AllRecommMean;mean(temp(temp~=404))];
temp = getEachUserMean(recomm5.rt3);
AllRecommMean = [AllRecommMean;mean(temp(temp~=404))];
temp = getEachUserMean(recomm5.rt4);
AllRecommMean = [AllRecommMean;mean(temp(temp~=404))];
temp = getEachUserMean(recomm5.rt5);
AllRecommMean = [AllRecommMean;mean(temp(temp~=404))];

%set(gca, 'XTickLabel', [2,2.5,3,3.5,4,4.5]);
end


