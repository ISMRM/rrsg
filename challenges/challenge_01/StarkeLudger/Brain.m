%% runBrain.m

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
datasetName = 'rawdata_brain_radial_96proj_12ch.h5';


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

refTol = 10^(-12);
refIter = 150;

[referenceReco, iterDone_ref, tolReached_ref] = SENSE(spokesData, coilSens, trajectories, intCor, densCor,refTol,refIter);

save('BrainRun')

%% reconstructions

usFactors = [1,2,3,4];
nErrorIter = 100;

exampleChannel = 1;
exampleTol = 0.01;

deltaError = zeros(nErrorIter + 1, numel(usFactors));
refError = zeros(nErrorIter + 1, numel(usFactors));

singleCoilExamples = (1 + 1i)*ones([size(referenceReco), numel(usFactors)]);
recoOne = (1 + 1i)*ones([size(referenceReco), numel(usFactors)]);
recoTol = (1 + 1i)*ones([size(referenceReco), numel(usFactors)]);

tolReached_one = zeros(1, numel(usFactors));
iterDone_tol = zeros(1, numel(usFactors));

for ii = 1:numel(usFactors)
    
    fprintf('\n---- %d-fold undersampling ----\n\n',usFactors(ii))
    
    spokesData_us = spokesData(:, :, 1:usFactors(ii):end, :);
    trajectories_us = trajectories(:, :, 1:usFactors(ii):end);
    densCor_us = densCor(:,:, 1:usFactors(ii):end);
    
    [~, deltaError(:,ii), refError(:,ii)] = SENSE_trackErrors(spokesData_us, coilSens, trajectories_us, intCor, densCor_us, referenceReco, nErrorIter);
    
    singleCoilExamples(:,:,ii) = aNUFFT(densCor_us.*spokesData_us(:,:,:,exampleChannel), trajectories_us);
    [recoOne(:,:,ii), ~, tolReached_one(ii)] = SENSE(spokesData_us, coilSens, trajectories_us, intCor, densCor_us,10^(-12),1);
    [recoTol(:,:,ii), iterDone_tol(ii), ~] = SENSE(spokesData_us, coilSens, trajectories_us, intCor, densCor_us, exampleTol, 99);

end

save('BrainRun')


%% convergence figures

lineStyle = cell(4,1);
lineStyle{1} = '-';
lineStyle{2} = '-.';
lineStyle{3} = '--';
lineStyle{4} = ':';

close all

Fig1 = figure;

    set(Fig1,'position',[100,200,1600,800]) 
    set(Fig1,'PaperPositionMode','Auto') 
    
    subplot(1,2,1)
    
    for ii = 1:numel(usFactors)
%     for ii = 2:numel(usFactors)
       
        plot(0:nErrorIter, log10(refError(:,ii))',lineStyle{ii})
        hold on
    
    end
    
    xlabel('# Iterations')
    ylabel('Log_{10}\Delta')
    xlim([-1, nErrorIter + 1])
 %   ylim([-0.8,0.1])
    
    subplot(1,2,2)
    
    for ii = 1:numel(usFactors)
%     for ii = 2:numel(usFactors)
       
        plot(0:nErrorIter, log10(deltaError(:,ii))',lineStyle{ii})
        hold on

    end

    xlabel('# Iterations')
    ylabel('Log_{10}\delta')
    xlim([-1, nErrorIter + 1])
%    ylim([-0.8,0.1])
    
    legend('R = 1', 'R = 2', 'R = 3', 'R = 4', 'location', 'northEast')
    
    print('1_convergenceFigure','-dpng')
    
%%

   
channel = 1;
exampleTol = 0.05;

Fig2 = figure;

    set(Fig2,'position',[200,0,920,1200]) 
    set(Fig2,'PaperPositionMode','Auto') 


nRows = numel(usFactors);
nColumns = 3;

    for ii = 1:nRows
        
        subplot(nRows, nColumns, (ii-1)*nColumns + 1)
        imshow(abs(singleCoilExamples(:,:,ii)),[])
        
        subplot(nRows, nColumns, (ii-1)*nColumns + 2)
        imshow(abs(recoOne(:,:,ii)),[])
        
        subplot(nRows, nColumns, (ii-1)*nColumns + 3)
        imshow(abs(recoTol(:,:,ii)),[])
        


    end

    print('2_brainExamples','-dpng')
