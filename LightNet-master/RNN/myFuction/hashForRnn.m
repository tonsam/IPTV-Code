function [channelHash]= hashForRnn(channelnumber)
%channelnumber = cellfun(@str2num, channelnumber);
uniquec = unique(channelnumber);%ȡ����a�Ĳ��ظ�Ԫ�ع��ɵ�����
channelHash = containers.Map;% ��������һ��ӳ���������
for i = 1:size(uniquec,1)
    channelHash(num2str(uniquec(i)))=i;%ԭƵ��Ϊkey(TypeΪ'char')����Ƶ��Ϊvalue('any')
end
