function temp_plotDataGroupedByProbePosition(prefixCode,expNum,flyNum,cellNum,cellExpNum)

close all

%% Plot settings
set(0,'DefaultAxesFontSize', 16)
set(0,'DefaultFigureColor','w')
set(0,'DefaultAxesBox','off')

gray = [192 192 192]./255;

ColorSet = distinguishable_colors(6,'w');

%% Load groupedData file
exptInfo.prefixCode     = prefixCode;
exptInfo.expNum         = expNum;
exptInfo.flyNum         = flyNum;
exptInfo.cellNum        = cellNum;
exptInfo.cellExpNum     = cellExpNum;

[~, path, ~, idString] = getDataFileName(exptInfo);
fileName = [path,'groupedData.mat'];
load(fileName);

saveFolderStem = char(regexp(path,'.*(?=cellNum)','match'));
saveFolder = [saveFolderStem,'Figures\','cellExpNum_',num2str(exptInfo.cellExpNum),'_figs\'];
if ~isdir(saveFolder)
    mkdir(saveFolder);
end

%% Load fly details
microCzarSettings;   % Loads settings
ephysSettings;
filename = [dataDirectory,prefixCode,'\expNum',num2str(expNum,'%03d'),...
    '\flyNum',num2str(flyNum,'%03d'),'\flyData'];
load(filename);

%% Load experiment details
settingsFileName = [path,idString,'exptData.mat'];
load(settingsFileName);

% Convert date into text
dateNumber = datenum(exptInfo.dNum,'yymmdd');
dateAsString = datestr(dateNumber,'mm-dd-yy');

%% Plot
numStim = length(GroupData);


n = 1; 
fig = figure(n);
setCurrentFigurePosition(2)
colormap(ColorSet);

h(1) = subplot(3,1,1);
plot(GroupStim(n).stimTime,GroupStim(n).stimulus,'k')
hold on
ylabel('Voltage (V)')
set(gca,'Box','off','TickDir','out','XTickLabel','')
maxStim = max(GroupStim(n).stimulus);
ylim([-maxStim-0.1 maxStim+.1])
set(gca,'xtick',[])
set(gca,'XColor','white')
if n == 1
    t = title(h(1),[dateAsString,', ',prefixCode,', ','ExpNum ',num2str(expNum),', FlyNum ',num2str(flyNum),', CellNum ',num2str(cellNum),', CellExpNum ',num2str(cellExpNum)]);
    
    %         t = title({[dateAsString,', ',prefixCode,', ','ExpNum ',num2str(expNum),', CellNum ',num2str(cellNum),', CellExpNum ',num2str(cellExpNum)];...
    %             ['Membrane Resistance = ',num2str(preExptData.initialMembraneResistance/1000),' G{\Omega}',', Access Resistance = ',num2str(preExptData.initialAccessResistance/1000),' G{\Omega}']});
    %         set(t, 'horizontalAlignment', 'left','units', 'normalized','position', [0 1 0])
    set(t,'Fontsize',20);
end

h(3) = subplot(3,1,2);
legendText = cell(6,1);
for m = 1:size(GroupData,2)
%     plot(GroupData(m).sampTime,mean(GroupData(m).voltage),'Color',ColorSet(m,:))
    plot(GroupData(m).sampTime,mean(GroupData(m).voltage)-mean(GroupData(m).voltage(5000:10000)),'Color',ColorSet(m,:))
    hold on
    legendText(m,1) = {['probe on ',StimStruct(m).stimObj.probe,', volume = ',num2str(StimStruct(m).stimObj.maxVoltage)]};
end

ylabel('Voltage (mV)')
set(gca,'Box','off','TickDir','out','XTickLabel','')
axis tight
set(gca,'xtick',[])
set(gca,'XColor','white')
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
set(gca,'Box','off','TickDir','out')
axis tight

linkaxes(h,'x')
%xlim([2.5 4])

if n == 1
    spaceplots(fig,[0 0 0.025 0])
else
    spaceplots
end

%% Format and save
saveFilename{n} = [saveFolder,'\GroupData_Stim',num2str(n),'.pdf'];

%% Format and save
% saveFileName{n} = [saveFolder,idString,'probeExpt.pdf'];
saveFileName{n} = [saveFolder,idString,'probeExpt_meanSubtracted.pdf'];
mySave(saveFileName{n});
close all


end