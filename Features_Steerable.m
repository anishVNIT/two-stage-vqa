clc
clear all

%%-------------------------------------------------------------------------------------------------------------------------------
addpath('C:\Users\admin\Google Drive\1_PhD WORK\Anish Ph. D. Contributions\Work 3\Main Codes Work 3 Features\Riesz-3D-light.0.3\Riesz-3D-light.0.3\monogenic')
addpath('C:\Users\admin\Google Drive\1_PhD WORK\Anish Ph. D. Contributions\Work 3\Main Codes Work 3 Features\Riesz-3D-light.0.3\Riesz-3D-light.0.3\output')
addpath('C:\Users\admin\Google Drive\1_PhD WORK\Anish Ph. D. Contributions\Work 3\Main Codes Work 3 Features\Riesz-3D-light.0.3\Riesz-3D-light.0.3\prefilters')
addpath('C:\Users\admin\Google Drive\1_PhD WORK\Anish Ph. D. Contributions\Work 3\Main Codes Work 3 Features\Riesz-3D-light.0.3\Riesz-3D-light.0.3\Riesz')
addpath('C:\Users\admin\Google Drive\1_PhD WORK\Anish Ph. D. Contributions\Work 3\Main Codes Work 3 Features\Riesz-3D-light.0.3\Riesz-3D-light.0.3\steering')
addpath('C:\Users\admin\Google Drive\1_PhD WORK\Anish Ph. D. Contributions\Work 3\Main Codes Work 3 Features\Riesz-3D-light.0.3\Riesz-3D-light.0.3\waveletTransform')
%%---------------------------------------------------------------------------------------------------------------------------------
VideoFiles=dir('D:\VQA_Databases\LIVE_VQC\*.mp4');

N=64; %video block size N x N x N
for x=1:length(VideoFiles)
    x
    filename=strcat('D:\VQA_Databases\LIVE_VQC\',VideoFiles(x).name);
    v = VideoReader(filename);
    frames = read(v,[1,inf]);
    nFrames=size(frames,4);
    for i=1:nFrames
        frame_RGB=frames(:,:,:,i);
        VID_Y(:,:,i)=convertYUV(frame_RGB);
    end
%--------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------
    Video_blocks =Split_in_blocks(VID_Y,v.Width,v.Height,N);
    S=2; %video blocks sampling, 2 indicates selecting alternate video blocks
    Feature_Steerable_Shape_Video(x,:)=Feature_shape_3D_Steerable_Wavelet(Video_blocks,S);
    clear VID_Y
    display=['Features of Video no.#',num2str(x)];
    disp(display)
end