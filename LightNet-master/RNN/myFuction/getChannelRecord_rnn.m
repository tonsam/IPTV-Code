function [dataset] = getChannelRecord_rnn(dataset,channelList)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��dataset��ȡchannelList�е�Ƶ���ۿ���¼
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%diff���channelList���Ƶ���б�
diff = setdiff(dataset,channelList); % c = setdiff(A, B) ������A���У���B��û�е�ֵ��������������������򷵻�
%ȥ��diffƵ���б�ļ�¼
for delc = diff'
    index = dataset==delc;
    dataset(index,:)=[];
end