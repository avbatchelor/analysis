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

%% Convert date into text
dateNumber = datenum(exptInfo.dNum,'yymmdd');
dateAsString = datestr(dateNumber,'mm-dd-yy');

%% Determine title
titleText = {[dateAsString,', ',exptInfo.prefixCode,', ','ExpNum ',num2str(exptInfo.expNum),', FlyNum ',num2str(exptInfo.flyNum),', CellNum ',num2str(exptInfo.cellNum),', CellExpNum ',num2str(exptInfo.cellExpNum)];...
    ['probe position: ',StimStruct(1).stimObj.probe,', volume = ',num2str(StimStruct(1).stimObj.maxVoltage)];['Pure tone tuning curve']};

%% Integrate voltage for idfferent stim
numStim = length(GroupData);
for n = 1:numStim
    freq(n) = StimStruct(n).stimObj.carrierFreqHz;
    meanVoltage = mean(GroupData(n).voltage);
    meanVoltage = meanVoltage-mean(meanVoltage(5000:10000));
    stimStartInd = StimStruct(n).stimObj.startPadDur*settings.sampRate.in;
    stimEndInd = stimStartInd + StimStruct(n).stimObj.stimDur*settings.sampRate.in;
    intVoltage(n) = sum(meanVoltage(stimStartInd:stimEndInd));
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



