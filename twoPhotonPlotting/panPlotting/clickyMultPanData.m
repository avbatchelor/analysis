function [roi_points, greenCountMat] = clickyMultPanData(greenMov, Stim, frameTimes,metaFileName,figSuffix,numBlocks,blockNum,varargin)

% Lets you select ROIS by left clicking to make a shape then right clicking
% to finish that shape.
% Then plots the fluorescence trace for that ROI
% You can select mutliple ROIs.
% A second right click prevents stops further ROIs from being drawn.


%% Calculate pre-stim frame times 
preStimFrameLog = frameTimes < Stim.startPadDur;

%% Get mean movies
meanGreenMov = mean(greenMov,4);

%% Create reference image
refimg = mean(meanGreenMov, 3);


%% See if ROIs already exist
numLoops = 1000;
lastRoiNum = getpref('scimPlotPrefs','lastRoiNum');
currRoiNum = getpref('scimSavePrefs','roiNum');
if blockNum == 1; 
    useOldRois = 'n'; 
else
    prevBlockNum = num2str(blockNum-1,'%03d');
    roiFileName = [saveFolder,'roiNum',num2str(roiNum,'%03d'),'_blockNum',prevBlockNum,'_rois.mat'];
    roiData.roi = getpref('scimPlotPrefs','roi');
    close all
    useOldRois = 'y';     
end

%% Plot ref image for future save plot
figure(1)
setCurrentFigurePosition(1)
set(gca, 'ColorOrder', ColorSet);
order = get(gca,'ColorOrder');

subplot(numPlots,2,1);
imshow(refimg, [], 'InitialMagnification', 'fit')
hold on
title(roiDescription)


%% Plot stimulus
h(1) = subplot(numPlots,2,2);
myplot(Stim.timeVec,Stim.stimulus,'Color',purple)
ylabel('Stimulus (V)')
set(gca,'xtick',[])
set(gca,'XColor','white')
title('Stimulus')


%% Get image details
nframes = size(meanGreenMov, 3);
[ysize, xsize] = size(refimg(:,:,1));

%% Get ROIs
nroi = 1;
greenCountMat = {};
[x, y] = meshgrid(1:xsize, 1:ysize);
numTrials = size(greenMov,4);
for j = 1:numLoops
    
    subplot(numPlots,2,1)
    %% Draw the ROI
    if strcmp(useOldRois,'y')
        if j == (length(roiData.roi) + 1)
            break
        else
            roiMat = cell2mat(roiData.roi(j));
            xv = roiMat(:,1);
            yv = roiMat(:,2);
        end
    else
        [xv, yv] = (getline(gca, 'closed'));
        if size(xv,1) < 3  % exit loop if only a line is drawn
            break
        end
    end
    
    %% Generate the mask
    inpoly = inpolygon(x,y,xv,yv);
    
    %% Draw the bounding polygons and label them
    currcolor = order(nroi,:);
    plot(xv, yv, 'Linewidth', 1,'Color',currcolor);
    text(mean(xv),mean(yv),num2str(nroi),'Color',currcolor,'FontSize',12);
    
    %% Calculate the mean trace within the polygon
    meanGreenFCount = squeeze(sum(sum(meanGreenMov.*repmat(inpoly, [1, 1, nframes]))))/sum(inpoly(:));
    for i = 1:numTrials
        greenFCount(i,:) = squeeze(sum(sum(squeeze(greenMov(:,:,:,i)).*repmat(inpoly, [1, 1, nframes]))))/sum(inpoly(:));
    
        greenPreStimBaselineST(i,:) = mean(greenFCount(i,preStimFrameLog));
        greenDeltaFST(i,:) = 100.*((greenFCount(i,:) - greenPreStimBaselineST(i,:))./greenPreStimBaselineST(i,:));
    
    end
    
    %% Calculate deltaF/F for mean traces 
    greenPreStimBaseline = mean(meanGreenFCount(preStimFrameLog));
    greenDeltaF = 100.*((meanGreenFCount - greenPreStimBaseline)./greenPreStimBaseline);
    greenBaselineLegend{j} = num2str(greenPreStimBaseline);   
    
    %% Store traces
    greenCountMat{nroi} =  greenFCount';

    
    %% Plot traces 
    % Plot the green trace
    h(tracePlotNum) = subplot(numPlots,2,tracePlotNum);
    hold on
    myplot(frameTimes,greenDeltaF,'Color',currcolor,'Linewidth',2);
    if numTrials > 1
        myplot(frameTimes,greenDeltaFST,'Color',currcolor,'Linewidth',1,'LineStyle','--');
    end
    colorindex = colorindex+1;
    xlabel('Time (s)')
    title(['BlockNum ',num2str(blockNum)])
    ylabel('dF/F')
    
    %% Store the rois
    roi_points{nroi} = [xv, yv];
    nroi = nroi + 1;
end

subplot(numPlots,2,tracePlotNum)
legend(greenBaselineLegend{:},'Location','Best','FontSize',8)
legend boxoff

%% Figure formatting
spaceplots
linkaxes(h(:),'x')
set(gca,'FontName','Calibri')
set(0,'DefaultFigureColor','w')

%% Add text description
h = axes('position',[0,0,1,1],'visible','off','Units','normalized');
hold(h);
pos = [0.01,0.6, 0.15 0.7];
ht = uicontrol('Style','Text','Units','normalized','Position',pos,'Fontsize',20,'HorizontalAlignment','left','FontName','Calibri','BackGroundColor','w');

% Wrap string, also returning a new position for ht
[outstring,newpos] = textwrap(ht,sumTitle);
set(ht,'String',outstring,'Position',newpos)

%% Save Figure
if ~isdir(saveFolder)
    mkdir(saveFolder)
end
fileStem = char(regexp(fileName,'.*(?=_trial)','match'));
saveFileName = [saveFolder,fileStem,'.pdf'];
mySave(saveFileName,[5 5]);

%% Close figure


