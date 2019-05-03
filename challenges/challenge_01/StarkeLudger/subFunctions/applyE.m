function kSpace = applyE(image, coilSens, trajectories)

% generate coil sensitivity weighted images

coilImages = (1 + 1i)*ones(size(coilSens));

for ii = 1:size(coilSens,3)
    
    coilImages(:,:,ii) = image.*coilSens(:,:,ii);
    
end


% transform weighted images to k-space

kSpace = (1 + 1i)*ones([1, size(trajectories,2), size(trajectories,3), size(coilSens,3)]);

for ii = 1:size(coilSens,3)
    
    kSpace(:,:,:,ii) = bart('nufft', trajectories, coilImages(:,:,ii));
    
end





























