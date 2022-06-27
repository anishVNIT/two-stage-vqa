clc
clear all
VideoFiles=dir('D:\VQA_Databases\LIVE_VQC\*.mp4');
for x=1:length(VideoFiles)
x
filename=strcat('D:\VQA_Databases\LIVE_VQC\',VideoFiles(x).name);

v = VideoReader(filename);
frames = read(v,[1,inf]);
nFrames=size(frames,4);

for i=1:nFrames
    frame_RGB=frames(:,:,:,i);
    frameYCbCr=rgb2ycbcr(frame_RGB);
    frame_Y(:,:,i)=frameYCbCr(:,:,1);

    frame_R(:,:,i)=frame_RGB(:,:,1);
    frame_G(:,:,i)=frame_RGB(:,:,2);
    frame_B(:,:,i)=frame_RGB(:,:,3);
end

N=ceil(nFrames/v.Duration);  %Frame rate, 
N=ceil(N/5); %divide by 5 means selecting 5 frames per second

Video_Histogram_Feature_F1_R=[];
Video_Histogram_Feature_F1_G=[];
Video_Histogram_Feature_F1_B=[];

Video_Histogram_Feature_F2_R=[];
Video_Histogram_Feature_F2_G=[];
Video_Histogram_Feature_F2_B=[];

Video_Noise_Measure_XY=[];
Video_Noise_Measure_XT=[];
Video_Noise_Measure_YT=[];

k=1;
for j=1:N:size(frames,4)
    frameY=frame_Y(:,:,j);

    frameR=frame_R(:,:,k);
    frameG=frame_G(:,:,k);
    frameB=frame_B(:,:,k);
    %----------------------------------------------
    Entropy_Patches_Y=Entropy_Features_Y(frameY);
    Video_Entropy_Feature_Y(k,:)=Entropy_Patches_Y;
    clear frameY
    %-----------------------------------------------
    frameR=frame_R(:,:,k);
    frameG=frame_G(:,:,k);
    frameB=frame_B(:,:,k);

    Norm_hist_R=normalized_histogram(frameR);
    Norm_hist_G=normalized_histogram(frameG);
    Norm_hist_B=normalized_histogram(frameB);

    [F1_R, F2_R]=Feature_Histogram(Norm_hist_R);
    [F1_G, F2_G]=Feature_Histogram(Norm_hist_G);
    [F1_B, F2_B]=Feature_Histogram(Norm_hist_B);

    Video_Histogram_Feature_F1_R=[Video_Histogram_Feature_F1_R F1_R];
    Video_Histogram_Feature_F2_R=[Video_Histogram_Feature_F2_R F2_R];

    Video_Histogram_Feature_F1_G=[Video_Histogram_Feature_F1_G F1_G];
    Video_Histogram_Feature_F2_G=[Video_Histogram_Feature_F2_G F2_G];

    Video_Histogram_Feature_F1_B=[Video_Histogram_Feature_F1_B F1_B];
    Video_Histogram_Feature_F2_B=[Video_Histogram_Feature_F2_B F2_B];

    RGB_Features(k,:)=RGB_Gamut_Features(frameR,frameG,frameB);

    frameY=frame_Y(:,:,j);
    [LL_band,LH_band,HL_band,HH_band]=FastDWT(frameY);
    Noise_Measure=Noise_WaveletBand(HH_band);
    Video_Noise_Measure_XY=[Video_Noise_Measure_XY Noise_Measure];
    
    k=k+1;
    clear frameR
    clear frameG
    clear frameB
end

for l=1:N:size(frames,2)
frameY=squeeze(frame_Y(:,l,:));
[LL_band,LH_band,HL_band,HH_band]=FastDWT(frameY);
Noise_Measure=Noise_WaveletBand(HH_band);
Video_Noise_Measure_XT=[Video_Noise_Measure_XT Noise_Measure];
clear frameY
end

for m=1:N:size(frames,1)
frameY=squeeze(frame_Y(m,:,:));
[LL_band,LH_band,HL_band,HH_band]=FastDWT(frameY);
Noise_Measure=Noise_WaveletBand(HH_band);
Video_Noise_Measure_YT=[Video_Noise_Measure_YT Noise_Measure];
clear frameY
end

Mean_Video_Noise_Feature_XY(x,:)=nanmean(Video_Noise_Measure_XY);
Std_Video_Noise_Feature_XY(x,:)=nanstd(Video_Noise_Measure_XY);

Mean_Video_Noise_Feature_XT(x,:)=nanmean(Video_Noise_Measure_XT);
Std_Video_Noise_Feature_XT(x,:)=nanstd(Video_Noise_Measure_XT);

Mean_Video_Noise_Feature_YT(x,:)=nanmean(Video_Noise_Measure_YT);
Std_Video_Noise_Feature_YT(x,:)=nanstd(Video_Noise_Measure_YT);

Mean_Video_Entropy_Feature(x,:)=nanmean(Video_Entropy_Feature_Y,1);
Std_Video_Entropy_Feature(x,:)=nanstd(Video_Entropy_Feature_Y,1);

Mean_Feature_Video_Histogram_F1_R(x,:)=nanmean(Video_Histogram_Feature_F1_R);
Mean_Feature_Video_Histogram_F2_R(x,:)=nanmean(Video_Histogram_Feature_F2_R);

Mean_Feature_Video_Histogram_F1_G(x,:)=nanmean(Video_Histogram_Feature_F1_G);
Mean_Feature_Video_Histogram_F2_G(x,:)=nanmean(Video_Histogram_Feature_F2_G);

Mean_Feature_Video_Histogram_F1_B(x,:)=nanmean(Video_Histogram_Feature_F1_B);
Mean_Feature_Video_Histogram_F2_B(x,:)=nanmean(Video_Histogram_Feature_F2_B);

Std_Feature_Video_Histogram_F1_R(x,:)=nanstd(Video_Histogram_Feature_F1_R);
Std_Feature_Video_Histogram_F2_R(x,:)=nanstd(Video_Histogram_Feature_F2_R);

Std_Feature_Video_Histogram_F1_G(x,:)=nanstd(Video_Histogram_Feature_F1_G);
Std_Feature_Video_Histogram_F2_G(x,:)=nanstd(Video_Histogram_Feature_F2_G);

Std_Feature_Video_Histogram_F1_B(x,:)=nanstd(Video_Histogram_Feature_F1_B);
Std_Feature_Video_Histogram_F2_B(x,:)=nanstd(Video_Histogram_Feature_F2_B);

Mean_RGB_Gamut_Features(x,:)=nanmean(RGB_Features,1);
Std_RGB_Gamut_Features(x,:)=nanstd(RGB_Features,1);



Final_features(x,:) = [Mean_Video_Noise_Feature_XY Std_Video_Noise_Feature_XY Mean_Video_Noise_Feature_XT...
    Std_Video_Noise_Feature_XT Mean_Video_Noise_Feature_YT Std_Video_Noise_Feature_YT Mean_Video_Entropy_Feature...
    Std_Video_Entropy_Feature Mean_Feature_Video_Histogram_F1_R Mean_Feature_Video_Histogram_F2_R Mean_Feature_Video_Histogram_F1_G...
    Mean_Feature_Video_Histogram_F2_G Mean_Feature_Video_Histogram_F1_B Mean_Feature_Video_Histogram_F2_B...
    Std_Feature_Video_Histogram_F1_R Std_Feature_Video_Histogram_F2_R Std_Feature_Video_Histogram_F1_G  Std_Feature_Video_Histogram_F2_G...
    Std_Feature_Video_Histogram_F1_B Std_Feature_Video_Histogram_F2_B Mean_RGB_Gamut_Features Std_RGB_Gamut_Features];

display=['Features of Video no.#',num2str(x)];
disp(display)
end