function [opts] = rnnloaddata( opts )

max_char=65;

con = database('eventclientchannel','root','root','com.mysql.jdbc.Driver','jdbc:mysql://localhost:3306/eventclientchannel');
sql = 'SELECT ChannelNumber FROM over1800from616to719sdelcoolchannel WHERE DeviceId = ''{C58FD432-804B-47BF-BCA1-F3900B2FEAB3}'' AND (OriginTime BETWEEN ''2014-06-21'' AND ''2014-06-28'') AND DayIndex = 3 ORDER BY OriginTime';
dataset = exec(con,sql);
dataset = fetch(dataset);
dataset = dataset.Data;
dataset = cellfun(@str2num,dataset);

sizet = size(dataset,1);
del = rem(sizet,2);
dataset = dataset(1:sizet-del,:)';
x = reshape(dataset,size(dataset,2)/2,2);
x_0 = zeros(size(x,1),1);
%—µ¡∑ºØ
train = [x_0,x];
train(:,end)=[];
opts.train = zeros(max_char, size(train,1),size(train,2));
Index=x(:)'+1+max_char*[(0:numel(train)-1)];
opts.train(Index)=1;
%—µ¡∑ºØ±Í«©
opts.train_labels(:,3:3)=64;
opts.train_labels=x+1;

opts.n_train=size(opts.train_labels,1);

sql = 'SELECT ChannelNumber FROM over1800from616to719sdelcoolchannel WHERE DeviceId = ''{C58FD432-804B-47BF-BCA1-F3900B2FEAB3}'' AND (OriginTime BETWEEN ''2014-06-28'' AND ''2014-06-29'') DayIndex = 3 ORDER BY OriginTime';
dataset = exec(con,sql);
dataset = fetch(dataset);
dataset = dataset.Data;
dataset = cellfun(@str2num,dataset);

sizet = size(dataset,1);
del = rem(sizet,2);
dataset = dataset(1:sizet-del,:)';
x = reshape(dataset,size(dataset,2)/2,2);
x_0 = zeros(size(x,1),1);
%≤‚ ‘ºØ
test = [x_0,x];
test(:,end)=[];
opts.test = zeros(max_char, size(test,1),size(test,2));
Index=x(:)'+1+max_char*[(0:numel(test)-1)];
opts.test(Index)=1;

opts.test_labels(:,3:3)=64;
opts.test_labels=x+1;

opts.n_test=size(opts.test_labels,1);
