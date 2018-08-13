function fig4QuantVel(prefixCodes,allTrials,labels,figName,dim)

%% Import colors
% [colorSet1,colorSet2] = colorSetImport;
colorSet1 = distinguishable_colors(4,'w');
if strcmp(prefixCodes{1,1},'Cardinal-0')
    colorSet1 = [0,1,0;1,0,0;0,0,1;0,0,0.172413793103448];
end

%% Make box plot
analysisSettings = getAnalysisSettings;

plotCount = 0;

close all

%% Loop through prefix Codes
for i = 1:size(prefixCodes,1)
    goFigure(1);
    subtightplot (1, 1, 1, [0.025 0.025], [0.5 0.01], [0.1 0.01]);
    hold on
    
    prefixCode = prefixCodes{i,1};
    stim = prefixCodes{i,2};
    plotCount = plotCount + 1;
    
    %% Get plot data
    plotData = multiFlyAnalysis(prefixCode,allTrials);
    stimToPlot = 1:plotData.numStim;
    
    %% Average & SEM across flies
    avgAcrossTrials = getAvgAcrossTrials(plotData,stimToPlot);
    
    %% Plot expts
    flyMeans = avgAcrossTrials(:,stim,analysisSettings.velInd,dim);
    
    % Plot 1
    plot(plotCount,flyMeans,'o','MarkerEdgeColor',colorSet1(plotCount,:),'Linewidth',2);
    plot([plotCount-0.2,plotCount+0.2],repmat(mean(flyMeans),[1,2]),'k');
    mirroredSEM = std(flyMeans) / sqrt(length(flyMeans));
    errorbar(plotCount,mean(flyMeans),mirroredSEM,'k')
    
    %% Make table for stats
    
    if i == 1
        angle = repmat([str2double(labels{i})],5,1);
        vel = flyMeans;
    else
        angle = [angle;repmat(str2double(labels{i}),5,1)];
        vel = [vel;flyMeans];
    end
end

%% Generate table 
fly = repmat(1:5,1,4)';
T = table(fly, angle, vel);
if dim == 1
    stats_filename = 'D:\ManuscriptData\processedData\stats\diag_lat_vel.csv';
else
    stats_filename = 'D:\ManuscriptData\processedData\stats\diag_forward_vel.csv';
end
writetable(T,stats_filename)


%% Plot settings
if dim == 1
    ylabel({'Lateral velocity';'(mm/s)'})
else
    ylabel({'Decrease in';'forward';'velocity';'(mm/s)'})
    ylim([-1 30])
    set(gca,'YTick',[0 10 20])
end
xlim([0.5 plotCount+0.5])
set(gca,'XTick',1:4,'XTickLabel',labels);
set(gca,'Box','off','TickDir','out')
set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')

% Position settings
pbaspect([1 2 1])
set(findall(gcf,'-property','FontSize'),'FontSize',20)


%% Save figure
statusStr = checkRepoStatus;
figPath = 'D:\ManuscriptData\summaryFigures';
filename = [figPath,'\',figName,'_',statusStr,'.pdf'];
export_fig(filename,'-pdf','-painters')