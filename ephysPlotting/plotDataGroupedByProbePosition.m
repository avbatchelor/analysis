function plotDataGroupedByProbePosition(prefixCode,expNum,flyNum,cellNum,cellExpNum)

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

%% Load settings and data
[groupedDataFileName,flyDataFileName,exptDataFileName,idString] = getFileNames(exptInfo);
load(groupedDataFileName);
load(flyDataFileName);
load(exptDataFileName);
ephysSettings;

%% Get SaveFolderName
saveFolder = getSaveFolderName(exptInfo);


%% Get title
n = 1; 
titleString = getTitleString(exptInfo);
titleText = {titleString;...
    [GroupData(n).description,', StimNum = ',num2str(n),', volume = ',num2str(StimStruct(n).stimObj.maxVoltage)]};


%% Plot

fig = figure(n);
setCurrentFigurePosition(2)
colormap(ColorSet);

h(1) = subplot(3,1,1);
plot(GroupStim(n).stimTime,GroupStim(n).stimulus,'k')
hold on
ylabel('Voltage (V)')
maxStim = max(GroupStim(n).stimulus);
ylim([-maxStim-0.1 maxStim+.1])
noXAxisSettings
t = title(h(1),titleText);
set(t,'Fontsize',20);


h(3) = subplot(3,1,2);
legendText = cell(size(GroupData,2),1);
for m = 1:size(GroupData,2)
%     plot(GroupData(m).sampTime,mean(GroupData(m).voltage),'Color',ColorSet(m,:))
    meanVoltage = mean(GroupData(m).voltage,1);
    voltageData = meanVoltage-mean(meanVoltage(5000:10000));
    plot(GroupData(m).sampTime,voltageData,'Color',ColorSet(m,:))
    hold on
    if exptInfo.stimSetNum == 19
        legendText(m,1) = {['probe on ',StimStruct(m).stimObj.probe,', volume = ',num2str(StimStruct(m).stimObj.maxVoltage)]};
    elseif exptInfo.stimSetNum == 29 
        legendText(m,1) = {[GroupData(m).odor]};
    elseif exptInfo.stimSetNum == 22 
        legendText(m,1) = {num2str(m)};
    end
end

ylabel('Voltage (mV)')
lh = legend(legendText);
legend('Location','SouthEast')
bottomAxisSettings

plotZeroLine(GroupData(m).sampTime)



linkaxes(h,'x')
%xlim([2.5 4])

% if n == 1
%     spaceplots(fig,[0 0 0.025 0])
% else
%     spaceplots
% end

%% Format and save
saveFileName{n} = [saveFolder,idString,'probeExpt_meanSubtracted.pdf'];
mySave(saveFileName{n});
close all

end

function plotZeroLine(time)
hold on
line([time(1),time(end)],[0,0],'Color','k','Linewidth',0.5)
end