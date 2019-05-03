function image = applyEH(kSpace, coilSens, trajectories)

tempImages = (1 + 1i)*ones(size(coilSens));

[imageX, imageY, ~] = size(coilSens);

for ii = 1:size(coilSens,3)
    
    % -d option necessary because of missestimation for small numbers of spokes
    tempImages(:,:,ii) = bart(sprintf('nufft -a -t -d %d:%d:1', imageX, imageY), trajectories, kSpace(:,:,:,ii));
    
end

tempImages = tempImages.*conj(coilSens);

image = sum(tempImages,3);








