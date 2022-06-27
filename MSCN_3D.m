function structdis=MSCN_3D(coeff)
mu = imgaussfilt3(coeff,7/6,'filtersize',[5 5 5]);
    mu_sq = mu.*mu;
    sigma = sqrt(abs(imgaussfilt3(coeff.*coeff,7/6,'filtersize',[5 5 5])-mu_sq));
    vMinusMu = (coeff-mu);
    structdis =vMinusMu./(sigma +1);
end