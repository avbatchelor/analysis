function fig7QuantVel(prefixCode,allTrials,figName,dim)

%% Get plot data
plotData = multiFlyAnalysis(prefixCode,allTrials);
    
%% Average & SEM across flies
stimToPlot = 1:20;
avgAcrossTrials = getAvgAcrossTrials(plotData,stimToPlot);
    
%% Import colors
% [colorSet1,colorSet2] = colorSetImport;
numColors = ceil(plotData.numStim/2);
colorSet1 = linspecer(numColors);

%% Make box plot
analysisSettings = getAnalysisSettings;

%% Close figures 
close all

%% Initialize variables
plotCount = 0;
sineIdxs = [1:5,11:15];
pipIdxs = [6:10,16:20];
mirrorIdxs = [1:5,6:10,1:5,6:10];
flyMeans = cell(10,1);

%% Group together the same stimulus types 
for stim = stimToPlot
    
    % Get the mirror idx for this number 
    mirrorIdx = mirrorIdxs(stim);
    
    %% Plot individual expts
    % Dimensions: flies x stim x time x dim
    if dim == 1
        if stim < 11
            flyMeans{mirrorIdx} = [flyMeans{mirrorIdx};avgAcrossTrials(:,stim,analysisSettings.velInd,dim)];
        elseif stim > 10
            flyMeans{mirrorIdx} = [flyMeans{mirrorIdx},-avgAcrossTrials(:,stim,analysisSettings.velInd,dim)];
        end
    elseif dim == 2
        velChange = -(avgAcrossTrials(:,stim,analysisSettings.forwardVelIndAfter,dim)-avgAcrossTrials(:,stim,analysisSettings.forwardVelIndBefore,dim));
        flyMeans{mirrorIdx} = [flyMeans{mirrorIdx},velChange];
    end
    
end

%% Calculate means
for stimType = 1:10
    mirroredMeans(stimType,:) = mean(flyMeans{stimType},2);
end    
    
%% Plot figure 
for plotNum = 1:2
    goFigure(plotNum);
    subtightplot (1, 1, 1, [0.025 0.025], [0.5 0.01], [0.1 0.01]);
    hold on 
    
    if plotNum == 1
        idxs = 1:5; 
    else 
        idxs = 6:10;
    end
    plotCount = 0;
    for j = idxs
        plotCount = plotCount +1 ; 
        plot(plotCount,mirroredMeans(j,:),'o','MarkerEdgeColor',colorSet1(plotCount,:),'MarkerFaceColor',colorSet1(plotCount,:));
        
        % Calculate mean and sem 
        meanAcrossFlies = mean(mirroredMeans(j,:));
        semAcrossFlies = std(mirroredMeans(j,:)) / sqrt(length(mirroredMeans(j)));
        
        % Plot mean 
        plot([plotCount-0.2,plotCount+0.2],repmat(meanAcrossFlies,[1,2]),'k');
        % Plot error bar
        errorbar(plotCount,meanAcrossFlies,semAcrossFlies,'k')
    end
    
    if plotNum == 1
        applySettingsAndSave('Tones',dim,figName)
    else 
        applySettingsAndSave('Pips',dim,figName)
    end
    
end

end

function applySettingsAndSave(stimType,dim,figName)
%% Plot settings
if dim == 1
    ylabel({'Lateral velocity';'towards speaker';'(mm/s)'})
else
    ylabel({'Decrease in';'forward';'velocity';'(mm/s)'})
    ylim([-1 30])
    set(gca,'YTick',[0 10 20])
end
xlim([0.5 5+0.5])
labels = {'100','140','200','225','300','800'};
set(gca,'XTick',1:5,'XTickLabel',labels);
set(gca,'Box','off','TickDir','out')
set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')
xlabel('Carrier Frequency (Hz)')
% Position settings
pbaspect([1 2 1])
set(findall(gcf,'-property','FontSize'),'FontSize',16)


%% Save figure
statusStr = checkRepoStatus;
figPath = 'D:\ManuscriptData\summaryFigures';
filename = [figPath,'\',figName,'_',stimType,'_',statusStr,'.pdf'];
export_fig(filename,'-pdf','-painters')

end