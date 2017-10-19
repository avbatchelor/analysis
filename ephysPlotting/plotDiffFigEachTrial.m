function plotDiffFigEachTrial(prefixCode,expNum,flyNum,cellNum,cellExpNum)

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
[groupedDataFileName,flyDataFileName,exptDataFileName,idString] = getFileNames(exptInfo);
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
    numTrials = size(GroupData(n).voltage,1);
    
    %% Determine title
    try 
        odor = StimStruct(n).stimObj.odor;
    catch 
        odor = 'no odor';
    end

    if exptInfo.stimSetNum == 19
        titleText = {titleString;...
            [GroupData(n).description,', StimNum = ',num2str(n)];...
            ['probe on ',StimStruct(n).stimObj.probe,', volume = ',num2str(StimStruct(n).stimObj.maxVoltage),', odor = ',odor]};
    else
        titleText = {titleString;...
            [GroupData(n).description,', StimNum = ',num2str(n),', odor = ',odor]};
    end
    
    %% Plot stimulus
    [h, numSubPlot]=plotStimulus(exptInfo,GroupStim,GroupData,titleText,StimStruct,n,numTrials);
    
    %% Plot voltage
    for k = 1:numTrials
        h(3) = subplot(numSubPlot,1,numSubPlot-(numTrials-k));
        set(gca, 'ColorOrder', ColorSet(3*(k-1)+1:end,:),'NextPlot', 'replacechildren');
        %     plot(GroupData(n).sampTime,GroupData(n).voltage,'Color',gray)
        traceToPlot = k;
%         %%%%%% Filter 
%         cutoffFreq = 30;
%         rate = 2*(cutoffFreq/settings.sampRate.in);
%         [kb, ka] = butter(2,rate);
%         GroupData(n).voltage = filtfilt(kb, ka, GroupData(n).voltage')';
%         %%%%%%

        plot(GroupData(n).sampTime,GroupData(n).voltage(traceToPlot,:))
        hold on
        if size(GroupData(n).voltage,1)>1
            %         plot(GroupData(n).sampTime,mean(GroupData(n).voltage),'k')
        end
        hold on
        if k == round(numTrials/2)            
            ylabel('Voltage (mV)')
        end
        if k ~= numTrials
            noXAxisSettings
        else
            bottomAxisSettings
            xlabel('Time (s)')
        end
        trialNums = 1:size(GroupData(n).voltage,1);
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