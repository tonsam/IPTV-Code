function [ x ] = SerializeDataset( dataset ,seqlength )
dataset = dataset';%列变行
sizet = size(dataset,2);
x = zeros(sizet-seqlength+1,seqlength); %预分配内存
for i = 1:sizet-seqlength+1
    x(i,:) = x(i,:)+ dataset(i:i+seqlength-1);
end
end

