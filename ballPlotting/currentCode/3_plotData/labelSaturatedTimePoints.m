function labelSaturatedTimePoints(prefixCode,expNum,flyNum,flyExpNum)

close all

%% Put exptInfo in a struct
exptInfo = exptInfoStruct(prefixCode,expNum,flyNum,flyExpNum);

%% Load plot data
% Get paths
[~, ~, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
pPath = getProcessedDataFileName(exptInfo);

% Plot data
fileName = [pPath,fileNamePreamble,'plotData.mat'];
load(fileName);

% Grouped data
fileName = [pPath,fileNamePreamble,'groupedData.mat'];
load(fileName);




%% Get number of trials
numTrials = plotData.numTrials;
briefTitle = plotData.sumTitle{1};

%% Convert cells to matrices 
xVel = cell2mat(groupedData.xVel);
yVel = cell2mat(groupedData.yVel);

%% Get idxs of saturated trials
[xMid,xFirst,xOne,yMid,yFirst,yOne,timePts] = findSatIdxs(exptInfo,xVel,yVel);

xSatTimePts = timePts.xSatTimePts; 
ySatTimePts = timePts.ySatTimePts;

% Find trials where only N time points are saturated. 


% Find trials where both x and y are saturated 
% bothSatTrials = intersect(xMidSatTrials,yMidSatTrials);
% xMidSatTrials = setdiff(xMidSatTrials,bothSatTrials);
% yMidSatTrials = setdiff(yMidSatTrials,bothSatTrials); 

%% Make figure 
goFigure(70);
satSubPlot(1,xMid,xSatTimePts,xVel,groupedData,numTrials,'X','mid',briefTitle)
satSubPlot(3,xFirst,xSatTimePts,xVel,groupedData,numTrials,'X','first',briefTitle)
satSubPlot(5,xOne,xSatTimePts,xVel,groupedData,numTrials,'X','one',briefTitle)
% satSubPlot(7,xLastSatTrials,xSatTimePts,xVel,groupedData,numTrials,'X','last',briefTitle)

satSubPlot(2,yMid,ySatTimePts,yVel,groupedData,numTrials,'Y','mid',briefTitle)
satSubPlot(4,yFirst,ySatTimePts,yVel,groupedData,numTrials,'Y','first',briefTitle)
satSubPlot(6,yOne,ySatTimePts,yVel,groupedData,numTrials,'Y','one',briefTitle)
% satSubPlot(8,yLastSatTrials,ySatTimePts,yVel,groupedData,numTrials,'Y','last',briefTitle)

% satSubPlot(5,bothSatTrials,xSatTimePts,xVel,groupedData,numTrials,'X','both',briefTitle)
% satSubPlot(6,bothSatTrials,ySatTimePts,yVel,groupedData,numTrials,'Y','both',briefTitle)

%% Save figure 
folder = [plotData.saveFolder,'\saturation\'];
mkdir(folder)
[~, ~, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
filename = [folder,fileNamePreamble,'saturation_plot.pdf'];
export_fig(filename,'-pdf','-painters')
            
end

function satSubPlot(subplotNum,satTrials,satTimePts,vel,groupedData,numTrials,axis,section,briefTitle)

%% Don't plot if there are no saturated trials 
if isempty(satTrials) 
    return 
end

%% Select 10 random trials 
numSamples = min([10,length(satTrials)]);
if numSamples == 1
    sampleIdxs = satTrials;
else
    sampleIdxs = randsample(satTrials,numSamples);
end

% Subplot
subplot(4,2,subplotNum)
hold on

% Plot traces
plot(groupedData.dsTime{1},vel(:,sampleIdxs))

% Plot saturated sections 
for i = 1:length(sampleIdxs)
    timePtsToPlot = satTimePts(:,sampleIdxs(i));
    plot(groupedData.dsTime{1}(timePtsToPlot),vel(timePtsToPlot,sampleIdxs(i)),'r.')
end

% Figure title 
satDescrip = sprintf('Showing %d out of %d %s saturated trials. ',numSamples,length(satTrials),section);
exptDescrip = sprintf('Total Trials = %d',numTrials);
title({[axis,' ',section];satDescrip})

% Figure settings 
if subplotNum == 5 || subplotNum == 6
    xlabel('Time (s)')
end
ylabel('Vel (mm/s)')
bottomAxisSettings
xlim([-0.1,4.5])

if strcmp(axis,'X')
    ylim([-42 42])
elseif strcmp(axis,'Y')
    ylim([-20 65])
end

suptitle({briefTitle;exptDescrip})

end

