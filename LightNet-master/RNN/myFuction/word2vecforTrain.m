function [ Formatdata  ] = word2vecforTrain( seqRecord ,trainMaxChar )
%返回S(序列长度)个C(频道个数)*L(序列数目)矩阵：C*L*S（论文）
seqRecord_0 = zeros(size(seqRecord,1),1);
%去掉最后一列作为标记，补充前置零（频道1，默认频道）提升效果 , 
train = [seqRecord_0,seqRecord];
train(:,end)=[];
%计算公式为opts.train(trian(x,y),x,y) = opts.train( (y-1)*C*L + C*(x-1) + trian(x,y)+1 )
Formatdata = zeros(trainMaxChar, size(train,1),size(train,2));
Index=train(:)'+1+trainMaxChar*(0:numel(train)-1);%numl取出数组所有元素
Formatdata(Index)=1;
end

