
function Features_shape_scale_parameters=Feature_shape_3D_Steerable_Wavelet(C,N)
%C=Video_blocks
num=1;
rieszOrder=2;
numWaveletScales=3;
for i=1:length(C)
    Vid_blocks=C{i};
    for m=1:N:size(Vid_blocks,1)
        for n=1:N:size(Vid_blocks,2)
            Vid_block=Vid_blocks{m,n};
            
            config=RieszConfig(size(Vid_block), rieszOrder, numWaveletScales, 1);
            [WT, residual] = multiscaleRieszAnalysis(Vid_block,config);
            
            
            alpha_scale=[];   
            betal_scale=[];
            betar_scale=[];

            for k=1:length(WT)-1
                    alpha=[];
                    betal=[];
                    betar=[];
                for p=1:size(WT{1},1)
                    WT_coeff=squeeze(WT{k}(p,:,:,:));
                    WT_coeff=MSCN_3D(WT_coeff); %3D MSCN
                    WT_coeff_vector=reshape(WT_coeff,1,[]);
                    [alpha1,betal1,betar1] = estimateaggdparam(WT_coeff_vector);
                    alpha=[alpha alpha1];
                    betal=[betal betal1];
                    betar=[betar betar1];
                end
                alpha_scale=[alpha_scale alpha];
                betal_scale=[betal_scale betal];
                betar_scale=[betar_scale betar];
            end
            
            Alpha_parameter(num,:)=alpha_scale;
            BetaL_parameter(num,:)=betal_scale;
            BetaR_parameter(num,:)=betar_scale;
           
            num=num+1;
            
        end
    end  
end
%========================Pooling========================
Mean_Alpha_Video=nanmean(Alpha_parameter,1);
Std_Alpha_Video=nanstd(Alpha_parameter,1);

Mean_BetaL_Video=nanmean(BetaL_parameter,1);
Std_BetaL_Video=nanstd(BetaL_parameter,1);

Mean_BetaR_Video=nanmean(BetaR_parameter,1);
Std_BetaR_Video=nanstd(BetaR_parameter,1);



Features_shape_scale_parameters=[Mean_Alpha_Video Mean_BetaL_Video Mean_BetaR_Video...
    Std_Alpha_Video Std_BetaL_Video Std_BetaR_Video];

end