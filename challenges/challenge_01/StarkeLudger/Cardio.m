% Cardio.m

clear, close all

%% path info

% BART setup 
bartPath = '/home/ludger/bart-0.4.04';
addpath(genpath(bartPath));
setenv('TOOLBOX_PATH', bartPath);

% add subfunctions folder
addpath([pwd, filesep, 'subFunctions'])

% data paths
dataFolder = '/home/ludger/Dropbox/01_NewMDC/projects/reproducibleResearch/rrsg_challenge/rrsg_challenge';
datasetName = 'rawdata_heart_radial_55proj_34ch.h5';


%% figure settings

set(0,'DefaultAxesFontSize', 32)
set(0,'defaultLineMarkerSize', 9)
set(0,'defaultLineLineWidth', 3)
set(0,'defaultAxesLineWidth', 2)


%% data import and preparation

% get k-space data sort into BART format
spokesData = h5read([dataFolder, filesep, datasetName],'/rawdata');
spokesData = spokesData.r + 1i*spokesData.i;
spokesData = permute(spokesData,[4,3,2,1]);

% get trajectory data and sort into BART format
trajectories = h5read([dataFolder, filesep, datasetName], '/trajectory');
trajectories = permute(trajectories,[3,2,1]);

[~,nFe, nSpokes, nChannels] = size(spokesData);

imageSize = round(2*max(abs(trajectories(:))));

    
%% density correction matrix


densCor = abs(trajectories(1,:,:) + 1i*trajectories(2,:,:));
densCor = densCor/max(densCor(:));
    
    
%% get coil sensitivities

singleCoilImages = (1 + 1i)*ones(imageSize, imageSize, nChannels);

for ii = 1:nChannels
    
    singleCoilImages(:,:,ii) = aNUFFT(densCor.*spokesData(:,:,:,ii), trajectories);
    
end

sumOfSquaresReco = sqrt(sum(abs(singleCoilImages).^2,3));
coilSens = singleCoilImages./repmat(sumOfSquaresReco,[1,1,nChannels]);


%% intensity correction matrix


intCor = sum(abs(coilSens).^2,3);
intCor = sqrt(intCor).^(-1);


%% reference reco

tol = 0.02;
maxIter = 40;

nSpokes_us = [55, 33, 22, 11];

recos = cell(1,numel(nSpokes_us));

tolReached = zeros(1, numel(nSpokes_us));
iterDone = zeros(1, numel(nSpokes_us));

%%

for ii = 1:numel(nSpokes_us)

    fprintf('\n %d spokes\n\n', nSpokes_us(ii))
    
    spokesData_us = spokesData(:, :, 1:nSpokes_us(ii), :);
    trajectories_us = trajectories(:, :, 1:nSpokes_us(ii));
    densCor_us = densCor(:,:, 1:nSpokes_us(ii));

    [recos{ii}, iterDone(ii), tolReached(ii)] = SENSE(spokesData_us, coilSens, trajectories_us, intCor, densCor_us,tol,maxIter);

end

save('CardioRun')

    
%% make figure

close all
    
Fig1 = figure;

    set(Fig1,'position',[0,300,1800,450]) 
    set(Fig1,'PaperPositionMode','Auto') 



   for ii = 1:numel(nSpokes_us)
        
        subplot(1, numel(nSpokes_us), ii)
        imshow(abs(recos{ii}),[])
        title(sprintf('%d spokes', nSpokes_us(ii)))

    end

    print('3_cardioExamples','-dpng')
