function forwardSpeedHistogram(prefixCodes,allTrials,stimToPlotAllExpts,varargin)

close all

if ~iscell(prefixCodes)
    prefixCodes = {prefixCodes};
end
if exist('stimToPlotAllExpts','var')
    if ~iscell(stimToPlotAllExpts)
        stimToPlotAllExpts = {stimToPlotAllExpts};
    end
end

analysisSettings = getAnalysisSettings;
gray = [217,217,217]./255;

goFigure;
%% Loop through experiments
for plotNum = 1:3
    for exptNum = 1:length(prefixCodes)
        
        clear temp
        prefixCode = prefixCodes{exptNum};
        if exist('stimToPlotAllExpts','var')
            stimToPlot = stimToPlotAllExpts{exptNum};
        end
        
        %% Get plot data
        plotData = multiFlyAnalysis(prefixCode,allTrials);
        
        %% Determine which stimuli to plot
        if ~exist('stimToPlot','var')
            stimToPlot = 1:plotData.numStim;
        end
        
        %% Make subplots tight
        subplot = @(m,n,p) subtightplot (m, n, p, [0.025 0.025], [0.25 0.1], [0.15 0.02]);
        
        %% Make histograms
        
        numRows = 1;
        numCols = 3;
        
        bins = -65:2:65;
        subplot(numRows,numCols,plotNum)
        
        % Process data
        clear velocityMat velocityTemp
        histValues = [];
        for fly = 1:plotData.numFlies
            if plotNum == 1
                velocityTemp = plotData.velAllNonSatTrials{fly};
            elseif plotNum == 2
                velocityTemp = squeeze(plotData.vel{fly}(:,:,:,2));
            elseif plotNum == 3
                velocityTemp = plotData.velSlowTrials{fly};
            end
            h = histogram(velocityTemp(:),bins,'FaceColor',gray);
            h.Normalization = 'probability';
            histValues = [histValues;h.Values];
            
            
        end
        counts = mean(histValues);
        histogram('BinEdges',bins,'BinCounts',counts,'FaceColor',gray)
                
        % Plot settings
        if plotNum == 1
            title('All trials')
            bottomAxisSettings;
        elseif plotNum == 2
            title('Fast trials')
            noYAxisSettings;
        elseif plotNum == 3
            title('Slow trials')
            noYAxisSettings;
        end
        xlim([-10 60])
        ylim([0 0.5])
        set(gca,'xTick',[-10,0,10,20,30,40])
        set(gca,'yTick',[0:0.1:0.5])
    end
end

suplabel('Forward velocity (mm/s)','x')
suplabel('Probability','y')
set(findall(gcf,'-property','FontSize'),'FontSize',30)

% Save figure
statusStr = checkRepoStatus;
figPath = 'D:\ManuscriptData\summaryFigures';
filename = [figPath,'\supp_',prefixCode,'_','forwardVelHistograms','_',statusStr,'.pdf'];
export_fig(filename,'-pdf','-painters')
end