%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The function rgb2yuv converts the RGB matrix of an image to an YUV format%

%Author:Santhana Raj.A							  %
%https://sites.google.com/site/santhanarajarunachalam/			  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function YUV=rgb2yuv(RGB)

R = RGB(:,:,1);
G = RGB(:,:,2);
B = RGB(:,:,3);

%Conversion Formula
Y = 0.299   * R + 0.587   * G + 0.114 * B;
U =128 - 0.168736 * R - 0.331264 * G + 0.5 * B;
V =128 + 0.5 * R - 0.418688 * G - 0.081312 * B;

%Resizing to fit into 4:2:2 chroma sampling
[m,n]=size(U);
U_prime=zeros(m,n);     %initialisation
V_prime=zeros(m,n);     %Initialisation
for i=1:n
        if(mod(i,2)~=0)
            U_prime(:,i)=U(:,i);
            V_prime(:,i)=V(:,i);
        end
end

YUV=cat(3,Y,U_prime,V_prime);

end
