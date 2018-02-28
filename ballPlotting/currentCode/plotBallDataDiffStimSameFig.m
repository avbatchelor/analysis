function plotBallDataDiffStimSameFig(prefixCode,expNum,flyNum,flyExpNum,allTrials,sameFig)


%% Put exptInfo in a struct
exptInfo = exptInfoStruct(prefixCode,expNum,flyNum,flyExpNum);

%% Load plot data
% Get paths
[~, path, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
pPath = getProcessedDataFileName(exptInfo);

% Plot data
fileName = [pPath,fileNamePreamble,'plotData.mat'];
load(fileName);

%% Unpack plot data
v2struct(plotData);

% % Expt data
% fileName = [path,fileNamePreamble,'exptData.mat'];
% load(fileName);
%
% % First trial
% firstTrialFileName = [path,fileNamePreamble,'trial',num2str(1,'%03d'),'.mat'];
% load(firstTrialFileName);
%
% % Fly data
% flyDataPath = char(regexp(path,'.*(?=flyExpNum)','match'));
% flyDataPreamble = char(regexp(fileNamePreamble,'.*(?=flyExpNum)','match'));
% flyDataFileName = [flyDataPath,flyDataPreamble,'flyData'];
% load(flyDataFileName);

%% Create save folder
% fileStem = char(regexp(pPath,'.*(?=flyExpNum)','match'));
% saveFolder = [fileStem,'Figures\'];
% mkdir(saveFolder)

%% Figure prep
% Close figures
close all

% Set colors
gray = [192 192 192]./255;

% Subplot settings
numCols = 2;
numRows = 7;
spIndex = reshape(1:numCols*numRows, numCols, numRows).';

%% Calculate number of stimuli
% Number of unique stimuli - same stimulus at different location considered
% unique stimulus
uniqueStim = unique(groupedData.stimNum);
numUniqueStim = length(uniqueStim);

% Stimuli are considered the same 'type' if the sound played by the
% speaker is identical
stimType = sameStim(StimStruct);
uniqueStimTypes = unique(stimType);

% If you want to plot all stimuli on the same figure set the
% uniqueStimTypes to 1
if strcmp(sameFig,'y')
    uniqueStimTypes = 1;
    stimTypeInd = uniqueStim;
end

%% Data for title
sumTitle = {[dateAsString,', ',exptInfo.prefixCode,', ExpNum ',num2str(exptInfo.expNum),', FlyNum ',num2str(exptInfo.flyNum),...
    ', FlyExpNum ',num2str(exptInfo.flyExpNum)];['Aim: ',char(FlyData.aim),', Description: ',StimStruct(stimTypeInd(1)).stimObj.description];...
    ['X Saturation Count = ',num2str(sum(groupedData.xSaturationWarning)),'Y Saturation Count = ',num2str(sum(groupedData.ySaturationWarning))]};

%% Create empty matrices
legendText = cell(uniqueStim,1);
stimCount = 0;

%% Loop through to plot the correct number of figures

% Make subplots tight
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.01 0.01], [0.1 0.01]);

if strcmp(sameFig,'y')
    figureIdx = figureNums.allDiffFigs;
elseif strcmp(sameFig,'n')
    figureIdx = figureNums.allSameFig;
elseif strcmp(sameFig,'m')
    figureIdx = figureNums.figByType;
end

