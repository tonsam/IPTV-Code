function [ x ] = SerializeDataset( dataset ,seqlength )
dataset = dataset';%�б���
sizet = size(dataset,2);
x = zeros(sizet-seqlength,seqlength); %Ԥ�����ڴ�
for i = 1:sizet-seqlength
    x(i,:) = x(i,:)+ dataset(i:i+seqlength-1);
end
end

