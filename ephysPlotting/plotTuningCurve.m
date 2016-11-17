function plotTuningCurve(prefixCode,expNum,flyNum,cellNum,cellExpNum)


close all

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

%% Determine title
titleString = getTitleString(exptInfo);
titleText = {titleString;...
    ['probe position: ',StimStruct(1).stimObj.probe,', volume = ',num2str(StimStruct(1).stimObj.maxVoltage)];['Pure tone tuning curve']};

%% Integrate voltage for idfferent stim
numStim = length(GroupData);
count = 1;
for n = 1:numStim
    if isfield(StimStruct(n).stimObj,'class') 
        if strcmp(StimStruct(n).stimObj.class,'SineWave') 
            include = 1;
        end
    elseif regexp(StimStruct(n).stimObj.description,'tone')
        include = 1;
    else 
        include = 0;
    end
    if include == 1
        freq(count) = StimStruct(n).stimObj.carrierFreqHz;
        meanVoltage = mean(GroupData(n).voltage);
        meanVoltage = meanVoltage-mean(meanVoltage(5000:10000));
        stimStartInd = StimStruct(n).stimObj.startPadDur*settings.sampRate.in;
        stimEndInd = stimStartInd + StimStruct(n).stimObj.stimDur*settings.sampRate.in;
        intVoltage(count) = sum(meanVoltage(stimStartInd:stimEndInd));
        count = count+1;
    end
end

normVoltage = intVoltage./max(intVoltage);

%% Create figure
fig = figure(1);
setCurrentFigurePosition(2)
colormap(ColorSet);


%% PLOT
plot(freq,normVoltage,'Color',gray,'LineWidth',3)
hold on
plot(freq,normVoltage,'r.','MarkerSize',20)
bottomAxisSettings
title(titleText)
line([0,max(freq)],[0,0],'Color','k')
xlabel('Frequency (Hz)')
ylabel('Normalised response during stimulus')

%% Format figure
spaceplots(fig,[0 0 0.025 0])

%% Format and save
[~, ~, ~, idString] = getDataFileName(exptInfo);
saveFileName{n} = [saveFolder,idString,'tuningCurve.pdf'];
mySave(saveFileName{n});
close all
end



