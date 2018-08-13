function [meanLatVel, meanVelChange] = plotMeanAcrossFliesVel(prefixCodes,allFlies,plotSEM,freqSep,saveQ,figName,allTrials,plotMean,stimToPlotAllExpts,figNum,varargin)

close all

if ~iscell(prefixCodes)
    prefixCodes = {prefixCodes};
end
if exist('stimToPlotAllExpts','var')
    if ~iscell(stimToPlotAllExpts)
        stimToPlotAllExpts = {stimToPlotAllExpts};
    end
end
if ~exist('figNum','var')
    figNum = 0;
end

analysisSettings = getAnalysisSettings;

goFigure(1);
styleCount = 0;
styles = {'-';'--'};

%% Loop through experiments
for exptNum = 1:length(prefixCodes)
    
    clear temp
    prefixCode = prefixCodes{exptNum};
    if exist('stimToPlotAllExpts','var')
        stimToPlot = stimToPlotAllExpts{exptNum};
    end
    
    %% Get plot data
    plotData = multiFlyAnalysis(prefixCode,allTrials);
    
    % Get single fly data
    [~,plotDataSingleFly,StimStruct] = getExampleFlies(prefixCode);
    
    %% Determine which stimuli to plot
    if ~exist('stimToPlot','var')
        stimToPlot = 1:plotData.numStim;
    end
    
    %% Average & SEM across flies
    avgAcrossTrials = getAvgAcrossTrials(plotData,stimToPlot);
    
    semAcrossFlies = squeeze(std(avgAcrossTrials,1) / sqrt(plotData.numFlies));
    
    
    
    %% Color settings
    if figNum == 1
        [colorSet1,colorSet2] = colorSetImport;
    elseif strcmp(prefixCode,'Freq')
        if freqSep == 'y'
            numColors = ceil(plotData.numStim/2);
            colorSet2 = linspecer(numColors);
            colorSet1 = linspecer(numColors);
        else
            colorSet2 = distinguishable_colors(plotData.numStim,'w');
        end
    elseif strcmp(prefixCode,'Diag')
        colorSet1 = distinguishable_colors(4,'w');
    elseif strcmp(prefixCode,'Cardinal')
        colorSet1 = distinguishable_colors(5,'w');
    else
        [colorSet1,colorSet2] = colorSetImport;
    end
    
    %% Open figure
    figure(1)
    hold on
    
    %% Make subplots tight
    subplot = @(m,n,p) subtightplot (m, n, p, [0.025 0.025], [0.15 0.01], [0.15 0.02]);
    
    %% Plot stimulus for the first figure only
    if figNum == 1 && exptNum == 1
        ax(1) = subplot(3,1,1);
        
        % Normalize to max intensity
        stimMax = max(abs(plotDataSingleFly.stimulus(1,:)));
        
        % Plot
        plot(plotDataSingleFly.stimTimeVector(1,:),plotDataSingleFly.stimulus(1,:)./stimMax,'k')
        
        % Figure settings
        ylim([-1,1])
        set(gca,'yTick',[-0.5, 0.5])
        noAxisSettings('w');
