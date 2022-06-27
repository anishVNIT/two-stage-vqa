function Vid_blocks =Split_in_blocks(frames,width,height,N)
length_frames=size(frames,3);
Vid_blocks=cell(1,floor(length_frames/N));
append_row=N-rem(height,N);
append_column=N-rem(width,N);
j=0;
for i=1:length_frames/N
for FrameNumber = 1:N
  Images(:,:,FrameNumber) =frames(:,:,FrameNumber+j);
  Images1(:,:,FrameNumber)=padarray(Images(:,:,FrameNumber), [append_row, append_column],'replicate', 'post');
end

SplitImages = mat2cell(Images1, N * ones(1, size(Images1,1) / N), N* ones(1, size(Images1,2) / N), size(Images1,3));
Vid_blocks{1,i}=SplitImages;
j=j+N;
end
