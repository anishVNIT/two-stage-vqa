%-------------------------------------------------------------------------------------
function Entropy_Feature_Y=Entropy_Features_Y(frameY)

M=size(frameY,1);
N=size(frameY,2);

R1=rem(M,3);
R2=rem(N,3);
if R1==0
    k=0;
elseif R1==1
    k=2;
else
    k=1;
end
if R2==0
    p=0;
elseif R2==1
    p=2;
else
    p=1;
end
    
SplitImages_Y = image_patch_nine(frameY);
Entropy_Feature_Y=[entropy(SplitImages_Y{1,1}) entropy(SplitImages_Y{1,2}) ...
entropy(SplitImages_Y{1,3}) entropy(SplitImages_Y{2,1}) entropy(SplitImages_Y{2,2})...
entropy(SplitImages_Y{2,3}) entropy(SplitImages_Y{3,1}) entropy(SplitImages_Y{3,2})...
entropy(SplitImages_Y{3,3})];
end