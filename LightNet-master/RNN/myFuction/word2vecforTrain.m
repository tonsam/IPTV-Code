function [ Formatdata  ] = word2vecforTrain( seqRecord ,trainMaxChar )
%����S(���г���)��C(Ƶ������)*L(������Ŀ)����C*L*S�����ģ�
seqRecord_0 = zeros(size(seqRecord,1),1);
%ȥ�����һ����Ϊ��ǣ�����ǰ���㣨Ƶ��1��Ĭ��Ƶ��������Ч�� , 
train = [seqRecord_0,seqRecord];
train(:,end)=[];
%���㹫ʽΪopts.train(trian(x,y),x,y) = opts.train( (y-1)*C*L + C*(x-1) + trian(x,y)+1 )
Formatdata = zeros(trainMaxChar, size(train,1),size(train,2));
Index=train(:)'+1+trainMaxChar*(0:numel(train)-1);%numlȡ����������Ԫ��
Formatdata(Index)=1;
end

