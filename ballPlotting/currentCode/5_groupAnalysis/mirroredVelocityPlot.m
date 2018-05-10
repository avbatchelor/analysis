function mirroredVelocityPlot(prefixCodes,allTrials)

%% Import colors
[colorSet1,colorSet2] = colorSetImport;

%% Make box plot

analysisSettings = getAnalysisSettings;

plotCount = 0;

%% Loop through prefix Codes
for i = 1:size(prefixCodes,1)
    figure(1);
    hold on 
    
    prefixCode = prefixCodes{i,1};
    stim = prefixCodes{i,2};
    plotCount = plotCount + 1; 
    
    %% Get plot data
    plotData = multiFlyAnalysis(prefixCode,allTrials);
    
    %% Average & SEM across flies
    avgAcrossTrials = getAvgAcrossTrials(plotData);
    semAcrossFlies = squeeze(std(avgAcrossTrials,1) / sqrt(plotData.numFlies));
    
    %% Plot individual expts
    % Third dimension is time
    plot(plotCount,squeeze(avgAcrossTrials(:,stim,analysisSettings.velInd,1)),'o','MarkerEdgeColor',colorSet1(stim,:),'MarkerFaceColor',colorSet1(stim,:));
    
    % Plot mean
    plot([plotCount-0.2,plotCount+0.2],repmat(mean(squeeze(avgAcrossTrials(:,stim,analysisSettings.velInd,1)),1),[1,2]),'k');
    
    errorbar(plotCount,mean(squeeze(avgAcrossTrials(:,stim,analysisSettings.velInd,1)),1),semAcrossFlies(stim,analysisSettings.velInd,1),'k')
    
end

noXAxisSettings('w')
ylabel({'Lateral';'velocity';'mm/s'})
figPos = get(gcf,'Position');
figPos(3) = figPos(3)/2;
set(gcf,'Position',figPos)
xlim([0 4])

%% Save figure
statusStr = checkRepoStatus;
figPath = 'D:\ManuscriptData\summaryFigures';
filename = [figPath,'\',prefixCode,'_','mirroredVel','_',statusStr,'.pdf'];
export_fig(filename,'-pdf','-painters')