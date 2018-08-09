function plotMeanAcrossFliesDisp(prefixCodes,allFlies,plotSEM,freqSep,saveQ,figName,allTrials,plotMean,stimToPlotAllExpts,figNum,varargin)

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

close all
goFigure(1)
styles = {'-','--'};

%% Loop through experiments
for exptNum = 1:length(prefixCodes)
    
    clear temp  
    prefixCode = prefixCodes{exptNum};
    if exist('stimToPlotAllExpts','var') 
        stimToPlot = stimToPlotAllExpts{exptNum};
    end
    
    %% Get data 
    % Get plot data
    plotData = multiFlyAnalysis(prefixCode,allTrials);

    % Get single fly data
    [~,plotDataSingleFly,StimStruct] = getExampleFlies(prefixCode);

    
    %% Setup which stim to plot
    if ~exist('stimToPlot','var')
        stimToPlot = 1:plotData.numStim; 
    end
    % Reverse the order of the stimuli to plot so no stimulus is first 
    if figNum == 1
        stimToPlot = fliplr(stimToPlot);
    end
    %% Average & SEM across flies

    avgAcrossTrials = cellfun(@(x) squeeze(mean(x,2)),plotData.disp,'UniformOutput',false);
    for i = 1:plotData.numFlies
        temp(i,:,:,:) = avgAcrossTrials{i}(stimToPlot,:,:);
    end
    avgAcrossTrials = temp;

    semAcrossFlies = squeeze(std(avgAcrossTrials,1) / sqrt(plotData.numFlies));


    %% Color settings
    
    if figNum == 1
        green = [91,209,82]./255;
        purple = [178,102,255]./255;
        colorSet1 = [purple;green];
    elseif strcmp(prefixCode,'Diag')
        colorSet1 = distinguishable_colors(4,'w');
    elseif strcmp(prefixCode,'Cardinal')
        colorSet1 = distinguishable_colors(5,'w');
    elseif strcmp(prefixCode,'Freq')
        if freqSep == 'y'
            numColors = ceil(plotData.numStim/2);
            colorSet2 = linspecer(numColors);
        else
            colorSet2 = distinguishable_colors(plotData.numStim,'w');
        end
    else
        [colorSet1,~] = colorSetImport;
    end

    % [~,colorSet2] = colorSetImport;


    %% Open figure

    % Plot each fly separately
    if allFlies == 'y'
        for stim = 1:length(stimToPlot)
            hold on 
            if plotMean == 'n'
                hfl = plot(squeeze(avgAcrossTrials(:,stim,:,1))',squeeze(avgAcrossTrials(:,stim,:,2))','Color',colorSet1(stim,:),'Linewidth',2);
            else
                plot(squeeze(avgAcrossTrials(:,stim,:,1))',squeeze(avgAcrossTrials(:,stim,:,2))','Color',colorSet1(stim,:),'Linewidth',2)
            end


        end
    end


    if plotMean == 'y'
        % Plot mean across flies
        pipIdx = [];
        sineIdx = [];
        for stim = stimToPlot
            if stim <= 10
                styleCount = 1;
            else
                styleCount = 2;
            end
            
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
                    hfl(stim) = plot(mean(squeeze(avgAcrossTrials(:,stim,:,1)),1)',mean(squeeze(avgAcrossTrials(:,stim,:,2)),1)','Color',colorSet2(colorCount,:),'Linewidth',3,'Linestyle',styles{styleCount});
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
        applyPlotSettings(prefixCode,{plotData.legendText{sineIdx}},plotData.numFlies,hfl(sineIdx),plotData.numTrialsPerFly,figNum)
        figure(2);
        applyPlotSettings(prefixCode,{plotData.legendText{pipIdx}},plotData.numFlies,hfl(pipIdx),plotData.numTrialsPerFly,figNum)
    else
        applyPlotSettings(prefixCode,plotData.legendText,plotData.numFlies,hfl,plotData.numTrialsPerFly,figNum)
    end
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
        if strcmp(prefixCode,'Freq')
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


function applyPlotSettings(prefixCode,legendText,numFlies,hfl,numTrialsPerFly,figNum)
% Plot settings
bottomAxisSettings;

% Axis limits
symAxisY(gca);
if figNum == 1
    xlim([-3.3 3.3])
elseif strcmp(prefixCode,'LeftGlued') || strcmp(prefixCode,'RightGlued')
    xlim([-3.5 3.5])
else 
    xlim([-3 3])
end
if strcmp(prefixCode,'Freq') && figNum ~= 1
    xlim([-1.5 1.5])
end
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