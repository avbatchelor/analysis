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
numStim = length(uniqueStim);

%% Make empty matrices
carrierFreq = NaN(numStim,1);
maxPVVect = NaN(numStim,1);
commandVoltages = NaN(numStim,1);

%% Plot for each stim Num
for i = 1:numStim
    
    %% Figure settings
    figure
    setCurrentFigurePosition(1);
    subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.05], [0.1 0.01], [0.1 0.01]);
    
    %% Assign title
    sumTitle = {[dateAsString,', ',exptInfo.prefixCode,', ','ExpNum ',num2str(exptInfo.expNum),', ','FlyNum ',num2str(exptInfo.flyNum),', ','ExpNum ',num2str(exptInfo.flyExpNum)];...
        [char(groupedData.description(i)),', Volume = ',num2str(StimStruct(i).stimObj.maxVoltage) ];...
        ['Microphone: ',exptInfo.microphone,', Speaker = ',num2str(exptInfo.speaker),', ',exptInfo.ampType,', Speaker Distance = ',num2str(exptInfo.speakerDistance),'cm']};
    
    
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
    load('C:\Users\Alex\Documents\GitHub\analysis\ballPlotting\pvPlotting\freqVsKE');
    if strcmp(exptInfo.microphone,'KE1')
        microphoneConstant = k1Map(StimStruct(i).stimObj.carrierFreqHz);
    else
        microphoneConstant = k2Map(StimStruct(i).stimObj.carrierFreqHz);
    end
    
    integratedPV = cumtrapz(groupedData.stimTimeVect{i},(baselineSubtractedPV)./exptInfo.ampGain)./microphoneConstant;
    
    %% High pass filter
    cutoffFreq = 70;
    rate = 2*(cutoffFreq/StimStruct(i).stimObj.sampleRate);
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
    if isfield(StimStruct(i).stimObj,'ipi')
        pvDurStim = pvInMM(startInd:endInd);
        minDistance = (StimStruct(i).stimObj.ipi - StimStruct(i).stimObj.pipDur) * StimStruct(i).stimObj.sampleRate;
        idxToAdd = startInd-1;
    else
        rampInd = (StimStruct(i).stimObj.stimDur/10) * StimStruct(i).stimObj.sampleRate;
        pvDurStim = pvInMM(startInd+rampInd:endInd-rampInd);
        minDistance = (StimStruct(i).stimObj.stimDur/3)* StimStruct(i).stimObj.sampleRate;
        idxToAdd = startInd-1+rampInd;
    end
    currentTimeVec = groupedData.stimTimeVect{i};
    
    % Max peaks
    [maxPeaks,relPeakIdxs] = findpeaks(pvDurStim,'MinPeakDistance',minDistance);
    peakIdxs = idxToAdd+relPeakIdxs;
    peakTimes = currentTimeVec(peakIdxs);
    threshold = max(maxPeaks)/2;
    rmIdx = find(maxPeaks<threshold);
    peakTimes(rmIdx) = [];
    maxPeaks(rmIdx) = [];
    plot(peakTimes,maxPeaks,'ro')
    
    % Min peaks
    [minPeaks,relPeakIdxs] = findpeaks(-pvDurStim,'MinPeakDistance',minDistance);
    peakIdxs = idxToAdd+relPeakIdxs;
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
    
    carrierFreq(i) = StimStruct(i).stimObj.carrierFreqHz;
    maxPVVect(i) = maxPV;
    commandVoltages(i) = StimStruct(i).stimObj.maxVoltage;
    
    %% Fit a sine wave to particle velocity 
    % Estimate period (per is # of samples in full wave)
    per = 1/StimStruct(i).stimObj.carrierFreqHz;                     
    offset = 0; 
    
    % Fit 
    timeVec = groupedData.stimTimeVect{i};
    x = timeVec(idxToAdd+1:idxToAdd+length(pvDurStim));
    y = pvDurStim;
    % Function to fit
    fit = @(b,x)  maxPV.*(sin(2*pi*x./per + 2*pi/b(1))) + offset; 
    % Least-Squares cost function
    fcn = @(b) sum((fit(b,x) - y).^2); 
    % Minimise Least-Squares
    s = fminsearch(fcn, 0);                       
    
    % Plot 
    figure(1)
    plot(x,fit(s,x),'r')
    
    figure(3) 
    plot(x,maxPV.*(sin(2*pi*x./per)) + offset); 
    
    figure(4) 
    plot(x,sin(x))
    
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
    
    close all;
    
end

%% Plot 
uCarrierFreqs = unique(carrierFreq);
for i = 1:length(uCarrierFreqs)
    freqIdx = find(carrierFreq == uCarrierFreqs(i));
    figure;
    hold on 
    plot(commandVoltages(freqIdx),maxPVVect(freqIdx),'bo')
    desiredCommand = interp1(maxPVVect(freqIdx),commandVoltages(freqIdx),1.25,'spline');
    plot(desiredCommand,1.25,'ro')
    xlabel('Command Voltage (V)')
    ylabel('Particle velocity (mm/s)')
    title(['Frequency = ',num2str(uCarrierFreqs(i)),', Command Voltage = ',num2str(desiredCommand),' V']);
end




end
