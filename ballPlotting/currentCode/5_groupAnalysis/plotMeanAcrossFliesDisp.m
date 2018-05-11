function plotMeanAcrossFliesDisp(prefixCode,allFlies,plotSEM,freqSep,saveQ,figName,allTrials,plotMean,varargin)

%% Get plot data
plotData = multiFlyAnalysis(prefixCode,allTrials);

close all

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

if strcmp(prefixCode,'Diag')  
    colorSet1 = distinguishable_colors(4,'w');
elseif strcmp(prefixCode,'Cardinal')
    colorSet1 = distinguishable_colors(5,'w');
else
    [colorSet1,colorSet2] = colorSetImport;
end

%% Open figure
goFigure;

% Plot each fly separately
if allFlies == 'y'
    for stim = 1:plotData.numStim
        if plotMean == 'n'
            hfl = plot(squeeze(avgAcrossTrials(:,stim,:,1))',squeeze(avgAcrossTrials(:,stim,:,2))','Color',colorSet1(stim,:),'Linewidth',2);
        else
            plot(squeeze(avgAcrossTrials(:,stim,:,1))',squeeze(avgAcrossTrials(:,stim,:,2))','Color',colorSet1(stim,:),'Linewidth',2)
        end
        hold on
    end
end

if plotMean == 'y'
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
                hfl(stim) = plot(mean(squeeze(avgAcrossTrials(:,stim,:,1)),1)',mean(squeeze(avgAcrossTrials(:,stim,:,2)),1)','Color','k','Linewidth',5);
                figure(2)
                hfl(stim) = plot(mean(squeeze(avgAcrossTrials(:,stim,:,1)),1)',mean(squeeze(avgAcrossTrials(:,stim,:,2)),1)','Color','k','Linewidth',5);
            else
                if StimStruct(stim).stimObj.carrierFreqHz == 100
                    colorCount = 1;
                else
                    colorCount = colorCount + 1;
                end
                hfl(stim) = plot(mean(squeeze(avgAcrossTrials(:,stim,:,1)),1)',mean(squeeze(avgAcrossTrials(:,stim,:,2)),1)','Color',colorSet2(colorCount,:),'Linewidth',3);
            end
        else
            hfl(stim) = plot(mean(squeeze(avgAcrossTrials(:,stim,:,1)),1)',mean(squeeze(avgAcrossTrials(:,stim,:,2)),1)','Color',colorSet2(stim,:),'Linewidth',3);
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
if freqSep == 'y'
    figure(1);
    applyPlotSettings(prefixCode,{plotData.legendText{sineIdx}},plotData.numFlies,hfl(sineIdx),plotData.numTrialsPerFly)
    figure(2);
    applyPlotSettings(prefixCode,{plotData.legendText{pipIdx}},plotData.numFlies,hfl(pipIdx),plotData.numTrialsPerFly)
else
    applyPlotSettings(prefixCode,plotData.legendText,plotData.numFlies,hfl,plotData.numTrialsPerFly)
end


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
        figure(i)
        filename = [figPath,'\',figName,'_',statusStr,'.pdf'];
        export_fig(filename,'-pdf','-painters')
    end
end

end


function applyPlotSettings(prefixCode,legendText,numFlies,hfl,numTrialsPerFly)
% Plot settings
bottomAxisSettings;

% Axis limits
symAxisY(gca);
xlim([-3 3])
ylim([-60 60])

% Labels
xlabel('X Displacement (mm)')
ylabel('Y Displacement (mm)','rotation',90,'VerticalAlignment','bottom','HorizontalAlignment','center')
% title(prefixCode)

% Text showing n's
% yTxtPos = min(ylim)+10;
% text(-2,yTxtPos,{['Number of flies = ',num2str(numFlies)];['Number of trials per fly = ',num2str(numTrialsPerFly)]})

% Legend
% legend(hfl,legendText,'Location','eastoutside')
% legend('boxoff')

% Fontsize 
set(findall(gcf,'-property','FontSize'),'FontSize',30)

end