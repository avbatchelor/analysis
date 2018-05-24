function integrationCheck(prefixCode,allTrials,stimToPlot,varargin)

close all
goFigure(1);

%% Loop through experiments
clear temp

%% Get plot data
plotData = multiFlyAnalysis(prefixCode,allTrials);

%% Average & SEM across flies
avgAcrossTrials = getAvgAcrossTrials(plotData,1:plotData.numStim);

%% Colors
colors = linspecer(5);
colorSet1 = [colors;colors];

%% Open figure
figure(1)
hold on

% Make subplots tight
subplot = @(m,n,p) subtightplot (m, n, p, [0.025 0.025], [0.15 0.01], [0.15 0.02]);

% Specify subolot
colorCount = 0;
for stim = stimToPlot
    colorCount = colorCount + 1;
    dim = 1;
    subplot(2,1,1)
    hfl(stim) = plot(plotData.time,mean(squeeze(avgAcrossTrials(:,stim,:,dim)),1)','Color',colorSet1(colorCount,:),'Linewidth',3);
    hold on 
    xlim([1 3.5])
    subplot(2,1,2)
    hfl(stim) = plot(plotData.time,mean(squeeze(avgAcrossTrials(:,stim,:,dim)),1)','Color',colorSet1(colorCount,:),'Linewidth',3);
    hold on 
end


%% Save figures
figPath = 'D:\ManuscriptData\summaryFigures\';
filename = [figPath,'integrationCheck.pdf'];
export_fig(filename,'-pdf','-painters')