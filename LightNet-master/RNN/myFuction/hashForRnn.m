function [channelHash,channelHashBack]= hashForRnn(channelnumber)
%channelnumber = cellfun(@str2num, channelnumber);
uniquec = unique(channelnumber);%ȡ����a�Ĳ��ظ�Ԫ�ع��ɵ�����
channelHash = containers.Map;% ��������һ��ӳ���������
channelHashBack = containers.Map;
for i = 1:size(uniquec,1)
    channelHash(num2str(uniquec(i)))=i;%ԭƵ��Ϊkey(TypeΪ'char')����Ƶ��Ϊvalue('any')
    channelHashBack(num2str(i+1)) =  uniquec(i); %ԭƵ��Ϊvalue(TypeΪ'any')����Ƶ��Ϊkey('any'),���ڻ�ԭӳ�䣬
    %+1��Ԥ����Ƶ��1���ΪĬ��ǰ��Ƶ���������������ת��������
end
channelHashBack(num2str(1)) =  0;
% disp(channelHashBack);
