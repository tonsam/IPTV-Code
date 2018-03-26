function [ Alldataset ] = myClassify( Alldataset ,cold,hot )
if size(Alldataset,1)>0
    for i = 1:size(cold,1)
         index = Alldataset==cold(i);
        Alldataset(index) = 0; 
    end
     for i = 1:size(hot,1)
        index = Alldataset==hot(i);
        Alldataset(index) = 1; 
     end

end

