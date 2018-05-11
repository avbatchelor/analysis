function fig5VelDiff(prefixCodes,allTrials,labels,figName,dim)

%% Import colors
% [colorSet1,colorSet2] = colorSetImport;
colorSet1 = distinguishable_colors(2,'w');

%% Make box plot
analysisSettings = getAnalysisSettings;

plotCount = 0;

close all

flyMeans1 = [];
flyMeans2 = [];

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
    
    %% Average & SEM across flies
    avgAcrossTrials = getAvgAcrossTrials(plotData);
    
    %% Plot individual expts
    % Dimensions: flies x stim x time x dim
    if dim == 1
        if stim == 1
            flyMeans2 = [flyMeans2;avgAcrossTrials(:,stim,analysisSettings.velInd,dim)];
        elseif stim == 2
            flyMeans1 = [flyMeans1;avgAcrossTrials(:,stim,analysisSettings.velInd,dim)];
        elseif stim == 3
            flyMeans1 = [flyMeans1,avgAcrossTrials(:,stim,analysisSettings.velInd,dim)];
        elseif stim == 4
            flyMeans2 = [flyMeans2,avgAcrossTrials(:,stim,analysisSettings.velInd,dim)];
        end  
    end
    
end

% Take means 
flyDiff1 = flyMeans1(:,1) - flyMeans1(:,2);
flyDiff2 = flyMeans2(:,1) - flyMeans2(:,2);

% Plot 1
plot(1,flyDiff1,'o','MarkerEdgeColor',colorSet1(1,:),'MarkerFaceColor',colorSet1(1,:));
plot([1-0.2,1+0.2],repmat(mean(flyDiff1),[1,2]),'k');
mirroredSEM = std(flyDiff1) / sqrt(length(flyDiff1));
errorbar(1,mean(flyDiff1),mirroredSEM,'k')

% Plot 2
plot(2,flyDiff2,'o','MarkerEdgeColor',colorSet1(2,:),'MarkerFaceColor',colorSet1(2,:));
plot([2-0.2,2+0.2],repmat(mean(flyDiff2),[1,2]),'k');
mirroredSEM = std(flyDiff2) / sqrt(length(flyDiff2));
errorbar(2,mean(flyDiff2),mirroredSEM,'k')

% Plot settings
if dim == 1
    ylabel({'Lateral velocity';'difference';'(mm/s)'})
else
    ylabel({'Decrease in';'forward';'velocity';'(mm/s)'})
    ylim([-1 30])
    set(gca,'YTick',[0 10 20])
end
xlim([0.5 2+0.5])
set(gca,'XTick',1:2,'XTickLabel',labels,'XTickLabelRotation',45);
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