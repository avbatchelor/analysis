function plotCounterTurnExample(prefixCode,freqSep,figName,allTrials,stimToPlot,varargin)

%% Get analysis settings
analysisSettings = getAnalysisSettings;

%% Get plot data
plotData = multiFlyAnalysis(prefixCode,allTrials);

%% Get single fly data
[~,plotDataSingleFly] = getExampleFlies(prefixCode);

close all

%% Average & SEM across flies
avgAcrossTrials = cellfun(@(x) squeeze(mean(x,2)),plotData.disp,'UniformOutput',false);
for i = 1:plotData.numFlies
    temp(i,:,:,:) = avgAcrossTrials{i};
end
avgAcrossTrials = temp;
if ~exist('stimToPlot','var')
    stimToPlot = 1:plotData.numStim;
end
if strcmp(prefixCode,'Freq')
    avgAcrossTrialsVel = getAvgAcrossTrials(plotData,1:plotData.numStim);
else
    avgAcrossTrialsVel = getAvgAcrossTrials(plotData,stimToPlot);
end
%% Color settings


if strcmp(prefixCode,'Diag')
    colorSet1 = distinguishable_colors(4,'w');
elseif strcmp(prefixCode,'Cardinal') || strcmp(prefixCode,'Cardinal-0')
    colorSet1 = distinguishable_colors(5,'w');
elseif strcmp(prefixCode,'Freq')
    if freqSep == 'y'
        numColors = ceil(plotData.numStim/2);
        colors = linspecer(numColors);
        colorSet1 = [colors(1:5,:);colors(1:5,:);colors(1:5,:);colors(1:5,:)];
    else
        colorSet1 = distinguishable_colors(plotData.numStim,'w');
    end
else
    [colorSet1,~] = colorSetImport;
end

%% Open figure
goFigure;

% Plot each fly separately
for fly = 1
    for stim = stimToPlot

        hfl = plot(squeeze(avgAcrossTrials(fly,stim,:,1))',squeeze(avgAcrossTrials(fly,stim,:,2))','Color',colorSet1(stim,:),'Linewidth',2);
        hold on
        % Plot stim onset
        plot(squeeze(avgAcrossTrials(fly,stim,201,1))',squeeze(avgAcrossTrials(fly,stim,201,2))','ko','Linewidth',3);
        % Plot stim offset
        plot(squeeze(avgAcrossTrials(fly,stim,analysisSettings.velInd,1))',squeeze(avgAcrossTrials(fly,stim,analysisSettings.velInd,2))','ko','Linewidth',3);
        plot(squeeze(avgAcrossTrials(fly,stim,analysisSettings.velInd+1,1))',squeeze(avgAcrossTrials(fly,stim,analysisSettings.velInd+1,2))','ko','Linewidth',3);

        % Axis limits
        symAxisY(gca);
        if strcmp(prefixCode,'Diag')
            ylim([-50 50])
            xlim([-1.8 1.8])
        else
            ylim([-60 60])
            xlim([-3.3 3.3])
        end
        noAxisSettings('w');

    end
    
    if fly == 1
        xStart = 1.5;
        xEnd = 2.5;
        yStart = -30;
        yEnd = -10;
        xText = '1 mm';
        yText = '20 mm';
        scalebar(xStart,xEnd,yStart,yEnd,xText,yText)
    end
    
        
end

%% Save figures
statusStr = checkRepoStatus;
% Save figures
figPath = 'D:\ManuscriptData\summaryFigures';
filename = [figPath,'\',figName,'_',statusStr,'.pdf'];
export_fig(filename,'-pdf','-painters')

end