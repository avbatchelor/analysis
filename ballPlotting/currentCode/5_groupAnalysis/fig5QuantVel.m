function fig5QuantVel(prefixCodes,allTrials,labels,figName,dim)

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
    stimToPlot = 1:plotData.numStim;
    
    %% Average & SEM across flies
    avgAcrossTrials = getAvgAcrossTrials(plotData,stimToPlot);
    
    %% Plot individual expts
    % Dimensions: flies x stim x time x dim
    if dim == 1
        if stim == 1
            flyMeans2 = [flyMeans2;avgAcrossTrials(:,stim,analysisSettings.velInd,dim)];
        elseif stim == 2
            flyMeans1 = [flyMeans1;avgAcrossTrials(:,stim,analysisSettings.velInd,dim)];
        elseif stim == 3
            flyMeans1 = [flyMeans1,-avgAcrossTrials(:,stim,analysisSettings.velInd,dim)];
        elseif stim == 4
            flyMeans2 = [flyMeans2,-avgAcrossTrials(:,stim,analysisSettings.velInd,dim)];
        end
    elseif dim == 2
        velChange = -(avgAcrossTrials(:,stim,analysisSettings.forwardVelIndAfter,dim)-avgAcrossTrials(:,stim,analysisSettings.forwardVelIndBefore,dim));
        if stim == 1 || stim == 4
            flyMeans2 = [flyMeans2,velChange];
        elseif stim == 2 || stim == 3
            flyMeans1 = [flyMeans1,velChange];
        end
         
    end
    
end

% Take means 
flyMeans1 = mean(flyMeans1,2);
flyMeans2 = mean(flyMeans2,2);

% Plot 1
plot(1,flyMeans1,'o','MarkerEdgeColor',colorSet1(1,:),'MarkerFaceColor',colorSet1(1,:));
plot([1-0.2,1+0.2],repmat(mean(flyMeans1),[1,2]),'k');
mirroredSEM = std(flyMeans1) / sqrt(length(flyMeans1));
errorbar(1,mean(flyMeans1),mirroredSEM,'k')

% Plot 2
plot(2,flyMeans2,'o','MarkerEdgeColor',colorSet1(2,:),'MarkerFaceColor',colorSet1(2,:));
plot([2-0.2,2+0.2],repmat(mean(flyMeans2),[1,2]),'k');
mirroredSEM = std(flyMeans2) / sqrt(length(flyMeans2));
errorbar(2,mean(flyMeans2),mirroredSEM,'k')

% Plot settings
if dim == 1
    ylabel({'Lateral velocity';'towards speaker';'(mm/s)'})
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

%% Statistical testing 
differences = flyMeans1 - flyMeans2;
goFigure;
bins = [-10:1:30];
histogram(differences,bins);

[h,p] = jbtest(differences);
disp('Jarque-Bera test')
disp(['h = ',num2str(h),', p = ',num2str(p)])
[h,p] = ttest(differences,0,'Tail','both');
disp('t-test')
disp(['h = ',num2str(h),', p = ',num2str(p)])


%% Statistical testing 
[h,p] = ttest(flyMeans2,0,'Tail','both');
disp('t-test on 90 deg stim only')
disp(['h = ',num2str(h),', p = ',num2str(p)])
