function plotDataGroupedByProbePosition(prefixCode,expNum,flyNum,cellNum,cellExpNum)

close all

%% generate exptInfo
exptInfo = makeExptInfoStruct(prefixCode,expNum,flyNum,cellNum,cellExpNum);

%% Plot settings
setPlotDefaults;

%% Set colors
gray = [192 192 192]./255;
ColorSet = distinguishable_colors(30,'w');

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

%% Get title
titleText = {[dateAsString,', ',exptInfo.prefixCode,', ','ExpNum ',num2str(exptInfo.expNum),', FlyNum ',num2str(exptInfo.flyNum),', CellNum ',num2str(exptInfo.cellNum),', CellExpNum ',num2str(exptInfo.cellExpNum)];...
    [GroupData(n).description,', StimNum = ',num2str(n),', volume = ',num2str(StimStruct(n).stimObj.maxVoltage)]};


%% Plot
n = 1; 
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
legendText = cell(6,1);
for m = 1:size(GroupData,2)
%     plot(GroupData(m).sampTime,mean(GroupData(m).voltage),'Color',ColorSet(m,:))
    plot(GroupData(m).sampTime,mean(GroupData(m).voltage)-mean(GroupData(m).voltage(5000:10000)),'Color',ColorSet(m,:))
    hold on
    legendText(m,1) = {['probe on ',StimStruct(m).stimObj.probe,', volume = ',num2str(StimStruct(m).stimObj.maxVoltage)]};
end

ylabel('Voltage (mV)')
noXAxisSettings
lh = legend(legendText);
legend('Location','SouthEast')
%legend boxoff;

h(2) = subplot(3,1,3);
plot(GroupData(n).sampTime,GroupData(n).current,'Color',gray)
hold on
plot(GroupData(n).sampTime,mean(GroupData(n).current),'k')
hold on
xlabel('Time (s)')
ylabel('Current (pA)')
bottomAxisSettings

linkaxes(h,'x')
%xlim([2.5 4])

if n == 1
    spaceplots(fig,[0 0 0.025 0])
else
    spaceplots
end

%% Format and save
saveFileName{n} = [saveFolder,idString,'probeExpt_meanSubtracted.pdf'];
mySave(saveFileName{n});
close all


end