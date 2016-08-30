function plotPVData(prefixCode,expNum,flyNum,flyExpNum)

%% Load group filename
dsFactor = 400;
exptInfo.prefixCode     = prefixCode;
exptInfo.expNum         = expNum;
exptInfo.flyNum         = flyNum;
exptInfo.flyExpNum      = flyExpNum;
[~, path, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
fileName = [path,fileNamePreamble,'groupedData.mat'];
load(fileName);
fileName = [path,fileNamePreamble,'exptData.mat'];
load(fileName);

firstTrialFileName = [path,fileNamePreamble,'trial',num2str(1,'%03d'),'.mat'];
load(firstTrialFileName);
%% Figure prep
%         figure
%         set(0,'DefaultFigureWindowStyle','normal')
%         setCurrentFigurePosition(1);
%         subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.05], [0.1 0.01], [0.1 0.01]);
%         set(0,'DefaultFigureColor','w')
close all
fvTemp = [];
lvTemp = [];

%% Calculate title
dateNumber = datenum(exptInfo.dNum,'yymmdd');
dateAsString = datestr(dateNumber,'mm-dd-yy');
fileStem = char(regexp(path,'.*(?=flyExpNum)','match'));
saveFolder = [fileStem,'Figures2\'];
if ~isdir(saveFolder)
    mkdir(saveFolder)
end
saveFileName = [saveFolder,'flyExpNum',num2str(exptInfo.flyExpNum,'%03d'),'.pdf'];
flyDataPreamble = char(regexp(fileNamePreamble,'.*(?=flyExpNum)','match'));
flyDataFileName = [fileStem,flyDataPreamble,'flyData'];
load(flyDataFileName);
if ~isfield(FlyData,'aim')
    FlyData.aim = '';
end
if ~isfield(exptInfo,'flyExpNotes')
    exptInfo.flyExpNotes = '';
end

settings = ballSettingsWithPV; 


%% Hardcoded paramters
timeBefore = 0.3;
pipStartInd = Stim.startPadDur*Stim.sampleRate/dsFactor + 1;
indBefore = pipStartInd - timeBefore*Stim.sampleRate/dsFactor;
indAfter = pipStartInd + timeBefore*Stim.sampleRate/dsFactor;

%% Plot stimulus
uniqueStim = unique(groupedData.stimNum);
colorSet = distinguishable_colors(length(uniqueStim),'w');

%% spectrogram settings
window = 400;
overlap = 200;
nfft = 4000;
fs = 40000;

% window = 400;
% overlap = 200;
% nfft = 512;
% fs = 40000;


%% Plot for each stim Num
for i = 1:length(uniqueStim)
    
    if mod(i,2)
        currColor = 'b';
        figure
        set(0,'DefaultFigureWindowStyle','normal')
        setCurrentFigurePosition(1);
        subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.05], [0.1 0.01], [0.1 0.01]);
        set(0,'DefaultFigureColor','w')
    else
        currColor = 'r';
    end
    sumTitle = {[dateAsString,', ',exptInfo.prefixCode,', ','ExpNum ',num2str(exptInfo.expNum)];[char(groupedData.description(i))]};

    %% Select the trials for this stimulus
    stimNumInd = find(groupedData.stimNum == uniqueStim(i));

    %% Find the mean and std of these trials
    startPadEndIdx = (Stim.startPadDur*Stim.sampleRate)-1;
%     meanPVnp = mean(cell2mat(groupedData.KEraw(stimNumInd))');
    %meanPV = cumtrapz(groupedData.stimTimeVect{i},(meanPVnp-mean(meanPVnp(1:startPadEndIdx)))./settings.preamp_gain)./settings.KE_sf;
    meanPVnp = cell2mat(groupedData.KEraw(stimNumInd))';
    meanPV = meanPVnp(1,:);
    stdPV = std(cell2mat(groupedData.KEraw(stimNumInd))');
    meanAcqStim1 = mean(cell2mat(groupedData.acqStim1(stimNumInd))');
    stdAcqStim1 = std(cell2mat(groupedData.acqStim1(stimNumInd))');
    meanAcqStim2 = mean(cell2mat(groupedData.acqStim2(stimNumInd))');
    stdAcqStim2 = std(cell2mat(groupedData.acqStim2(stimNumInd))');
    
    %% Plot stimulus
    sph(1) = subtightplot (4, 1, 1, [0.01 0.05], [0.1 0.01], [0.1 0.01]);
%     mySimplePlot(groupedData.stimTimeVect{i},groupedData.stim{i})
%     set(gca,'XTick',[])
%     ylabel({'Stim';'(V)'})
%     set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')
%     set(gca,'XColor','white')
        hold on
        if mod(i,2) 
            mySimplePlot(groupedData.stimTimeVect{i},meanAcqStim2,'Color',currColor,'Linewidth',2)
        else
            mySimplePlot(groupedData.stimTimeVect{i},meanAcqStim1,'Color',currColor,'Linewidth',2)
        end
            set(gca,'XTick',[])
    ylabel({'Lateral Vel';'(mm/s)'})
    set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')
    symAxisY
    
    %% Plot data
    sph(2) = subplot(4,1,2);
    hold on
    f = 0:10:2000;
    if mod(i,2)
        spectrogram(meanAcqStim2,window,overlap,nfft,fs,'yaxis')
    else 
        spectrogram(meanAcqStim1,window,overlap,nfft,fs,'yaxis')
    end
    ylim([0 2000])

    sph(3) = subplot(4,1,3);
%     hold on
%     mySimplePlot(groupedData.stimTimeVect{i},meanAcqStim2,'Color',currColor,'Linewidth',2)
%     set(gca,'XTick',[])
%     ylabel({'Forward Vel';'(mm/s)'})
%     set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')
%     symAxisY
        hold on
    mySimplePlot(groupedData.stimTimeVect{i},meanPV,'Color',currColor,'Linewidth',2)
    set(gca,'XTick',[])
    ylabel({'X Disp';'(mm)'})
    set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')
    symAxisY
    
    sph(4) = subplot(4,1,4);
    spectrogram(meanPV,window,overlap,nfft,fs,'yaxis')
    ylim([0 2000])

    linkaxes(sph(:),'x')
    suptitle(sumTitle)
    saveFileName = [saveFolder,'flyExpNum',num2str(exptInfo.flyExpNum,'%03d'),'_stim',num2str(i-1,'%03d'),'_to_',num2str(i,'%03d'),'.pdf'];
    mySave(saveFileName,[5 5]);
    close all

end


end
