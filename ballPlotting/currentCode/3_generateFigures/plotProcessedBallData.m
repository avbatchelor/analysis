function plotProcessedBallData(prefixCode,expNum,flyNum,flyExpNum,allTrials,sameFig,saveQ,speedThreshold)

%% Put exptInfo in a struct
exptInfo = exptInfoStruct(prefixCode,expNum,flyNum,flyExpNum);

%% Load plot data
% Get paths
[~, ~, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
pPath = getProcessedDataFileName(exptInfo);

% Plot data
fileName = [pPath,fileNamePreamble,'plotData.mat'];
load(fileName);

% Grouped data
fileName = [pPath,fileNamePreamble,'groupedData.mat'];
load(fileName);

%% Load analysis settings
analysisSettings = getAnalysisSettings;
 
%% Create save folder
% fileStem = char(regexp(pPath,'.*(?=flyExpNum)','match'));
% saveFolder = [fileStem,'Figures\'];
% mkdir(saveFolder)

%% Figure prep
% Close figures
close all

% Set colors
gray = [192 192 192]./255;
darkGray = [110 110 110]./255;
colorSet = distinguishable_colors(plotData.numUniqueStim,'w');

% Subplot settings
numCols = 2;
numRows = 7;
spIndex = reshape(1:numCols*numRows, numCols, numRows).';


%% Loop through to plot the correct number of figures

% Make subplots tight
subplot = @(m,n,p) subtightplot (m, n, p, [0.025 0.025], [0.1 0.1], [0.1 0.01]);

if strcmp(sameFig,'y')
    figureIdx = plotData.figureNums.allSameFig;
elseif strcmp(sameFig,'n')
    figureIdx = plotData.figureNums.allDiffFigs;
elseif strcmp(sameFig,'m')
    figureIdx = plotData.figureNums.figByType;
end

%% Plot for each stim Num
for stimNum = 1:plotData.numUniqueStim
    
    %% Set figure number appropriately
    if sameFig == 'y' && stimNum ~= 1
        figure(figureIdx(stimNum));
    else
        goFigure(figureIdx(stimNum));
    end
    
    %% Set colors correctly
    currColor = colorSet(stimNum,:);
    
    %% Plot stimulus
    % Only plot stimulus if it is no stimulus
    if max(plotData.stimulus(stimNum,:)) ~= 0
        % Subplot settings
        sph(1) = subplot (numRows, numCols, spIndex(1));
        
        % Plot
        mySimplePlot(plotData.stimTimeVector(stimNum,:),plotData.stimulus(stimNum,:))
        
        
        % Axis labels
        ylabel({'Stim';'(V)'})
        
        % Axis settings
        noXAxisSettings('w');
        
    end
    %% Plot x speed vs. time
    % Subplot settings
    if stimNum == 1 || sameFig == 'n'
        sph(2) = subplot(numRows, numCols, spIndex(2));
    end
    set(gcf, 'currentaxes',sph(2));
    
    % Plot
    mySimplePlot(sph(2),plotData.dsTime(stimNum,:),plotData.meanXVel(stimNum,:),'Color',currColor,'Linewidth',2)
    if strcmp(allTrials,'y')
        mySimplePlot(plotData.dsTime(stimNum,:),plotData.sampleTrialsXVel{stimNum},'Color',currColor,'Linewidth',0.5)
    end
    %     mySimplePlot(groupedData.dsTime,meanXVel+stdXVel,'Color',colorSet(stimNum,:),'Linewidth',0.5)
    %     mySimplePlot(groupedData.dsTime,meanXVel-stdXVel,'Color',colorSet(stimNum,:),'Linewidth',0.5)
    
    % Axis labels
    ylabel({'Lateral Speed';'(mm/s)'})
    
    % Axis settings
    noXAxisSettings
    moveXAxis
    symAxisY(sph(2))
    shadestimArea(plotData,stimNum)
    
    
    %% Plot y speed vs. time
    % Subplot settings
    if stimNum == 1 || sameFig == 'n'
        sph(3) = subplot(numRows, numCols, spIndex(3));
    end
    hold on
    set(gcf, 'currentaxes',sph(3));
    
    % Plot
    mySimplePlot(sph(3),plotData.dsTime(stimNum,:),plotData.meanYVel(stimNum,:),'Color',currColor,'Linewidth',2)
    if strcmp(allTrials,'y')
        mySimplePlot(plotData.dsTime(stimNum,:),plotData.sampleTrialsYVel{stimNum},'Color',currColor,'Linewidth',0.5)
    end
    %     mySimplePlot(groupedData.dsTime,meanYVel+stdYVel,'Color',colorSet(stimNum,:),'Linewidth',0.5)
    %     mySimplePlot(groupedData.dsTime,meanYVel-stdYVel,'Color',colorSet(stimNum,:),'Linewidth',0.5)
    
    % Axis labels
    ylabel({'Forward Speed';'(mm/s)'})
    
    % Axis settings
    noXAxisSettings
    moveXAxis
    symAxisY(sph(3))
    shadestimArea(plotData,stimNum)
    
    
    %% Plot x displacement vs. time
    % Subplot settings
    if stimNum == 1 || sameFig == 'n'
        sph(4) = subplot(numRows, numCols, spIndex(4));
    end
    hold on
    set(gcf, 'currentaxes',sph(4));
    
    % Plot
    mySimplePlot(sph(4),plotData.dsTime(stimNum,:),plotData.meanXDisp(stimNum,:),'Color',currColor,'Linewidth',2)
    if strcmp(allTrials,'y')
        mySimplePlot(plotData.dsTime(stimNum,:),plotData.sampleTrialsXDisp{stimNum},'Color',currColor,'Linewidth',0.5)
    end
    %     mySimplePlot(groupedData.dsTime,meanXDisp+stdXDisp,'Color',colorSet(stimNum,:),'Linewidth',0.5)
    %     mySimplePlot(groupedData.dsTime,meanXDisp-stdXDisp,'Color',colorSet(stimNum,:),'Linewidth',0.5)
    %
    %     shadedErrorBar(groupedData.dsTime,mean(groupedData.xDisp(stimNumInd,:)),std(groupedData.xDisp(stimNumInd,:)))
    
    % Axis labels
    ylabel({'X Disp';'(mm)'})
    
    % Axis settings
    noXAxisSettings
    moveXAxis
    symAxisY(sph(4))
    shadestimArea(plotData,stimNum)
    
    
    %% Plot y displacement vs. time plot
    % Subplot settings
    if stimNum == 1 || sameFig == 'n'
        sph(5) = subplot (numRows, numCols, spIndex(5));
    end
    hold on
    set(gcf, 'currentaxes',sph(5));
    
    % Plot
    mySimplePlot(sph(5),plotData.dsTime(stimNum,:),plotData.meanYDisp(stimNum,:),'Color',currColor,'Linewidth',2)
    if strcmp(allTrials,'y')
        mySimplePlot(plotData.dsTime(stimNum,:),plotData.sampleTrialsYDisp{stimNum},'Color',currColor,'Linewidth',0.5)
    end
    %     mySimplePlot(groupedData.dsTime,meanYDisp+stdYDisp,'Color',colorSet(stimNum,:),'Linewidth',0.5)
    %     mySimplePlot(groupedData.dsTime,meanYDisp-stdYDisp,'Color',colorSet(stimNum,:),'Linewidth',0.5)
    
    % Axis labels
    ylabel({'Y Disp';'(mm)'})
    xlabel('Time (s)')
    
    % Axis settings
    bottomAxisSettings
    linkaxes(sph(1:5),'x')
    symAxisY(sph(5))
    shadestimArea(plotData,stimNum)
    
    
    %% Plot forward speed histogram
    % Subplot settings
    if stimNum == 1 || sameFig == 'n'
        sph(6) = subtightplot(numRows, numCols, spIndex(6),[0.075 0.075], [0.1 0.1], [0.1 0.01]);
    end
    hold on
    set(gcf, 'currentaxes',sph(6));
    
    % Plot
    histogramBins = analysisSettings.bins;
    histogram(sph(6),plotData.velForHistogram,histogramBins,'EdgeColor','k','FaceColor',gray);
    
    % Axis labels
    xlabel('Forward speed (mm/s)')
    ylabel('Counts')
    
    % Axis settings
    bottomAxisSettings
    xlim([-10 70])
    
    %% Plot avg. trial speed
    % Subplot settings
    if stimNum == 1 || sameFig == 'n'
        sph(7) = subtightplot(numRows, numCols, spIndex([7,14]),[0.075 0.075], [0.1 0.1], [0.1 0.01]);
    end
    hold on
    set(gcf, 'currentaxes',sph(7));
    
    % Plot all trials in gray
    bh1 = bar(sph(7),1:plotData.numTrials,plotData.trialSpeed,'EdgeColor',darkGray,'FaceColor',darkGray);
    
    % Get bar width
    bw = get(bh1,'BarWidth');
    
    % If plotting all trial in same figure, plot fast trials in red
    if strcmp(sameFig,'y')
        % Plot fast trials in red
        bar(sph(7),plotData.fastTrials,plotData.trialSpeed(plotData.fastTrials),'EdgeColor',gray,'FaceColor',gray,'BarWidth',bw);
    else
        stimFastTrials = plotData.trialsSelectedByStimAndSpeed{stimNum};
        bar(sph(7),stimFastTrials,plotData.trialSpeed(stimFastTrials),'EdgeColor',currColor,'FaceColor',currColor,'BarWidth',bw);
    end
    
    % Plot baseline
    line(sph(7),[0,plotData.numTrials],[speedThreshold,speedThreshold],'Color','k')
    
    % Axis labels
    ylabel({'Trial avg speed';'(mm/s)'})
    xlabel('Trial number')
    
    % Axis settings
    bottomAxisSettings
    
    % Title
    %     if mod(stimNum,2)
    %         t1s = ['Successful left trials = ',num2str(length(stimNumInd)),'/',num2str(length(stimSelect))];
    %     else
    %         t2s = ['Successful right trials = ',num2str(length(stimNumInd)),'/',num2str(length(stimSelect))];
    %         title([t1s,'   ',t2s])
    %     end
    
    
    %     %% Plot trial line
    %     % Subplot settings
    %     if stimNum == 1 || sameFig == 'n'
    %         sph(8) = subtightplot(numRows, numCols, spIndex(8:10),[0.075 0.1], [0.1 0.1], [0.1 0.01]);
    %     end
    %     hold on
    %     set(gcf, 'currentaxes',sph(8));
    %
    %     % Plot
    %     plot(sph(8),plotData.xDispLinePlot{stimNum}',plotData.yDispLinePlot{stimNum}','Color',currColor)
    %
    %     % Axis labels
    %     ylabel({'Y disp';'(mm)'})
    %
    %     % Axis settings
    % %     axis(sph(8),'equal')
    %     bottomAxisSettings
    %     sph(8).XLim = [-3 3];
    
    
    
    %% Plot mean X vs mean Y displacement
    % Subplot settings
    if stimNum == 1 || sameFig == 'n'
        sph(9) = subtightplot(numRows, numCols, spIndex(8:10),[0.075 0.15], [0.1 0.1], [0.15 0.15]);
    end
    hold on
    set(gcf, 'currentaxes',sph(9));
    
    % Plot
    plot(sph(9),plotData.meanXDisp(stimNum,:),plotData.meanYDisp(stimNum,:),'Color',currColor,'Linewidth',2)
    if strcmp(allTrials,'y')
        plot(sph(9),plotData.sampleTrialsXDisp{stimNum}',plotData.sampleTrialsYDisp{stimNum}','Color',currColor,'Linewidth',0.5)
    end
    %     plot(meanXDisp+stdXDisp,meanYDisp,'Color',colorSet(stimNum,:),'Linewidth',0.5)
    %     plot(meanXDisp-stdXDisp,meanYDisp,'Color',colorSet(stimNum,:),'Linewidth',0.5)
    
    % Axis labels
    xlabel('X displacement (mm)')
    ylabel({'Y disp';'(mm)'})
    
    % Axis settings
    %     axis(sph(9),'equal')
    bottomAxisSettings
    sph(9).XLim = [-3 3];
    
    %% Plot median X vs median Y displacement
    % Subplot settings
    if stimNum == 1 || sameFig == 'n'
        sph(10) = subtightplot(numRows, numCols, spIndex(11:13),[0.075 0.15], [0.1 0.1], [0.15 0.15]);
    end
    hold on
    set(gcf, 'currentaxes',sph(10));
    
    % Plot
    plot(sph(10),plotData.medianXDisp(stimNum,:),plotData.medianYDisp(stimNum,:),'Color',currColor,'Linewidth',2)
    if strcmp(allTrials,'y')
        plot(sph(10),plotData.sampleTrialsXDisp{stimNum}',plotData.sampleTrialsYDisp{stimNum}','Color',currColor,'Linewidth',0.5)
    end
    %     plot(meanXDisp+stdXDisp,meanYDisp,'Color',colorSet(stimNum,:),'Linewidth',0.5)
    %     plot(meanXDisp-stdXDisp,meanYDisp,'Color',colorSet(stimNum,:),'Linewidth',0.5)
    
    % Axis labels
    xlabel('X displacement (mm)')
    ylabel({'Y disp';'(mm)'})
    
    % Axis settings
    %     axis(sph(9),'equal')
    bottomAxisSettings
    sph(10).XLim = [-3 3];
    
    
    %% Legend and title
    % Legend
    if sameFig == 'y'
        legend(sph(9),plotData.legendText,'Location','eastoutside')
    else
        legend(sph(9),plotData.legendText{stimNum},'Location','best')
    end
    legend('boxoff')
    
    % Title
    suptitle(plotData.sumTitle)
    
    %% Plot trial line in separate figure
    plotLineHist(plotData,currColor,stimNum)
    
    %% Plot angle histogram in separate figure
    beforeDisp = [plotData.xDispLinePlot{stimNum}(:,1),plotData.yDispLinePlot{stimNum}(:,1)];
    afterDisp = [plotData.xDispLinePlot{stimNum}(:,3),plotData.yDispLinePlot{stimNum}(:,3)];
    plotAngleHist(beforeDisp,afterDisp,currColor,plotData,stimNum);
      
    %% Save figures and group pdfs
    % Save figures
    if saveQ == 'y'
        figNum = figureIdx(stimNum);
        figure(figNum)
        if sameFig == 'y' && stimNum == plotData.numUniqueStim
            allFileName = strrep(plotData.saveFileName{1},'flyExpNum001_stim000_to_001.pdf','all_stim.pdf');
            export_fig(allFileName,'-pdf','-painters')
            %             export_fig(allFileName,'-pdf','-q50')
        elseif sameFig ~= 'y'
            %             export_fig(plotData.saveFileName{stimNum},'-pdf','-q50')
            export_fig(plotData.saveFileName{stimNum},'-pdf','-painters')
        end
    end
    
    %     set(sph(:),'Nextplot','add')
end

%% Plot scatter plots
behaviorParamsScatter(plotData,groupedData)

%% Group pdfs
if saveQ == 'y'
    figurePath = fileparts(plotData.saveFileName{1});
    groupPdfs(figurePath)
end

end