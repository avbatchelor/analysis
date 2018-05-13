function plotMeanDispGrid(prefixCode,freqSep,figName,allTrials,stimToPlot,varargin)

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

avgAcrossTrialsVel = getAvgAcrossTrials(plotData);

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

%% Subplot settings
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.1 0.075], [0.1 0.01]);

%% Open figure
goFigure;

for  i = 1:10
    subplot(3,5,i)
    shadestimArea(plotDataSingleFly,1,-50,50);
end

% Plot each fly separately
for fly = 1:plotData.numFlies
    for stim = stimToPlot
        
        subplot(3,5,fly)
        hold on
        plot(plotData.time,squeeze(avgAcrossTrialsVel(fly,stim,:,1))','Color',colorSet1(stim,:),'Linewidth',2);
        
        % settings 
        if strcmp(prefixCode,'Diag')
            ylim([-6 6])
        else
            ylim([-10 10])
        end
        xlim([2.1608-1.5,2.1608+1.5])
%         pbaspect([1,1,1])
        title(['Fly ',num2str(fly)])
        if fly == 1
            noXAxisSettings('w');
            ylabel({'Lateral','velocity','(mm/s)'})
            set(gca,'YTick',[-4 0 4])
        else
            noAxisSettings('w');
        end

        subplot(3,5,plotData.numFlies + fly)
        hold on
        plot(plotData.time,squeeze(avgAcrossTrialsVel(fly,stim,:,2))','Color',colorSet1(stim,:),'Linewidth',2);
        
        % settings 
        if strcmp(prefixCode,'Diag')
            ylim([0 26])
        else
            ylim([0 32])
        end
        xlim([2.1608-1.5,2.1608+1.5])
%         pbaspect([1,1,1])
        if fly == 1
            noXAxisSettings('w');
            ylabel({'Forward','velocity','(mm/s)'})
            set(gca,'YTick',[0 10 20])
        else
            noAxisSettings('w');
        end
        
        if fly == 1
            xStart = 3;
            xEnd = 3.5;
            yStart = 7.5;
            yEnd = 7.5;
            xText = '0.5s';
            yText = '';
            scalebar(xStart,xEnd,yStart,yEnd,xText,yText)
        end

        subplot(3,5,2*plotData.numFlies + fly)
        hfl = plot(squeeze(avgAcrossTrials(fly,stim,:,1))',squeeze(avgAcrossTrials(fly,stim,:,2))','Color',colorSet1(stim,:),'Linewidth',2);
        hold on
        
        % Axis limits
        symAxisY(gca);
        if strcmp(prefixCode,'Diag')
            ylim([-50 50])
            xlim([-1.8 1.8])
        else
            ylim([-60 60])
            xlim([-3.1 3.1])
        end
%         pbaspect([1,1,1])
        if fly == 1
            noXAxisSettings('w');
            ylabel({'Y Displacement','(mm)'})
            set(gca,'YTick',[-25 0 25])
        else 
            noAxisSettings('w');
        end
    end
    
    if fly == 1
        xStart = 0.75;
        xEnd = 1.75;
        yStart = -30;
        yEnd = -30;
        xText = '1 mm';
        yText = '';
        scalebar(xStart,xEnd,yStart,yEnd,xText,yText)
    end
    
    
    
    %     noAxisSettings('w');
    
end


%% Plot settings



% % Labels
% xlabel('X Displacement (mm)')
% ylabel('Y Displacement (mm)','rotation',90,'VerticalAlignment','bottom','HorizontalAlignment','center')
%
% % Fontsize
% set(findall(gcf,'-property','FontSize'),'FontSize',30)

% tightfig;

%% Save figures
statusStr = checkRepoStatus;
% Save figures
figPath = 'D:\ManuscriptData\summaryFigures';
filename = [figPath,'\',figName,'_',statusStr,'.pdf'];
export_fig(filename,'-pdf','-painters')

end