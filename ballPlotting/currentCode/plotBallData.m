function plotBallData(prefixCode,expNum,flyNum,flyExpNum,allTrials,sameFig)

%% Put exptInfo in a struct
exptInfo = exptInfoStruct(prefixCode,expNum,flyNum,flyExpNum);

%% Load plot data
% Get paths
[~, path, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
pPath = getProcessedDataFileName(exptInfo);

% Plot data
fileName = [pPath,fileNamePreamble,'plotData.mat'];
load(fileName);

%% Load analysis settings
analysisSettings; 

%% Create save folder
% fileStem = char(regexp(pPath,'.*(?=flyExpNum)','match'));
% saveFolder = [fileStem,'Figures\'];
% mkdir(saveFolder)

%% Figure prep
% Close figures
close all

% Set colors
gray = [192 192 192]./255;
colorSet = distinguishable_colors(plotData.numUniqueStim,'w');

% Subplot settings
numCols = 2;
numRows = 7;
spIndex = reshape(1:numCols*numRows, numCols, numRows).';

%% Create empty matrices
stimCount = 0;

%% Loop through to plot the correct number of figures

% Make subplots tight
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.1 0.1], [0.1 0.01]);

if strcmp(sameFig,'y')
    figureIdx = plotData.figureNums.allDiffFigs;
elseif strcmp(sameFig,'n')
    figureIdx = plotData.figureNums.allSameFig;
elseif strcmp(sameFig,'m')
    figureIdx = plotData.figureNums.figByType;
end

