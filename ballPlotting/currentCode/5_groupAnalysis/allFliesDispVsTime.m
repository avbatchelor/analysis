function allFliesDispVsTime(prefixCode,allFlies,plotSEM,freqSep,saveQ,figName,allTrials,dim,varargin)

%% Get plot data
plotData = multiFlyAnalysis(prefixCode,allTrials);

%% Average & SEM across flies

avgAcrossTrials = cellfun(@(x) squeeze(mean(x,2)),plotData.disp,'UniformOutput',false);
for i = 1:plotData.numFlies
   temp(i,:,:,:) = avgAcrossTrials{i}; 
end
avgAcrossTrials = temp;

semAcrossFlies = squeeze(std(avgAcrossTrials,1) / sqrt(plotData.numFlies));


%% Color settings
if freqSep == 'y'
    numColors = ceil(plotData.numStim/2);
    colors = linspecer(numColors);
else
    colors = distinguishable_colors(plotData.numStim,'w');
end


%% Open figure
goFigure;

% Plot each fly separately
if allFlies == 'y'
    for stim = 1:plotData.numStim
        plot(plotData.time,squeeze(avgAcrossTrials(:,stim,:,dim))','--','Color',colors(stim,:))
        hold on
    end
end

% Plot mean across flies
pipIdx = [];
sineIdx = [];
for stim = 1:plotData.numStim
    % Plotting different stimuli in freq experiment in different plots
    if freqSep == 'y'
        if strcmp(StimStruct(stim).stimObj.class,'SineWave')
            goFigure(1)
            sineIdx = [sineIdx,stim];
        elseif strcmp(StimStruct(stim).stimObj.class,'PipStimulus')
            goFigure(2)
            pipIdx = [pipIdx,stim];
        elseif strcmp(StimStruct(stim).stimObj.class,'No Stimulus')
            sineIdx = [sineIdx,stim];
            pipIdx = [pipIdx,stim];
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
            hfl(stim) = plot(plotData.time,mean(squeeze(avgAcrossTrials(:,stim,:,dim)),1)','Color',colors(colorCount,:),'Linewidth',3);
        end
    else
        hfl(stim) = plot(plotData.time,mean(squeeze(avgAcrossTrials(:,stim,:,dim)),1)','Color',colors(stim,:),'Linewidth',3);
    end
    hold on
    
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
if freqSep == 'y'
    figure(1);
    applyPlotSettings(prefixCode,{plotData.legendText{sineIdx}},plotData.numFlies,hfl(sineIdx),plotData.numTrialsPerFly,dim)
    figure(2);
    applyPlotSettings(prefixCode,{plotData.legendText{pipIdx}},plotData.numFlies,hfl(pipIdx),plotData.numTrialsPerFly,dim)
else
    applyPlotSettings(prefixCode,plotData.legendText,plotData.numFlies,hfl,plotData.numTrialsPerFly,dim)
end


%% Save figures
% Make figure name
if ~exist('figName','var')
    figName = '';
end
% Save figures
if saveQ == 'y'
    figPath = 'D:\ManuscriptData\summaryFigures';
    mkdir(figPath);
    n = numFigs;
    for i = 1:n
        figure(i)
        filename = [figPath,'\',prefixCode,'_',num2str(i),'_',figName,'.pdf'];
        export_fig(filename,'-pdf','-painters')
    end
end

end


function applyPlotSettings(prefixCode,legendText,numFlies,hfl,numTrialsPerFly,dim)
% Plot settings
bottomAxisSettings;

% Axis limits
symAxisY(gca);
if dim == 1
    ylim([-5 5])
else 
    ylim([0 40])
end

% Labels
if dim == 1
    direction = 'Lateral'; 
else 
    direction = 'Forward';
end
xlabel('Times (s)')
ylabel([direction,'Displacement (mm)'],'rotation',90,'VerticalAlignment','bottom','HorizontalAlignment','center')
title({prefixCode;['Number of flies = ',num2str(numFlies),', Number of trials per fly = ',num2str(numTrialsPerFly)]})

% Legend
legend(hfl,legendText,'Location','eastoutside')
legend('boxoff')

% Fontsize 
set(findall(gcf,'-property','FontSize'),'FontSize',30)

end