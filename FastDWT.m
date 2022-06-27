function [LL_band,LH_band,HL_band,HH_band]=FastDWT(I)
I=double(I(:,:,1));
[r c]=size(I);

L_band=I(1:2:r-1,:)+I(2:2:r,:);
H_band=I(1:2:r-1,:)-I(2:2:r,:);

LL_band=0.5*(L_band(:,1:2:c-1)+L_band(:,2:2:c));
LH_band=0.5*(L_band(:,1:2:c-1)-L_band(:,2:2:c));

HL_band=0.5*(H_band(:,1:2:c-1)+H_band(:,2:2:c));
HH_band=0.5*(H_band(:,1:2:c-1)-H_band(:,2:2:c));
end
