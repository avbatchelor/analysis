function plotZeroCurrentTrial(exptInfo)

close all

%% Plot settings
setPlotDefaults;

%% Set Colors 
gray = [192 192 192]./255;
ColorSet = distinguishable_colors(5,'w');

%% Load zero current file
[~, path, ~, idString] = getDataFileName(exptInfo);
preExptTrialsPath = [path,'\preExptTrials\'];
if ~isdir(preExptTrialsPath)
    return
end
cd(preExptTrialsPath);
zeroCFile = dir('*zeroCurrentTrial*.mat');
zeroCFileName = [preExptTrialsPath,zeroCFile(1).name];
if exist(zeroCFileName,'file') ~= 2
    return
end
load(zeroCFileName);

%% Generate saveFolder name
saveFolderStem = char(regexp(path,'.*(?=cellNum)','match'));
saveFolder = [saveFolderStem,'Figures\'];
if ~isdir(saveFolder)
    mkdir(saveFolder);
end

%% Load fly details
ephysSettings;
filename = [dataDirectory,exptInfo.prefixCode,'\expNum',num2str(exptInfo.expNum,'%03d'),...
    '\flyNum',num2str(exptInfo.flyNum,'%03d'),'\flyData'];
load(filename);

%% Load experiment details
settingsFileName = [path,idString,'exptData.mat'];
load(settingsFileName);

%% Convert date into text
dateNumber = datenum(exptInfo.dNum,'yymmdd');
dateAsString = datestr(dateNumber,'mm-dd-yy');

%% Plot
sampTime = (1:length(data.voltage))./settings.sampRate.in;

figure(1);
setCurrentFigurePosition(2)
colormap(ColorSet);

h(1) = subplot(2,1,1);
plot(sampTime,data.voltage)
noXAxisSettings
ylabel('Voltage (mV)')
t = title(h(1),{[dateAsString,', ',exptInfo.prefixCode,', ','ExpNum ',num2str(exptInfo.expNum),', FlyNum ',num2str(exptInfo.flyNum),', CellNum ',num2str(exptInfo.cellNum),', CellExpNum ',num2str(exptInfo.cellExpNum)];['Zero Current Trial']});
set(t,'Fontsize',20);

h(2) = subplot(2,1,2);
plot(sampTime,data.current,'Color',gray)
xlabel('Time (s)')
ylabel('Current (pA)')
bottomAxisSettings

linkaxes(h,'x')
spaceplots


%% Format and save
saveFileName = [saveFolder,idString,'stimNum',num2str(0,'%03d'),'_zero_current_trial.pdf'];
mySave(saveFileName);
close all


end