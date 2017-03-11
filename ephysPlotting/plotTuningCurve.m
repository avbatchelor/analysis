function plotTuningCurve(prefixCode,expNum,flyNum,cellNum,cellExpNum)


close all

%% For tight subplots
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.05], [0.1 0.1], [0.1 0.01]);

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
try
titleText = {titleString;...
    ['probe position: ',StimStruct(1).stimObj.probe,', volume = ',num2str(StimStruct(1).stimObj.maxVoltage)];['Pure tone tuning curve']};
catch err
    if (strcmp(err.identifier,'MATLAB:nonStrucReference'))
        disp('Incomplete cell experiment')
    else 
        disp('Unknown error') 
    end
    return 
end

%% Integrate voltage for idfferent stim
numStim = length(GroupData);
count = 1;
for n = 1:numStim
    if isfield(StimStruct(n).stimObj,'class') 
        if strcmp(StimStruct(n).stimObj.class,'SineWave') 
            include = 1;
        else 
            include = 0;
        end
    elseif regexp(StimStruct(n).stimObj.description,'tone')
        include = 1;
    else 
        include = 0;
    end
    if include == 1
        freq(count) = StimStruct(n).stimObj.carrierFreqHz;
        vol(count) = StimStruct(n).stimObj.maxVoltage;
        meanVoltage = mean(GroupData(n).voltage,1);
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
hold on 


%% PLOT
xLimit = 400;
uniqueVols = unique(vol);
for i = 1:length(uniqueVols)
    volTrials = find(vol == uniqueVols(i));
    plot(freq(volTrials),normVoltage(volTrials),'Color',ColorSet(i,:),'LineWidth',3)
    hold on 
    legendText{i} = ['vol = ',num2str(uniqueVols(i))];
end
plot(freq,normVoltage,'.','Color',ColorSet(i+1,:),'MarkerSize',20)
bottomAxisSettings
title(titleText)
line([0,xLimit],[0,0],'Color','k')
xlabel('Frequency (Hz)')
ylabel('Normalised response during stimulus')
ylim([-1.1 1.1])
xlim([0 xLimit])
legend(legendText)
legend BoxOff

% %% Format figure
% spaceplots(fig,[0 0 0.025 0])

%% Format and save
[~, ~, ~, idString] = getDataFileName(exptInfo);
saveFileName{n} = [saveFolder,idString,'tuningCurve.pdf'];
mySave(saveFileName{n});
close all
end



