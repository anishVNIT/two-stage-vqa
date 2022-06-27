
function normalized_hist=normalized_histogram(I)
count=zeros(1,256);
P=0;
for x=1:256
for i=1:size(I,1)
    for j=1:size(I,2)
    if I(i,j)==P
        count(x)=count(x)+1;
    end
    end
end
P=P+1;
end
%hist=count;
normalized_hist=count/(size(I,1)*size(I,2));
end