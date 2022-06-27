
function patch=image_patch_nine(I)

[height,width]=size(I);

k=1;
for i=1:3
    m=1;
    for j=1:3
    patch{i,j}=I(k:k+floor(height/3)-1,m:m+floor(width/3)-1);
    m=m+floor(width/3);
    end
    k=k+floor(height/3);
end