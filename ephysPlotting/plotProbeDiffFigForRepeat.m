function plotProbeDiffFigForRepeat(prefixCode,expNum,flyNum,cellNum,cellExpNum)

close all

%% For tight subplots
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.05], [0.1 0.15], [0.1 0.01]);

%% generate exptInfo
exptInfo = makeExptInfoStruct(prefixCode,expNum,flyNum,cellNum,cellExpNum);

%% Plot settings
setPlotDefaults;

%% Set colors
gray = [192 192 192]./255;
ColorSet = distinguishable_colors(30,'w');
purple = [97 69 168]./255;

%% Load settings and data
[groupedDataFileName,flyDataFileName,exptDataFileName] = getFileNames(exptInfo);
load(groupedDataFileName);
load(flyDataFileName);
load(exptDataFileName);
ephysSettings;

%% Get SaveFolderName
saveFolder = getSaveFolderName(exptInfo);

%% Get title string
titleString = getTitleString(exptInfo);

%% Plot
numStim = length(GroupData);

for n = 1:numStim
    if isempty(GroupData(n).sampTime)
        continue
    end
    
    %% Create figure 
    fig = figure(n);
    setCurrentFigurePosition(2)
    colormap(ColorSet);
    
    %% Calculate number of repeats 
    numRepeats = ceil(size(GroupData(1).voltage,1)/3);
    
    %% Determine title 
    titleText = {titleString;...
        [GroupData(n).description,', StimNum = ',num2str(n)];...
        ['probe on ',StimStruct(n).stimObj.probe,', volume = ',num2str(StimStruct(n).stimObj.maxVoltage)]};    
    
    %% Plot stimulus
    plotStimulus(exptInfo,GroupStim,GroupData,titleText,StimStruct,n,numRepeats)

    %% Plot voltage
    for k = 1:numRepeats
        h(3) = subplot(numSubPlot,1,numStimPlots+k);
        set(gca, 'ColorOrder', ColorSet(3*(k-1)+1:end,:),'NextPlot', 'replacechildren');
        %     plot(GroupData(n).sampTime,GroupData(n).voltage,'Color',gray)
        traceToPlot = (3*(k-1))+(1:3);
        numTrials = size(GroupData(n).voltage,1);
        if max(traceToPlot)>numTrials
            if traceToPlot(1)<=numTrials
                plot(GroupData(n).sampTime,GroupData(n).voltage(traceToPlot(1):end,:))
            end
        else
            plot(GroupData(n).sampTime,GroupData(n).voltage(traceToPlot,:))
        end
        hold on
        if size(GroupData(n).voltage,1)>1
            %         plot(GroupData(n).sampTime,mean(GroupData(n).voltage),'k')
        end
        hold on
        ylabel('Voltage (mV)')
        bottomAxisSettings
        trialNums = 1:size(GroupData(n).voltage,1);
        legend(num2str(trialNums'))
    end
    
    
    %% Format figure
    linkaxes(h,'x')
    
%     if n == 1
%         spaceplots(fig,[0 0 0.025 0])
%     else
%         spaceplots
%     end
    
    %% Format and save
    saveFileName{n} = [saveFolder,idString,'stimNum',num2str(n,'%03d'),'repeatSep.pdf'];
    mySave(saveFileName{n});
    close all
end

end