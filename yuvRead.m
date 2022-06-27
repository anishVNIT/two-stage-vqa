function [y, u, v, nFrame] = yuvRead(vid, width, height)
fid = fopen(vid,'r');           % Open the video file
stream = fread(fid,'*uchar');    % Read the video file
length = 1.5 * width * height;  % Length of a single frame

fwidth = 0.5;
fheight= 0.5;
filep = dir(vid); 
fileBytes = filep.bytes; %Filesize
clear filep
nFrame = fileBytes/(width*height*(1+2*fheight*fwidth));

y = uint8(zeros(height,   width,   nFrame));
u = uint8(zeros(height/2, width/2, nFrame));
v = uint8(zeros(height/2, width/2, nFrame));

for iFrame = 1:nFrame
    
    frame = stream((iFrame-1)*length+1:iFrame*length);
    
    % Y component of the frame
    yImage = reshape(frame(1:width*height), width, height)';
    % U component of the frame
    uImage = reshape(frame(width*height+1:1.25*width*height), width/2, height/2)';
    % V component of the frame
    vImage = reshape(frame(1.25*width*height+1:1.5*width*height), width/2, height/2)';
    
    y(:,:,iFrame) = uint8(yImage);
    u(:,:,iFrame) = uint8(uImage);
    v(:,:,iFrame) = uint8(vImage);

end
