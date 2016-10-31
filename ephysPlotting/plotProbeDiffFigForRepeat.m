function plotProbeDiffFigForRepeat(exptInfo)

close all

%% Plot settings
set(0,'DefaultAxesFontSize', 16)
set(0,'DefaultFigureColor','w')
set(0,'DefaultAxesBox','off')

gray = [192 192 192]./255;

ColorSet = distinguishable_colors(30,'w');
purple = [97 69 168]./255;


%% Load groupedData file
[~, path, ~, idString] = getDataFileName(exptInfo);
fileName = [path,'groupedData.mat'];
load(fileName);

saveFolderStem = char(regexp(path,'.*(?=cellNum)','match'));
saveFolder = [saveFolderStem,'Figures\','cellExpNum_',num2str(exptInfo.cellExpNum),'_figs\'];
if ~isdir(saveFolder)
    mkdir(saveFolder);
end

%% Load fly details
ephysSettings;
microCzarSettings;   % Loads settings
filename = [dataDirectory,exptInfo.prefixCode,'\expNum',num2str(exptInfo.expNum,'%03d'),...
    '\flyNum',num2str(exptInfo.flyNum,'%03d'),'\flyData'];
load(filename);

%% Load experiment details
settingsFileName = [path,idString,'exptData.mat'];
load(settingsFileName);

% Convert date into text
dateNumber = datenum(exptInfo.dNum,'yymmdd');
dateAsString = datestr(dateNumber,'mm-dd-yy');

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
    titleText = {[dateAsString,', ',exptInfo.prefixCode,', ','ExpNum ',num2str(exptInfo.expNum),', FlyNum ',num2str(exptInfo.flyNum),', CellNum ',num2str(exptInfo.cellNum),', CellExpNum ',num2str(exptInfo.cellExpNum)];...
        [GroupData(n).description,', StimNum = ',num2str(n)];...
        ['probe on ',StimStruct(n).stimObj.probe,', volume = ',num2str(StimStruct(n).stimObj.maxVoltage)]};    
    
    %% Plot stimulus
    % Determine if stimulus is piezo, speaker or neither
    if ~isfield(exptInfo,'stimType')
        exptInfo.stimType = 'n';
    end
    % Plot stimulus appropriately
    if strcmpi(exptInfo.stimType,'p')
        numStimPlots = 1;
        numSubPlot = numStimPlots+numRepeats;
        h(1) = subplot(numSubPlot,1,2);
        hold on
        plot(GroupStim(n).stimTime,GroupData(n).piezoCommand,'Color',gray)
        plot(GroupData(n).sampTime,GroupData(n).piezoSG,'Color',purple)
        if size(GroupData(n).piezoSG,1)>1
            plot(GroupData(n).sampTime,mean(GroupData(n).piezoSG),'k')
        end
        ylabel('Voltage (V)')
        set(gca,'Box','off','TickDir','out','XTickLabel','')
        %     ylim([-0.1 10.1])
        set(gca,'xtick',[])
        set(gca,'XColor','white')
        t = title(h(1),titleText);
        set(t,'Fontsize',20);
    elseif strcmpi(exptInfo.stimType,'s')
        numStimPlots = 1;
        numSubPlot = numStimPlots+numRepeats;
        h(1) = subplot(numSubPlot,1,1);
        if regexp(GroupData(n).description,'chirp')>=1
            plotChirp(StimStruct(n).stimObj)
        else
            plot(GroupData(n).sampTime,GroupData(n).speakerCommand,'Color',purple)
            ylabel('Voltage (V)')
        end
        hold on
        set(gca,'Box','off','TickDir','out','XTickLabel','')
        %     ylim([-1.1 1.1])
        set(gca,'xtick',[])
        set(gca,'XColor','white')
        t = title(h(1),titleText);
        set(t,'Fontsize',20);
    elseif strcmpi(exptInfo.stimType,'n')
        numStimPlots = 2;
        numSubPlot = numStimPlots+numRepeats;
        h(1) = subplot(numSubPlot,1,1);
        if regexp(GroupData(n).description,'chirp')>=1
            plotChirp(StimStruct(n).stimObj)
        else
            plot(GroupData(n).sampTime,GroupData(n).speakerCommand,'Color',purple)
            ylabel('Voltage (V)')
        end
        hold on
        set(gca,'Box','off','TickDir','out','XTickLabel','')
        %     ylim([-1.1 1.1])
        set(gca,'xtick',[])
        set(gca,'XColor','white')
        t = title(h(1),titleText);
        set(t,'Fontsize',20);
        
        h(2) = subplot(numSubPlot,1,2);
        hold on
        plot(GroupStim(n).stimTime,GroupData(n).piezoCommand,'Color',gray)
        plot(GroupData(n).sampTime,GroupData(n).piezoSG,'Color',purple)
        if size(GroupData(n).piezoSG,1)>1
            plot(GroupData(n).sampTime,mean(GroupData(n).piezoSG),'k')
        end
        ylabel('Voltage (V)')
        set(gca,'Box','off','TickDir','out','XTickLabel','')
        %     ylim([-0.1 10.1])
        set(gca,'xtick',[])
        set(gca,'XColor','white')
    end
    
    
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
        set(gca,'Box','off','TickDir','out','XTickLabel','')
        axis tight
        set(gca,'xtick',[])
        set(gca,'XColor','white')
        trialNums = 1:size(GroupData(n).voltage,1);
        legend(num2str(trialNums'))
    end
    
    
    %% Format figure
    linkaxes(h,'x')
    
    if n == 1
        spaceplots(fig,[0 0 0.025 0])
    else
        spaceplots
    end
    
    %% Format and save
    saveFileName{n} = [saveFolder,idString,'stimNum',num2str(n,'%03d'),'repeatSep.pdf'];
    mySave(saveFileName{n});
    close all
end

end