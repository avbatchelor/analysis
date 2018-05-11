function plotMeanDispGrid(prefixCode,freqSep,figName,allTrials,varargin)

%% Get plot data
plotData = multiFlyAnalysis(prefixCode,allTrials);

close all

%% Average & SEM across flies
avgAcrossTrials = cellfun(@(x) squeeze(mean(x,2)),plotData.disp,'UniformOutput',false);
for i = 1:plotData.numFlies
    temp(i,:,:,:) = avgAcrossTrials{i};
end
avgAcrossTrials = temp;


%% Color settings
if freqSep == 'y'
    numColors = ceil(plotData.numStim/2);
    colors = linspecer(numColors);
else
    colors = distinguishable_colors(plotData.numStim,'w');
end

if strcmp(prefixCode,'Diag')
    colorSet1 = distinguishable_colors(4,'w');
elseif strcmp(prefixCode,'Cardinal')
    colorSet1 = distinguishable_colors(5,'w');
elseif strcmp(prefixCode,'Freq')
    colorSet1 = distinguishable_colors(plotData.numStim,'w');
else
    [colorSet1,colorSet2] = colorSetImport;
end

subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.1 0.075], [0.1 0.01]);

%% Open figure
goFigure;

% Plot each fly separately
for fly = 1:plotData.numFlies 
    subplot(1,5,fly)
    for stim = 1:plotData.numStim
            hfl = plot(squeeze(avgAcrossTrials(fly,stim,:,1))',squeeze(avgAcrossTrials(fly,stim,:,2))','Color',colorSet1(stim,:),'Linewidth',2);
        hold on
    end
    
    if fly == 1
        xStart = 1; 
        xEnd = 2;
        yStart = -30; 
        yEnd = -10; 
        xText = '1 mm';
        yText = '20 mm';
        scalebar(xStart,xEnd,yStart,yEnd,xText,yText)
    end
    
    % Axis limits
    symAxisY(gca);
    xlim([-3 3])
    ylim([-60 60])
    
    % Plot size 
    pbaspect([1,1,1])
    
    noAxisSettings('w');

end

%% Plot settings



% % Labels
% xlabel('X Displacement (mm)')
% ylabel('Y Displacement (mm)','rotation',90,'VerticalAlignment','bottom','HorizontalAlignment','center')
% 
% % Fontsize
% set(findall(gcf,'-property','FontSize'),'FontSize',30)

tightfig;

%% Save figures
statusStr = checkRepoStatus;
% Save figures
figPath = 'D:\ManuscriptData\summaryFigures';
filename = [figPath,'\',figName,'_',statusStr,'.pdf'];
export_fig(filename,'-pdf','-painters')

end