function [Area_Tr_inter_Hist, Area_Tr_Minus_Area_Tr_inter_Hist]=Feature_Histogram(n1)
e1=linspace(0,255,256);

y1=(max(n1)/128).*e1(1:129);
S1=zeros(1,129);
for i=1:129
    if y1(i)-n1(i)>=0
        S1(i)=n1(i);
    else
        S1(i)=y1(i);
        %S1(i)=0;
    end
end

y2=max(n1)-((max(n1)/128).*(e1(129:256)-128));
S2=zeros(1,127);
for i=1:127
    if y2(i+1)-n1(i+129)>=0
        S2(i)=n1(i+129);
    else
        S2(i)=y2(i);
        %S2(i)=0;
    end
end

Area_Tr_inter_Hist=sum(S1)+sum(S2);
Area_Tr_Minus_Area_Tr_inter_Hist=sum(y1)+sum(y2(2:end))-Area_Tr_inter_Hist;
end