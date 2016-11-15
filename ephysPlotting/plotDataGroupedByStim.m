function plotDataGroupedByStim(exptInfo)

close all

%% Plot settings
setPlotDefaults;

%% Set colors
gray = [192 192 192]./255;
ColorSet = distinguishable_colors(30,'w');

%% Get save folder name
saveFolder = getSaveFolderName(exptInfo);

%% Load settings and data
[groupedDataFileName,flyDataFileName,exptDataFileName,idString] = getFileNames(exptInfo);
load(groupedDataFileName);
load(flyDataFileName);
load(exptDataFileName);
ephysSettings;

%% Get title string
titleString = getTitleString(exptInfo);

%% Plot
numStim = length(GroupData);

for n = 1:numStim
    if isempty(GroupData(n).sampTime)
        continue
    end
    fig = figure(n);
    setCurrentFigurePosition(2)
    colormap(ColorSet);
    
    if ~isfield(exptInfo,'stimType')
        exptInfo.stimType = 'n';
    end
    
    titleText = {titleString;...
        [GroupData(n).description,', StimNum = ',num2str(n)];...
        ['probe position = ',StimStruct(n).stimObj.probe,', volume = ',num2str(StimStruct(n).stimObj.maxVoltage)]};    
    
    numExtraPlots = 2;
    [h, numSubPlot] = plotStimulus(exptInfo,GroupStim,GroupData,titleText,StimStruct,n,numExtraPlots);
    
    h(3) = subplot(numSubPlot,1,numSubPlot-1);
    set(gca, 'ColorOrder', ColorSet,'NextPlot', 'replacechildren');
    %     plot(GroupData(n).sampTime,GroupData(n).voltage,'Color',gray)
    plotBaseline(GroupData(n).sampTime,GroupData(n).voltage)
    plot(GroupData(n).sampTime,GroupData(n).voltage)
    hold on
    if size(GroupData(n).voltage,1)>1
        %         plot(GroupData(n).sampTime,mean(GroupData(n).voltage),'k')
    end
    hold on
    ylabel('Voltage (mV)')
    noXAxisSettings
    trialNums = 1:size(GroupData(n).voltage,1);
    legend(num2str(trialNums'))
    
    h(4) = subplot(numSubPlot,1,numSubPlot);
    plot(GroupData(n).sampTime,GroupData(n).current,'Color',gray)
    hold on
    if size(GroupData(n).current,1)>1
        plot(GroupData(n).sampTime,mean(GroupData(n).current),'k')
    end
    hold on
    xlabel('Time (s)')
    ylabel('Current (pA)')
    bottomAxisSettings
    
    linkaxes(h,'x')
    
    if n == 1
        spaceplots(fig,[0 0 0.025 0])
    else
        spaceplots
    end
    
    %% Format and save
    saveFileName{n} = [saveFolder,idString,'stimNum',num2str(n,'%03d'),'.pdf'];
    mySave(saveFileName{n});
    close all
end

%groupPdfs(saveFolder);

end

function plotBaseline(time,data)
baseLevel = mean(mean(data(:,1:10000)));
hold on
line([time(1),time(end)],[baseLevel,baseLevel],'Color','k','Linewidth',0.5)
end