%% Plot for each stim Num
for stimNum = plotData.numUniqueStim
    
    stimCount = stimCount + 1;
    %% Set figure number appropriately
    figure(figureIdx(stimNum));
    
    %% Set colors correctly
    currColor = colorSet(stimNum,:);
    
    %% Plot stimulus
    % Subplot settings
    sph(1) = subplot (numRows, numCols, spIndex(1));
    
    % Plot
    mySimplePlot(plotData.stimTimeVector(stimNum,:),plotData.stimulus(stimNum,:))
    
    % Axis labels
    ylabel({'Stim';'(V)'})
    
    % Axis settings
    noXAxisSettings('w');
    
    
    %% Plot x speed vs. time
    % Subplot settings
    sph(2) = subplot(numRows, numCols, spIndex(2));
    hold on
    
    % Plot
    mySimplePlot(plotData.dsTime(stimNum,:),plotData.meanXVel(stimNum,:),'Color',currColor,'Linewidth',2)
    if strcmp(allTrials,'y')
        mySimplePlot(groupedData.dsTime{stimNum},sampleTrialsVel(stimIndSamp,:),'Color',currColor,'Linewidth',0.5)
    end
    %     mySimplePlot(groupedData.dsTime,meanXVel+stdXVel,'Color',colorSet(stimNum,:),'Linewidth',0.5)
    %     mySimplePlot(groupedData.dsTime,meanXVel-stdXVel,'Color',colorSet(stimNum,:),'Linewidth',0.5)
    
    % Axis labels
    ylabel({'Lateral Speed';'(mm/s)'})
    
    % Axis settings
    noXAxisSettings
    moveXAxis
    symAxisY
    shadestimArea(plotData)

    
    %% Plot y speed vs. time
    % Subplot settings
    sph(3) = subplot(numRows, numCols, spIndex(3));
    hold on
    
    % Plot
    mySimplePlot(plotData.dsTime(stimNum,:),plotData.meanYVel(stimNum,:),'Color',currColor,'Linewidth',2)
    if strcmp(allTrials,'y')
        mySimplePlot(groupedData.dsTime{stimNum},rotYVel(stimIndSamp,:),'Color',currColor,'Linewidth',0.5)
    end
    %     mySimplePlot(groupedData.dsTime,meanYVel+stdYVel,'Color',colorSet(stimNum,:),'Linewidth',0.5)
    %     mySimplePlot(groupedData.dsTime,meanYVel-stdYVel,'Color',colorSet(stimNum,:),'Linewidth',0.5)
    
    % Axis labels
    ylabel({'Forward Speed';'(mm/s)'})
    
    % Axis settings
    noXAxisSettings
    moveXAxis
    symAxisY
    shadestimArea(plotData)
    
    
    %% Plot x displacement vs. time
    % Subplot settings
    sph(4) = subplot(numRows, numCols, spIndex(4));
    hold on
    
    % Plot
    mySimplePlot(plotData.dsTime(stimNum,:),plotData.meanXDisp(stimNum,:),'Color',currColor,'Linewidth',2)
    if strcmp(allTrials,'y')
        mySimplePlot(groupedData.dsTime{stimNum},rotXDisp(stimIndSamp,:),'Color',currColor,'Linewidth',0.5)
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
    symAxisY
    shadestimArea(plotData)
    
    
    %% Plot y displacement vs. time plot
    % Subplot settings
    sph(5) = subplot (numRows, numCols, spIndex(5));
    hold on
    
    % Plot
    mySimplePlot(plotData.dsTime(stimNum,:),plotData.meanYDisp(stimNum,:),'Color',currColor,'Linewidth',2)
    if strcmp(allTrials,'y')
        mySimplePlot(groupedData.dsTime{stimNum},rotYDisp(stimIndSamp,:),'Color',currColor,'Linewidth',0.5)
    end
    %     mySimplePlot(groupedData.dsTime,meanYDisp+stdYDisp,'Color',colorSet(stimNum,:),'Linewidth',0.5)
    %     mySimplePlot(groupedData.dsTime,meanYDisp-stdYDisp,'Color',colorSet(stimNum,:),'Linewidth',0.5)
    
    % Axis labels
    ylabel({'Y Disp';'(mm)'})
    xlabel('Time (s)')
    
    % Axis settings
    bottomAxisSettings
    linkaxes(sph(1:5),'x')
    symAxisY
    shadestimArea(plotData)
    
    
    %% Plot forward speed histogram
    % Subplot settings
    sph(6) = subplot (numRows, numCols, spIndex(6));
    hold on
    
    % Plot
    histogramBins = bins;
    histogram(plotData.velForHistogram,histogramBins);
    
    % Axis labels
    xlabel('Forward speed (mm/s)')
    ylabel('Counts')
    
    % Axis settings
    xlim([-10 max(histogramBins)])
    bottomAxisSettings
    
    
    %% Plot avg. trial speed
    % Subplot settings
    sph(7) = subplot (numRows, numCols, spIndex(7));
    hold on
    
    % Plot all trials in gray 
        bh1 = bar(1:plotData.numTrials,plotData.trialSpeed,'EdgeColor',gray,'FaceColor',gray);
    
    % Get bar width 
    bw = get(bh1,'BarWidth');

    % If plotting all trial in same figure, plot fast trials in red 
    if strcmp(sameFig,'y')
        % Plot fast trials in red 
        bar(plotData.fastTrials,plotData.trialSpeed(plotData.fastTrials),'EdgeColor','red','FaceColor','red','BarWidth',bw);
    else 
        stimFastTrials = plotData.trialsSelectedByStimAndSpeed{stimNum};
        bar(stimFastTrials,plotData.trialSpeed(stimFastTrials),'EdgeColor',currColor,'FaceColor',currColor,'BarWidth',bw);
    end
    
    % Plot baseline
    line([0,plotData.numTrials],[speedThreshold,speedThreshold],'Color','k')
    
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
    
    
    %% Plot trial line
    % Subplot settings
    sph(8) = subplot(numRows, numCols, spIndex(8:10));
    hold on
    
    % Plot
    plot(plot.xDispLinePlot{stimNum},plotData.yDispLinePlot{stimNum})
    line([rotXDisp(:,pipStartInd),rotXDisp(:,indBefore)]',[rotYDisp(:,pipStartInd),rotYDisp(:,indBefore)]','Color','k');
    line([rotXDisp(:,pipStartInd),rotXDisp(:,indAfter)]',[rotYDisp(:,pipStartInd),rotYDisp(:,indAfter)]','Color',currColor);
    
    % Axis labels
    ylabel('Y displacement (mm)')
    
    % Axis settings
    axis square
    xlim([-3 3])
    
    
    %% Plot mean X vs mean Y displacement
    % Subplot settings
    sph(9) = subplot (numRows, numCols, spIndex(11:14));
    hold on
    
    % Plot
    plot(meanXDisp,meanYDisp,'Color',currColor,'Linewidth',2)
    if strcmp(allTrials,'y')
        plot(rotXDisp(stimIndSamp,:)',rotYDisp(stimIndSamp,:)','Color',currColor,'Linewidth',0.5)
    end
    %     plot(meanXDisp+stdXDisp,meanYDisp,'Color',colorSet(stimNum,:),'Linewidth',0.5)
    %     plot(meanXDisp-stdXDisp,meanYDisp,'Color',colorSet(stimNum,:),'Linewidth',0.5)
    
    % Axis labels
    xlabel('X displacement (mm)')
    ylabel('Y displacement (mm)')
    
    % Axis settings
    xlim([-3 3])
    
    
    %% Plot angle histogram
    beforeDisp = [rotXDisp(:,indBefore),rotYDisp(:,indBefore)];
    afterDisp = [rotXDisp(:,indAfter),rotYDisp(:,indAfter)];
    plotAngleHist(beforeDisp,afterDisp,currColor,numUniqueStim,stimCount);
    
    
    %% Clear data
    clear rotVel rotDisp
    
end

%% Add legend and title
% Legend
legend(sph(9),legendText,'Location','best')
legend('boxoff')

% Title
suptitle(sumTitle)

%% Save figures and group pdfs
% Save figures
saveFileName = [saveFolder,'flyExpNum',num2str(exptInfo.flyExpNum,'%03d'),'_stim',num2str(stimNum-1,'%03d'),'_to_',num2str(stimNum,'%03d'),'.pdf'];
mySave(saveFileName,[5 5]);

% Group pdfs
groupPdfs(saveFolder)




end