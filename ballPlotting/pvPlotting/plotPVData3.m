function plotPVData3(prefixCode,expNum,flyNum,flyExpNum)

%% Assign exptInfo
exptInfo.prefixCode     = prefixCode;
exptInfo.expNum         = expNum;
exptInfo.flyNum         = flyNum;
exptInfo.flyExpNum      = flyExpNum;

%% Load group filename
% Get filename
[~, path, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);

% Load grouped data
fileName = [path,fileNamePreamble,'groupedData.mat'];
load(fileName);

% Load experiment data
fileName = [path,fileNamePreamble,'exptData.mat'];
load(fileName);

% Load first trial data
% firstTrialFileName = [path,fileNamePreamble,'trial',num2str(1,'%03d'),'.mat'];
% load(firstTrialFileName);

%% Figure prep
close all

%% Get data for title
dateNumber = datenum(exptInfo.dNum,'yymmdd');
dateAsString = datestr(dateNumber,'mm-dd-yy');

%% Get save folder name
fileStem = char(regexp(path,'.*(?=flyExpNum)','match'));
saveFolder = [fileStem,'Figures\'];
if ~isdir(saveFolder)
    mkdir(saveFolder)
end

%% Load settings
settings = ballSettingsWithPV;

%% Determine # of stimuli
uniqueStim = unique(groupedData.stimNum);


%% Plot for each stim Num
for i = 1:length(uniqueStim)
    
    %% Figure settings
    figure
    setCurrentFigurePosition(1);
    subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.05], [0.1 0.01], [0.1 0.01]);
    
    %% Assign title
    try
    sumTitle = {[dateAsString,', ',exptInfo.prefixCode,', ','ExpNum ',num2str(exptInfo.expNum),', ',exptInfo.microphone,', speaker = ',num2str(exptInfo.speaker)];...
        [char(groupedData.description(i)),', Volume = ',num2str(StimStruct(i).stimObj.maxVoltage) ]};
    catch
    end
    
    %% Calculate meta data
    % Select the trials for this stimulus
    stimNumInd = find(groupedData.stimNum == uniqueStim(i));
    disp(stimNumInd)
    
    % Get stimulus start and end indices
    startInd = StimStruct(i).stimObj.startPadDur * StimStruct(i).stimObj.sampleRate + 1;
    endInd = round((StimStruct(i).stimObj.startPadDur + StimStruct(i).stimObj.stimDur) * StimStruct(i).stimObj.sampleRate); 
    
    %% Calculate mean
    startPadEndIdx = (StimStruct(i).stimObj.startPadDur*StimStruct(i).stimObj.sampleRate)-1;
    meanPV = mean(cell2mat(groupedData.KEraw(stimNumInd))');
    
    %% BaselineSubtract 
    baselineSubtractedPV = meanPV-mean(meanPV(1:startPadEndIdx));
    
    %% Integrate
    integratedPV = cumtrapz(groupedData.stimTimeVect{i},(baselineSubtractedPV)./exptInfo.ampGain)./settings.KE_sf;
    
    %% High pass filter
    rate = 2*(10/StimStruct(i).stimObj.sampleRate);
    [kb, ka] = butter(2,rate,'high');
    filteredPV = filtfilt(kb, ka, integratedPV);
    
    %% Convert to mmPerSec 
    pvInMM = 1000*filteredPV;
    
    %% Number of Plots 
    numPlots = 6; 

    %% Plot stimulus
    plotNum = 1;
    ph(plotNum) = subtightplot (numPlots, 1, plotNum, [0.01 0.05], [0.1 0.01], [0.1 0.01]);
    plot(groupedData.stimTimeVect{i},groupedData.stim{i})
    
    noXAxisSettings
    ylabel('Stimlus (V)')
    symAxisY
    t = title('Stimulus');
    leftAlignTitle(t);
    
    %% Plot raw data
    % Subplot settings 
    plotNum = 2;
    ph(plotNum) = subtightplot (numPlots, 1, plotNum, [0.01 0.05], [0.1 0.01], [0.1 0.01]);
    
    % Plot 
    plot(groupedData.stimTimeVect{i},cell2mat(groupedData.KEraw(stimNumInd)))
    
    % Axis settings
    symAxisY
    noXAxisSettings

    % Labels
    ylabel('Stimlus (V)')
    t = title('Raw Data');
    leftAlignTitle(t);
    
    %% Plot average
    % Subplot settings 
    plotNum = 3;
    ph(plotNum) = subtightplot (numPlots, 1, plotNum, [0.01 0.05], [0.1 0.01], [0.1 0.01]);
    
    % Plot 
    plot(groupedData.stimTimeVect{i},meanPV)
    
    % Axis settings
    symAxisY
    noXAxisSettings
    
    % Labels
    ylabel('Stimlus (V)')
    t = title('Averaged data');
    leftAlignTitle(t);
    
    %% Plot baseline subtracted
    % Subplot settings 
    plotNum = 4;
    ph(plotNum) = subtightplot (numPlots, 1, plotNum, [0.01 0.05], [0.1 0.01], [0.1 0.01]);
    
    % Plot 
    plot(groupedData.stimTimeVect{i},baselineSubtractedPV)
    
    % Axis settings
    symAxisY
    noXAxisSettings
    
    % Labels
    ylabel('Stimlus (V)')
    t = title('Averaged, baseline subtracted');
    leftAlignTitle(t);
    
    %% Plot integrated
    % Subplot settings 
    plotNum = 5;
    ph(plotNum) = subtightplot (numPlots, 1, plotNum, [0.01 0.05], [0.1 0.01], [0.1 0.01]);
    
    % Plot 
    plot(groupedData.stimTimeVect{i},integratedPV)
    
    % Axis settings
    symAxisY
    noXAxisSettings
    
    % Labels
    ylabel('Stimlus (V)')
    t = title('Averaged, baseline subtracted and integrated');
    leftAlignTitle(t);
    
    
    %% Plot filtered PV
    plotNum = 6;
    ph(plotNum) = subplot(numPlots,1,plotNum);
    hold on
    plot(groupedData.stimTimeVect{i},pvInMM)
    ylabel('PV (mm/s)')
    bottomAxisSettings
    symAxisY
    
    %% Detect max voltage 
    pvDurStim = pvInMM(startInd:endInd);
    if isfield(StimStruct(i).stimObj,'ipi')
        minDistance = (StimStruct(i).stimObj.ipi - StimStruct(i).stimObj.pipDur) * StimStruct(i).stimObj.sampleRate;
    else
        minDistance = (StimStruct(i).stimObj.stimDur/3)* StimStruct(i).stimObj.sampleRate;
    end
    currentTimeVec = groupedData.stimTimeVect{i};
    
    % Max peaks 
    [maxPeaks,relPeakIdxs] = findpeaks(pvDurStim,'MinPeakDistance',minDistance);
    peakIdxs = startInd-1+relPeakIdxs;
    peakTimes = currentTimeVec(peakIdxs);
    threshold = max(maxPeaks)/2;
    rmIdx = find(maxPeaks<threshold);
    peakTimes(rmIdx) = [];
    maxPeaks(rmIdx) = [];
    plot(peakTimes,maxPeaks,'ro')

    % Min peaks 
    [minPeaks,relPeakIdxs] = findpeaks(-pvDurStim,'MinPeakDistance',minDistance);
    peakIdxs = startInd-1+relPeakIdxs;
    peakTimes = currentTimeVec(peakIdxs);
    threshold = max(minPeaks)/2;
    rmIdx = find(minPeaks<threshold);
    peakTimes(rmIdx) = [];
    minPeaks(rmIdx) = [];
    plot(peakTimes,-minPeaks,'go')
    
    % Mean max PV
    maxPV = mean([minPeaks,maxPeaks]);
    
    t = title({'Averaged, baseline subtracted,','integrated and high pass filtered (10Hz cutoff)',['Max PV = ',num2str(maxPV),' mm/s']});
    leftAlignTitle(t);

    %% Adjust axes
    linkaxes(ph(:),'x')
    startView = StimStruct(i).stimObj.startPadDur -0.1;
    endView = StimStruct(i).stimObj.startPadDur + StimStruct(i).stimObj.stimDur + 0.1;
    xlim([startView, endView])
    
    %% Add title
    suptitle(sumTitle)
    
    %% Save figure
    saveFileName = [saveFolder,'flyExpNum',num2str(exptInfo.flyExpNum,'%03d'),'_stim',num2str(i-1,'%03d'),'_to_',num2str(i,'%03d'),'.pdf'];
    mySave(saveFileName);
    
    
    
end


end
