function Noise_Measure=Noise_WaveletBand(I)

I=double(I);

Row=size(I,1);
Col=size(I,2);


maskfinal={};

for i=2:Row-1
    for j=2:Col-1
        mask=ones(3,3);
        if I(i,j)==I(i-1,j-1)
            mask(1,1)=0;
        end
        
        if I(i,j)==I(i-1,j)
            mask(1,2)=0;
        end
        
        if I(i,j)==I(i-1,j+1)
            mask(1,3)=0;
        end
        
         if I(i,j)==I(i,j-1)
            mask(2,1)=0;
         end
        
         if I(i,j)==I(i,j+1)
            mask(2,3)=0;
         end
      
        if I(i,j)==I(i+1,j-1)
            mask(3,1)=0;
        end
        
        if I(i,j)==I(i+1,j)
            mask(3,2)=0;
        end
        
        if I(i,j)==I(i+1,j+1)
            mask(3,3)=0;
        end
        maskfinal{i,j}=mask;
    end
end

FMask=ones(Row,Col);

for m=2:Row-1
    for n=2:Col-1
        FMask(m-1:m+1,n-1:n+1)=maskfinal{m,n}.*FMask(m-1:m+1,n-1:n+1);
    end
end

Noise_Image=FMask(2:end,2:end).*I(2:end,2:end);
Noise_Measure=std(nonzeros(Noise_Image'));
end