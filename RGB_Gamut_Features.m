function RGB_Features=RGB_Gamut_Features(frameR,frameG,frameB)

MeanR=mean2(frameR);
MeanG=mean2(frameG);
MeanB=mean2(frameB);
StdR=std2(frameR);
StdG=std2(frameG);
StdB=std2(frameB);

Mean_Point_RGB=[MeanR MeanG MeanB];
Std_Point_RGB=[StdR StdG StdB];

Centroid=[127.5 127.5 127.5];
Dist_mean=sum(sqrt((Centroid-Mean_Point_RGB).^2));

R_Point=[255 0 0];
G_Point=[0 255 0];
B_Point=[0 0 255];

Dist_R=sum(sqrt((R_Point-Mean_Point_RGB).^2));
Dist_G=sum(sqrt((G_Point-Mean_Point_RGB).^2));
Dist_B=sum(sqrt((B_Point-Mean_Point_RGB).^2));

RGB_Features=[Mean_Point_RGB Std_Point_RGB Dist_mean Dist_R Dist_G Dist_B];
end
%-----------------------------------------------------------------------------------