%% Plot for each stim Num
for stimNum = numUniqueStim
    
    stimCount = stimCount + 1;
    %% Set figure number appropriately
    figure(figureIdx(stimNum));
    
    %% Set colors correctly
    if strcmp(sameFig,'n')
        colorSet = distinguishable_colors(length(stimTypeInd),'w');
        colorSet = circshift(colorSet,1,1);
        currColor = colorSet(stimCount,:);
    else
        colorSet = distinguishable_colors(length(uniqueStim),'w');
        currColor = colorSet(stimNum,:);
    end
    
    %% Plot stimulus
    % Subplot settings
    sph(1) = subplot (numRows, numCols, spIndex(1));
    
    % Plot
    mySimplePlot(stimTimeVector(stimNum,:),stimulus(stimNum,:))
    
    % Axis labels
    ylabel({'Stim';'(V)'})
    
    % Axis settings
    noXAxisSettings;
    
    
    %% Plot x speed vs. time
    % Subplot settings
    sph(2) = subplot(numRows, numCols, spIndex(2));
    hold on
    
    % Plot
    mySimplePlot(dsTime(stimNum,:),meanXVel(i,:),'Color',currColor,'Linewidth',2)
    if strcmp(allTrials,'y')
        mySimplePlot(groupedData.dsTime{stimNum},sampleTrialsVel(stimIndSamp,:),'Color',currColor,'Linewidth',0.5)
    end
    %     mySimplePlot(groupedData.dsTime,meanXVel+stdXVel,'Color',colorSet(stimNum,:),'Linewidth',0.5)
    %     mySimplePlot(groupedData.dsTime,meanXVel-stdXVel,'Color',colorSet(stimNum,:),'Linewidth',0.5)
    
    % Axis labels
    ylabel({'Lateral Speed';'(mm/s)'})
    
    % Axis settings
    noXAxisSettings
    moveXAxis(groupedData,stimNum)
    shadestimArea(groupedData,stimNum)
    symAxisY
    
    
    %% Plot y speed vs. time
    % Subplot settings
    sph(3) = subplot(numRows, numCols, spIndex(3));
    hold on
    
    % Plot
    mySimplePlot(groupedData.dsTime{stimNum},meanYVel,'Color',currColor,'Linewidth',2)
    if strcmp(allTrials,'y')
        mySimplePlot(groupedData.dsTime{stimNum},rotYVel(stimIndSamp,:),'Color',currColor,'Linewidth',0.5)
    end
    %     mySimplePlot(groupedData.dsTime,meanYVel+stdYVel,'Color',colorSet(stimNum,:),'Linewidth',0.5)
    %     mySimplePlot(groupedData.dsTime,meanYVel-stdYVel,'Color',colorSet(stimNum,:),'Linewidth',0.5)
    
    % Axis labels
    ylabel({'Forward Speed';'(mm/s)'})
    
    % Axis settings
    noXAxisSettings;
    shadestimArea(groupedData,stimNum)
    moveXAxis(groupedData,stimNum)
    symAxisY
    
    
    %% Plot x displacement vs. time
    % Subplot settings
    sph(4) = subplot(numRows, numCols, spIndex(4));
    hold on
    
    % Plot
    mySimplePlot(groupedData.dsTime{stimNum},meanXDisp,'Color',currColor,'Linewidth',2)
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
    shadestimArea(groupedData,stimNum)
    moveXAxis(groupedData,stimNum)
    symAxisY
    
    
    %% Plot y displacement vs. time plot
    % Subplot settings
    sph(5) = subplot (numRows, numCols, spIndex(5));
    hold on
    
    % Plot
    mySimplePlot(groupedData.dsTime{stimNum},meanYDisp,'Color',currColor,'Linewidth',2)
    if strcmp(allTrials,'y')
        mySimplePlot(groupedData.dsTime{stimNum},rotYDisp(stimIndSamp,:),'Color',currColor,'Linewidth',0.5)
    end
    %     mySimplePlot(groupedData.dsTime,meanYDisp+stdYDisp,'Color',colorSet(stimNum,:),'Linewidth',0.5)
    %     mySimplePlot(groupedData.dsTime,meanYDisp-stdYDisp,'Color',colorSet(stimNum,:),'Linewidth',0.5)
    line([groupedData.dsTime{stimNum}(1),groupedData.dsTime{stimNum}(end)],[0,0],'Color','k')
    
    % Axis labels
    ylabel({'Y Disp';'(mm)'})
    xlabel('Time (s)')
    
    % Axis settings
    bottomAxisSettings
    shadestimArea(groupedData,stimNum)
    linkaxes(sph(1:5),'x')
    symAxisY
    
    
    %% Plot forward speed histogram
    % Subplot settings
    sph(6) = subplot (numRows, numCols, spIndex(6));
    hold on
    
    % Plot
    histogramBins = unique(rotYVel(:));
    histogram(rotYVel(:),histogramBins);
    
    % Axis labels
    xlabel('Forward speed (mm/s)')
    ylabel('Counts')
    
    % Axis settings
    xlim([min(histogramBins) max(histogramBins)])
    bottomAxisSettings
    
    
    %% Plot avg. trial speed
    % Subplot settings
    sph(7) = subplot (numRows, numCols, spIndex(7));
    hold on
    
    % Plot all trials in gray
    if stimCount == 1
        bh1 = bar(trialNums,groupedData.trialSpeed,'EdgeColor',gray,'FaceColor',gray);
    end
    % Plot baseline
    line([0,trialNums(end)],[10,10],'Color','k')
    bw = get(bh1,'BarWidth');
    bar(stimNumInd,groupedData.trialSpeed(stimNumInd),'EdgeColor',currColor,'FaceColor',currColor,'BarWidth',bw/min(diff(sort(stimSelect))));
    %     notIncInd = trialNums(~groupedData.trialsToInclude);
    %     bar(notIncInd,groupedData.trialSpeed(~groupedData.trialsToInclude),'FaceColor','b')
    plot(stimSelect,max(groupedData.trialSpeed)+1,'*','Color',currColor)
    
    % Axis labels
    ylabel({'Trial avg speed';'(mm/s)'})
    xlabel('Trial number')
    
    % Axis settings
    bottomAxisSettings
    
    % Title
    if mod(stimNum,2)
        t1s = ['Successful left trials = ',num2str(length(stimNumInd)),'/',num2str(length(stimSelect))];
    else
        t2s = ['Successful right trials = ',num2str(length(stimNumInd)),'/',num2str(length(stimSelect))];
        title([t1s,'   ',t2s])
    end
    
    
    %% Plot trial line
    % Subplot settings
    sph(8) = subplot(numRows, numCols, spIndex(8:10));
    hold on
    
    % Plot
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