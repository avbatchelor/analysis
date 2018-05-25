function velCorr(prefixCodes,allTrials,stimToPlotAllExpts,varargin)

close all

if ~iscell(prefixCodes)
    prefixCodes = {prefixCodes};
end
if exist('stimToPlotAllExpts','var')
    if ~iscell(stimToPlotAllExpts)
        stimToPlotAllExpts = {stimToPlotAllExpts};
    end
end

subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.15 0.01], [0.15 0.01]);


analysisSettings = getAnalysisSettings;

stimOrder = {'45';'- 45';'no stim'};

%% Loop through experiments
for exptNum = 1:length(prefixCodes)
    
    goFigure;

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
    
    %% Color settings
    numRows = length(stimToPlot);
    numCols = plotData.numFlies;
    plotCount = 0;
    
    for stim = stimToPlot
        for fly = 1:plotData.numFlies

            % Process data. Dimensions are: stim x trials x time x dimensions
            velocities = plotData.vel{fly};
            latVel = velocities(stim,:,analysisSettings.velInd,1);
            forwardChange = -(velocities(stim,:,analysisSettings.forwardVelIndAfter,2)-velocities(stim,:,analysisSettings.forwardVelIndBefore,2));
            
            % Plot data
            plotCount = plotCount + 1;
            ax(plotCount) = subplot(numRows,numCols,plotCount);
            plot(forwardChange,latVel,'.')
            hold on 
            
            % Plot settings
            xlim([-50 50])
            ylim([-50 50])
            pbaspect([1,1,1])
%             ax.XAxisLocation = 'origin';
%             ax.YAxisLocation = 'origin';
            plot([0 0],[-50 50],'k')
            plot([-50 50],[0 0],'k')
            set(gca,'Box','off','TickDir','out')
            set(gca,'YTick',[-25,0,25],'XTick',[-25,0,25])
            
            if fly == 1
                ylabel(['Stim: ',stimOrder{find(stimToPlot == stim)}])
            end
            if fly == plotData.numFlies && stim == stimToPlot(end)
                suplabel('Decrease in forward velocity (mm/s)','x')
                suplabel('Lateral velocity (mm/s)','y')
                suptitle(prefixCode)
                for i = 1:plotData.numFlies
                    title(ax(i),['Fly ',num2str(i)])
                end
            end
            
            
        end
    end
    
    linkaxes(ax(:))
    
    %% Save figure
    statusStr = checkRepoStatus;
    figPath = 'D:\ManuscriptData\summaryFigures';
    filename = [figPath,'\','suppForwardLatCorrelation','_',prefixCode,'_',statusStr,'.pdf'];
    export_fig(filename,'-pdf','-painters')
end

end


