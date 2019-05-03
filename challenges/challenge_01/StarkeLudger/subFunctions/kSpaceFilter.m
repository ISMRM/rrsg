function out = kSpaceFilter(in, radialTrajectories)

temp = sqrt(sum(radialTrajectories.^2, 1));
kMax = max(temp(:));

kSpace = cfftn(in);

% create filter

dim = size(kSpace);
center = (dim + 1)/2;
[x,y] = meshgrid(-(center(2)-1):(dim(2)-center(2)),-(center(1)-1):(dim(1)-center(1)));
kRadius = sqrt(x.^2 + y.^2);

filter = 1/2 + 1/pi*atan(100*(kMax - kRadius)/kMax); 

out = cifftn(filter.*kSpace);


%% centered FFTs

function res = cfftn(x)

res = 1/sqrt(numel(x))*fftshift(fftn(ifftshift(x)));

function res = cifftn(x)

res = sqrt(numel(x))*fftshift(ifftn(ifftshift(x)));
