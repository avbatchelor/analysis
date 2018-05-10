function mirroredVelocityPlot(prefixCodes,allTrials,labels,figName,dim)

%% Import colors
% [colorSet1,colorSet2] = colorSetImport;
colorSet1 = distinguishable_colors(4,'w');

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
    
    %% Average & SEM across flies
    avgAcrossTrials = getAvgAcrossTrials(plotData);
    semAcrossFlies = squeeze(std(avgAcrossTrials,1) / sqrt(plotData.numFlies));
    
    %% Plot individual expts
    % Dimensions: flies x stim x time x dim 
    if dim == 1
        if stim == 3
            mirroredMean = avgAcrossTrials(:,stim,analysisSettings.velInd,dim);
        elseif isequal(stim,[1,2])
            mirroredMean = mean([avgAcrossTrials(:,1,analysisSettings.velInd,dim), -(avgAcrossTrials(:,2,analysisSettings.velInd,dim))],2); 
        end
    else
        if stim == 3
            % Not averaging across time
            mirroredMean = -(avgAcrossTrials(:,stim,analysisSettings.forwardVelIndAfter,dim)-avgAcrossTrials(:,stim,analysisSettings.forwardVelIndBefore,dim));
            % Averageing across time
            %             mirroredMean = -(mean(squeeze(avgAcrossTrials(:,stim,analysisSettings.forwardVelIndAfter,dim)),2)-mean(squeeze(avgAcrossTrials(:,stim,analysisSettings.forwardVelIndBefore,dim)),2));

        elseif isequal(stim,[1,2])
            % Not averaging across time
            diffStim1 = -(avgAcrossTrials(:,1,analysisSettings.forwardVelIndAfter,dim)-avgAcrossTrials(:,1,analysisSettings.forwardVelIndBefore,dim));
            diffStim2 = -(avgAcrossTrials(:,2,analysisSettings.forwardVelIndAfter,dim)-avgAcrossTrials(:,2,analysisSettings.forwardVelIndBefore,dim));
            % Averaging across time
%             diffStim1 = -(mean(squeeze(avgAcrossTrials(:,1,analysisSettings.forwardVelIndAfter,dim)),2)-mean(squeeze(avgAcrossTrials(:,1,analysisSettings.forwardVelIndBefore,dim)),2));
%             diffStim2 = -(mean(squeeze(avgAcrossTrials(:,2,analysisSettings.forwardVelIndAfter,dim)),2)-mean(squeeze(avgAcrossTrials(:,2,analysisSettings.forwardVelIndBefore,dim)),2));
            mirroredMean = mean([diffStim1,diffStim2],2); 
        end
    end
        
    plot(plotCount,mirroredMean,'o','MarkerEdgeColor',colorSet1(plotCount,:),'MarkerFaceColor',colorSet1(plotCount,:));
    
    % Plot mean
    plot([plotCount-0.2,plotCount+0.2],repmat(mean(mirroredMean),[1,2]),'k');
    
    mirroredSEM = std(mirroredMean) / sqrt(plotData.numFlies);
    errorbar(plotCount,mean(mirroredMean),mirroredSEM,'k')
    
end

if dim == 1
    ylabel({'Lateral';'velocity';'mm/s'})
else
    ylabel({'Decrease in';'forward';'velocity';'mm/s'})
    ylim([-1 30])
    set(gca,'YTick',[0 10 20])
end
xlim([0.5 plotCount+0.5])
set(gca,'XTick',[1:plotCount],'XTickLabel',labels,'XTickLabelRotation',45);
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