%         ylabel({'Stimulus';'a.u.'},'HorizontalAlignment','right','VerticalAlignment','middle');
    end
    
    %% Plot forward and lateral velocity
    % Loop through dimensions
    for dim = 1:2
        
        % Specify subolot
        if figNum == 1
            ax(dim+1) = subplot(3,1,dim+1);
        else
            ax(dim) = subplot(2,1,dim);
        end
        hold on
        
        % Plot shaded area
        if ~strcmp(prefixCode,'Freq') && exptNum == 1
            shadestimArea(plotDataSingleFly,1,-50,50);
        end
        
        % Plot each fly separately
        if allFlies == 'y'
            for stim = 1:length(stimToPlot)
                if plotMean == 'n'
                    hfl = plot(plotData.time,squeeze(avgAcrossTrials(:,stim,:,dim))','Color',colorSet1(stim,:),'Linewidth',2);
                else
                    plot(plotData.time,squeeze(avgAcrossTrials(:,stim,:,dim))','Color',colorSet1(stim,:),'Linewidth',2)
                end
                hold on
            end
        end
        
        % Plot mean across flies
        if plotMean == 'y'
            pipIdx = [];
            sineIdx = [];
            for stim = 1:plotData.numStim
                
                if stim <= 10 
                    styleCount = 1;
                else
                    styleCount = 2;
                end
                    
                % Plotting different stimuli in freq experiment in different plots
                if freqSep == 'y'
                    
                    
                    if strcmp(StimStruct(stim).stimObj.class,'SineWave')
                        goFigure(1)
                        subplot(2,1,dim)
                        sineIdx = [sineIdx,stim];
                        if stim == 1 && exptNum == 1
                            shadestimArea(plotDataSingleFly,1,-50,50);
                        end
                    elseif strcmp(StimStruct(stim).stimObj.class,'PipStimulus')
                        goFigure(2)
                        subplot(2,1,dim)
                        pipIdx = [pipIdx,stim];
                        if stim == 6 && exptNum == 1
                            shadestimArea(plotDataSingleFly,1,-50,50);
                        end
                    end
                    if strcmp(StimStruct(stim).stimObj.class,'noStimulus')
                        figure(1)
                        hfl(stim) = plot(plotData.time,mean(squeeze(avgAcrossTrials(:,stim,:,dim)),1)','Color','k','Linewidth',5);
                        figure(2)
                        hfl(stim) = plot(plotData.time,mean(squeeze(avgAcrossTrials(:,stim,:,dim)),1)','Color','k','Linewidth',5);
                    else
                        if StimStruct(stim).stimObj.carrierFreqHz == 100
                            colorCount = 1;
                        else
                            colorCount = colorCount + 1;
                        end
                        hfl(stim) = plot(plotData.time,mean(squeeze(avgAcrossTrials(:,stim,:,dim)),1)','Color',colorSet2(colorCount,:),'Linewidth',3,'Linestyle',styles{styleCount});
                    end
                    
                    % None Freq Experiments
                else
                    hfl(stim) = plot(plotData.time,mean(squeeze(avgAcrossTrials(:,stim,:,dim)),1)','Color',colorSet2(stim,:),'Linewidth',3);
                end
                hold on
            end
            
            % Plot SEM
            if plotSEM == 'y'
                x = mean(squeeze(avgAcrossTrials(:,stim,:,1)),1)';
                y = mean(squeeze(avgAcrossTrials(:,stim,:,2)),1)';
                error = semAcrossFlies(stimNum,:,1);
                hold on
                eh{stim} = plotError(x,y,error);
                uistack(eh{stim},'bottom')
            end
        end
        
        
        %% Apply settings to all figures
        if freqSep == 'y' && figNum ~= 1
            figure(1);
            applyPlotSettings(prefixCode,{plotData.legendText{sineIdx}},plotData.numFlies,hfl(sineIdx),plotData.numTrialsPerFly,dim,figNum)
            figure(2);
            applyPlotSettings(prefixCode,{plotData.legendText{pipIdx}},plotData.numFlies,hfl(pipIdx),plotData.numTrialsPerFly,dim,figNum)
        else
            applyPlotSettings(prefixCode,plotData.legendText,plotData.numFlies,hfl,plotData.numTrialsPerFly,dim,figNum)
        end
        
        linkaxes(ax(:),'x')
        
    end
    
    
    
    if exptNum == length(prefixCodes)
        %% Save figures
        % Make figure name
        if ~exist('figName','var')
            figName = '';
        end
        statusStr = checkRepoStatus;
        % Save figures
        if saveQ == 'y'
            figPath = 'D:\ManuscriptData\summaryFigures';
            mkdir(figPath);
            n = numFigs;
            for i = 1:n
                if strcmp(prefixCode,'Freq')
                    figure(i)
                    if i == 1
                        filename = [figPath,'\',figName,'_','Tones','_',statusStr,'.pdf'];
                    elseif i == 2
                        filename = [figPath,'\',figName,'_','Pips','_',statusStr,'.pdf'];
                    end
                else
                    filename = [figPath,'\',figName,'_',statusStr,'.pdf'];
                end
                export_fig(filename,'-pdf','-painters')
            end
        end
    end
end

if figNum == 7
    %     %% Make lateral velocity box plot
    %     if ~strcmp(prefixCode,'Freq')
    %
    %         figure(2);
    %         hold on
    %         analysisSettings = getAnalysisSettings;
    %
    %         % Plot individual flies
    %         for stim = 1:length(stimToPlot)
    %             % Third dimension is time
    %             plot(stim,squeeze(avgAcrossTrials(:,stim,analysisSettings.velInd,1)),'o','MarkerEdgeColor',colorSet1(stim,:),'MarkerFaceColor',colorSet1(stim,:));
    %             % Plot mean
    %             plot([stim-0.2,stim+0.2],repmat(mean(squeeze(avgAcrossTrials(:,stim,analysisSettings.velInd,1)),1),[1,2]),'k');
    %
    %             errorbar(stim,mean(squeeze(avgAcrossTrials(:,stim,analysisSettings.velInd,1)),1),semAcrossFlies(stim,analysisSettings.velInd,1),'k')
    %         end
    %     end
    %
    %     noXAxisSettings('w')
    %     ylabel({'Lateral';'velocity';'mm/s'})
    %     figPos = get(gcf,'Position');
    %     figPos(3) = figPos(3)/2;
    %     set(gcf,'Position',figPos)
    %     xlim([0 4])
    %
    %     if exptNum == length(prefixCodes)
    %         % Save figure
    %         filename = [figPath,'\',prefixCode,'_','meanLatVelQuant','_',statusStr,'.pdf'];
    %         export_fig(filename,'-pdf','-painters')
    %     end
    %
    %
    %     %% Make forward velocity change box plot
    %     if ~strcmp(prefixCode,'Freq')
    %         figure;
    %         hold on
    %         analysisSettings = getAnalysisSettings;
    %
    %
    %         % Plot individual flies
    %         for stim = 1:length(stimToPlot)
    %             velChange = -(avgAcrossTrials(:,stim,analysisSettings.forwardVelIndAfter,2)-avgAcrossTrials(:,stim,analysisSettings.forwardVelIndBefore,2));
    %
    %             % Third dimension is time
    %             plot(stim,velChange,'o','MarkerEdgeColor',colorSet1(stim,:),'MarkerFaceColor',colorSet1(stim,:));
    %             % Plot mean
    %             plot([stim-0.2,stim+0.2],repmat(mean(velChange),[1,2]),'k');
    %             sem = squeeze(std(velChange,1) / sqrt(plotData.numFlies));
    %             errorbar(stim,mean(velChange),sem,'k')
    %         end
    %
    %         noXAxisSettings('w')
    %         ylabel({'Decrease in';'forward';'velocity';'(mm/s)'})
    %         figPos = get(gcf,'Position');
    %         figPos(3) = figPos(3)/2;
    %         set(gcf,'Position',figPos)
    %         xlim([0 4])
    %
    %         % Save figure
    %         filename = [figPath,'\',prefixCode,'_','meanForwardVelQuant','_',statusStr,'.pdf'];
    %         export_fig(filename,'-pdf','-painters')
    %     end
    
    %% Make mirrored lateral velocity box plot
    figure;
    hold on
    analysisSettings = getAnalysisSettings;
    
    % Plot individual flies
    for stim = 1:length(stimToPlot)
        if stim == 1
            latVel(stim,:) = squeeze(avgAcrossTrials(:,stim,analysisSettings.velInd,1));
        else
            latVel(stim,:) = -squeeze(avgAcrossTrials(:,stim,analysisSettings.velInd,1));
        end
    end
    
    meanLatVel = mean(latVel);
    semLatVel = std(meanLatVel,1) / sqrt(plotData.numFlies);
    
    % Third dimension is time
    plot(1,meanLatVel,'o','MarkerEdgeColor',colorSet1(stim,:),'MarkerFaceColor',colorSet1(stim,:));
    % Plot mean
    plot([1-0.2,1+0.2],repmat(mean(meanLatVel),[1,2]),'k');
    
    errorbar(1,mean(meanLatVel),semLatVel,'k')
    
    noXAxisSettings('w')
    ylabel({'Lateral velocity';'towards speaker';'(mm/s)'})
    figPos = get(gcf,'Position');
    figPos(3) = figPos(3)/2;
    set(gcf,'Position',figPos)
    xlim([0 2])
    ylim([0 4])
    
    % Save figure
    filename = [figPath,'\',prefixCode,'_','avgLatVelQuant','_',statusStr,'.pdf'];
    export_fig(filename,'-pdf','-painters')
    
    %% Make avg forward velocity change box plot
    figure;
    hold on
    analysisSettings = getAnalysisSettings;
    
    % Plot individual flies
    clear velChange
    for stim = 1:length(stimToPlot)
        velChange(stim,:) = -(avgAcrossTrials(:,stim,analysisSettings.forwardVelIndAfter,2)-avgAcrossTrials(:,stim,analysisSettings.forwardVelIndBefore,2));
    end
    
    meanVelChange = mean(velChange);
    sem = squeeze(std(meanVelChange,1) / sqrt(plotData.numFlies));
    
    % Third dimension is time
    plot(1,meanVelChange,'o','MarkerEdgeColor',colorSet1(stim,:),'MarkerFaceColor',colorSet1(stim,:));
    % Plot mean
    plot([1-0.2,1+0.2],repmat(mean(meanVelChange),[1,2]),'k');
    errorbar(1,mean(meanVelChange),sem,'k')
    
    noXAxisSettings('w')
    ylabel({'Decrease in';'forward';'velocity';'(mm/s)'})
    figPos = get(gcf,'Position');
    figPos(3) = figPos(3)/2;
    set(gcf,'Position',figPos)
    xlim([0 4])
    ylim([0 20])
    
    % Save figure
    filename = [figPath,'\',prefixCode,'_','avgForwardVelQuant','_',statusStr,'.pdf'];
    export_fig(filename,'-pdf','-painters')
end

if figNum == 1
    %% Make histograms
    goFigure;
    numRows = plotData.numStim;
    numCols = plotData.numFlies;
    spIndex = reshape(1:numCols*numRows, numCols, numRows).';
    
    subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.2 0.05], [0.1 0.01]);
    
    bins = -41:2:41;
    
    plotCount = 0;
    for fly = 1:plotData.numFlies
        for stim = stimToPlot
            plotCount = plotCount + 1;
            subplot(numRows,numCols,spIndex(plotCount))
            % PlotData.vel dims = stim x trials x time x dim
            histVelData = squeeze(plotData.vel{fly}(stim,:,analysisSettings.velInd,1));
            h = histogram(histVelData,bins,'FaceColor',colorSet1(stim,:));
            h.Normalization = 'probability';
            % Plot settings
            if stim == 1
                title(['Fly ',num2str(fly)])
            end
            if fly == 1 && stim ~= plotData.numStim
                noXAxisSettings('w');
                set(gca,'XColor','k')
            elseif fly ~= 1 && stim == plotData.numStim
                noYAxisSettings('w');
            elseif fly == 1 && stim == plotData.numStim
                bottomAxisSettings;
            else
                noAxisSettings('w');
                set(gca,'XColor','k')
            end
            xlim([-30 30])
            ylim([0 0.8])
            set(gca,'xTick',[-20,0,20])
            set(gca,'yTick',[0, 0.3, 0.6])
        end
    end
    
    suplabel('lateral velocity (mm/s)','x')
    suplabel('probability','y')
    set(findall(gcf,'-property','FontSize'),'FontSize',30)
    
    % Save figure
    filename = [figPath,'\',prefixCode,'_','latVelHistograms','_',statusStr,'.pdf'];
    export_fig(filename,'-pdf','-painters')
end

end


function applyPlotSettings(prefixCode,legendText,numFlies,hfl,numTrialsPerFly,dim,figNum)
% Plot settings
bottomAxisSettings;

% Axis limits
symAxisY(gca);
if dim == 1
    noXAxisSettings('w');
    ylim([-12 12])
    if strcmp(prefixCode,'Freq') && figNum ~= 1
        ylim([-5 5])
    elseif strcmp(prefixCode,'LeftGlued') || strcmp(prefixCode,'RightGlued')
        ylim([-7.5 7.5])
    end
    set(gca,'yTick',[-5, 5])
    set(gca,'Layer','top')
    set(gca,'XColor','white')
else
    bottomAxisSettings;
    ylim([-1 40])
    if strcmp(prefixCode,'Freq') && figNum ~= 1
        ylim([-1 20])
    end
    set(gca,'yTick',[0, 15, 30])
    xlabel('Time (s)')
    set(gca,'Layer','top')
end

% Shorter x axis if not figure 1
xlim([1 3.5])


% Labels
if dim == 1
    direction = 'lateral';
else
    direction = 'forward';
end
ylabel({direction;'Velocity';'(mm/s)'},'HorizontalAlignment','right','VerticalAlignment','middle')

% ylabel([direction,'Velocity (mm/s)'],'rotation',90,'VerticalAlignment','bottom','HorizontalAlignment','right')
% title({prefixCode;['Number of flies = ',num2str(numFlies),', Number of trials per fly = ',num2str(numTrialsPerFly)]})
%
% % Legend
% legend(hfl,legendText,'Location','eastoutside')
% legend('boxoff')

% Fontsize
set(findall(gcf,'-property','FontSize'),'FontSize',30)

end