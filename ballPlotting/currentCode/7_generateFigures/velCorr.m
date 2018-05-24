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

goFigure(1);
flyMeans = cell([3,1]);
analysisSettings = getAnalysisSettings;

%% Loop through experiments
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
    
    %% Color settings
    
    [colorSet1] = colorSetImport;
    
    
    for stim = 1:length(stimToPlot)
        % Dimensions are: stim x trials x time x dimensions
        velocities = plotData.vel{stim};
        latVel = velocities(stim,:,analysisSettings.velInd,1);
        forwardChange = -(velocities(stim,:,analysisSettings.forwardVelIndAfter,2)-velocities(stim,:,analysisSettings.forwardVelIndBefore,2));
        subplot(3,1,stim)
        plot(forwardChange,latVel,'.')
        xlim([-50 50])
        ylim([-50 50])
        pbaspect([1,1,1])
        set(gca,'Box','off')
        ax = gca; 
        ax.XAxisLocation = 'origin';
        ax.YAxisLocation = 'origin';
    end
    
    %
end


%% Make lateral velocity box plot
figure(1);
hold on

% Plot individual flies
% Third dimension is time
for stim = 1:length(stimToPlot)
    plot(stim,flyMeans{stim},'o','MarkerEdgeColor',colorSet1(stim,:),'Linewidth',2);
    % Plot mean
    meanAcrossFlies = mean(flyMeans{stim});
    semAcrossFlies = std(flyMeans{stim}) / sqrt(19);
    plot([stim-0.2,stim+0.2],repmat(meanAcrossFlies,[1,2]),'k');
    errorbar(stim,meanAcrossFlies,semAcrossFlies,'k')
end

%% Plot settings
noXAxisSettings('w')
ylabel({'Lateral';'velocity';'mm/s'})
figPos = get(gcf,'Position');
figPos(3) = figPos(3)/2;
set(gcf,'Position',figPos)
xlim([0 4])
ylim([-11 11])

%% Save figure
statusStr = checkRepoStatus;
figPath = 'D:\ManuscriptData\summaryFigures';
filename = [figPath,'\','fig1VelQuant','_',statusStr,'.pdf'];
export_fig(filename,'-pdf','-painters')



end


