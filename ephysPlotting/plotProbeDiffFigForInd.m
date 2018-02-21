function plotProbeDiffFigForInd(prefixCode,expNum,flyNum,cellNum,cellExpNum)

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
[~,flyDataFileName,exptDataFileName,idString] = getFileNames(exptInfo);
groupedDataFileName = 'D:\DataD\ephysData\vPN1\expNum002\flyNum002\cellNum001\cellExpNum005\groupedData';
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
    numRepeats = ceil(size(GroupData(1).voltage,1)/1);
    
    %% Determine title
    if exptInfo.stimSetNum == 19
        titleText = {titleString;...
            [GroupData(n).description,', StimNum = ',num2str(n)];...
            ['probe on ',StimStruct(n).stimObj.probe,', volume = ',num2str(StimStruct(n).stimObj.maxVoltage)]};
    else
        titleText = {titleString;...
            [GroupData(n).description,', StimNum = ',num2str(n)]};
    end
    
    %% Plot stimulus
    subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.05], [0.1 0.15], [0.1 0.01]);
    
    purple = [97 69 168]./255;
    gray = [192 192 192]./255;
    
    numStimPlots = 1;
    numSubPlot = 7;
    h(1) = subplot(7,1,1);
    plot(StimStruct(n).stimObj.timeVec,StimStruct(n).stimObj.stimulus.*1000,'Color',purple)
    ylabel('Arbitrary units')
    hold on
    noXAxisSettings
%     t = title(h(1),titleText);
%     set(t,'Fontsize',20);
    
    numTrials = size(GroupData(n).voltage,1);
    %% Plot voltage
    for k = 1:numTrials
        try
            h(k) = subplot(numSubPlot,1,k+1);
        catch
        end
        set(gca, 'ColorOrder', ColorSet(k,:),'NextPlot', 'replacechildren');
        %     plot(GroupData(n).sampTime,GroupData(n).voltage,'Color',gray)
        traceToPlot = k;
        
%         %%%%%% Filter 
%         cutoffFreq = 30;
%         rate = 2*(cutoffFreq/settings.sampRate.in);
%         [kb, ka] = butter(2,rate);
%         GroupData(n).voltage = filtfilt(kb, ka, GroupData(n).voltage')';
%         %%%%%%
        try
            plot(GroupData(n).sampTime,GroupData(n).voltage(traceToPlot,:))
        catch 
        end
        hold on
        if size(GroupData(n).voltage,1)>1
            %         plot(GroupData(n).sampTime,mean(GroupData(n).voltage),'k')
        end
        hold on
        if k == 3
            ylabel('Voltage (mV)')
        end
        if k ~= 6 
            noXAxisSettings
        else
            bottomAxisSettings
            xlabel('Time (s)')
        end
        
        trialNums = 1:size(GroupData(n).voltage,1);
%         legend(num2str(trialNums'))
    end
    
    
    %% Format figure
    linkaxes(h,'x')
    
    %     if n == 1
    %         spaceplots(fig,[0 0 0.025 0])
    %     else
    %         spaceplots
    %     end
    
    %% Format and save
    saveFileName{n} = [saveFolder,idString,'stimNum',num2str(n,'%03d'),'repeatInd.pdf'];
    mySave(saveFileName{n});
    close all
end

end