function pvSuppPlot

expts = {'pvCal',13,1,3;'pvCal',6,3,1;'pvCal',12,1,5;'pvCal',11,1,1};

%% Figure prep
close all
goFigure(1);
gray = [0.8,0.8,0.8];
pvResults = nan(4,5,120000);

for exptNum = 1:length(expts)
    
    % Assign experiment info
    [prefixCode,expNum,flyNum,flyExpNum] = deal(expts{exptNum,:});
    exptInfo = exptInfoStruct(prefixCode,expNum,flyNum,flyExpNum);
    
    
    %% Load group filename
    % Get filename
    [~, path, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
    
    % Load grouped data
    fileName = [path,fileNamePreamble,'groupedData.mat'];
    load(fileName);
    
    % Load experiment data
    fileName = [path,fileNamePreamble,'exptData.mat'];
    load(fileName);
   
    
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
    stimOrder = [1,2,4,5,7];
    for stim = stimOrder
        
        %% Figure settings
        subplot = @(m,n,p) subtightplot (m, n, p, [0.025 0.025], [0.15 0.01], [0.15 0.02]);

        %% Calculate meta data
        % Select the trials for this stimulus
        stimNumInd = find(groupedData.stimNum == uniqueStim(stim));
        disp(stimNumInd)
        
        % Get stimulus start and end indices
        startInd = StimStruct(stim).stimObj.startPadDur * StimStruct(stim).stimObj.sampleRate + 1;
        endInd = round((StimStruct(stim).stimObj.startPadDur + StimStruct(stim).stimObj.stimDur) * StimStruct(stim).stimObj.sampleRate);
        
        % Calculate mean
        startPadEndIdx = (StimStruct(stim).stimObj.startPadDur*StimStruct(stim).stimObj.sampleRate)-1;
        meanPV = mean(cell2mat(groupedData.KEraw(stimNumInd))');
        
        % BaselineSubtract
        baselineSubtractedPV = meanPV-mean(meanPV(1:startPadEndIdx));
        
        % Integrate
        load('C:\Users\Alex\Documents\GitHub\analysis\ballPlotting\pvPlotting\freqVsKE');
        if strcmp(exptInfo.microphone,'KE1')
            microphoneConstant = k1Map(StimStruct(stim).stimObj.carrierFreqHz);
        else
            microphoneConstant = k2Map(StimStruct(stim).stimObj.carrierFreqHz);
        end
        
        integratedPV = cumtrapz(groupedData.stimTimeVect{stim},(baselineSubtractedPV)./exptInfo.ampGain)./microphoneConstant;
        
        % High pass filter
        cutoffFreq = 70;
        rate = 2*(cutoffFreq/StimStruct(stim).stimObj.sampleRate);
        [kb, ka] = butter(2,rate,'high');
        filteredPV = filtfilt(kb, ka, integratedPV);
        
        % Convert to mmPerSec
        pvInMM = 1000*filteredPV;
        
        
        %% Plot stimulus
%         plotNum = 1;
%         ph(plotNum) = subtightplot (numPlots, 1, plotNum, [0.01 0.05], [0.1 0.01], [0.1 0.01]);
%         plot(groupedData.stimTimeVect{stim},groupedData.stim{stim})
%         
%         noXAxisSettings
%         ylabel('Stimlus (V)')
%         symAxisY
%         t = title('Stimulus');
%         leftAlignTitle(t);
        
        %% Plot filtered PV
        plotNum = 6;
        ph(plotNum) = subplot(5,1,find(stimOrder == stim));
        hold on
        plot(groupedData.stimTimeVect{stim},pvInMM)
        symAxisY
        
        plotNum = find(stimOrder == stim);
        pvResults(exptNum,stim,:) = pvInMM;
        
        if stim == stimOrder(end)
            bottomAxisSettings
            xlabel('time (s)')
        else
            noXAxisSettings('w')
        end
        
        if stim == 4
            ylabel({'particle';'velocity';'mm/s'})
        end
        
        set(gca,'yTick',[-1, 0, 1])
            
        if exptNum == length(expts)
            %% Detect max voltage
            meanPV = squeeze(mean(pvResults(:,stim,:)))';
            rampInd = (StimStruct(stim).stimObj.stimDur/10) * StimStruct(stim).stimObj.sampleRate;
            pvDurStim = meanPV(startInd+rampInd:endInd-rampInd);
            minDistance = (StimStruct(stim).stimObj.stimDur/3)* StimStruct(stim).stimObj.sampleRate;
            idxToAdd = startInd-1+rampInd;
            currentTimeVec = groupedData.stimTimeVect{stim};

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

            carrierFreq(stim) = StimStruct(stim).stimObj.carrierFreqHz;
            maxPVVect(stim) = maxPV;
            commandVoltages(stim) = StimStruct(stim).stimObj.maxVoltage;
    
            %% Fit a sine wave to particle velocity
            % Estimate period (per is # of samples in full wave)
            per = 1/StimStruct(stim).stimObj.carrierFreqHz;
            offset = 0;

            
            % Fit
            timeVec = groupedData.stimTimeVect{stim};
            x = timeVec(idxToAdd+1:idxToAdd+length(pvDurStim));
            y = pvDurStim;
            % Function to fit
%             fit = @(b,x)  maxPV.*( sin(2*pi*x./per + 2*pi/b(1)) ) + offset;
            fit = @(b,x)  maxPV.*( sin(2*pi*x./per + b(1)) ) + offset;
            % Least-Squares cost function
            fcn = @(b) sum((fit(b,x) - y).^2);
            % Minimise Least-Squares
            options = optimset('MaxIter',10000);
            s = fminsearch(fcn, 0,options);
        
            % Plot
            fith = plot(x,fit(s,x),'Color',gray,'Linewidth',4);
            uistack(fith,'bottom')

%             plot(x,maxPV.*(sin(2*pi*x./per)) + offset,'r','Linewidth',2);
%         
%             figure(4)
%             plot(x,sin(x))
        end
        
        %% Adjust axes
        linkaxes(ph(:),'x')
        xlim([1.5, 1.52])
        
        
        
    end  
end

set(findall(gcf,'-property','FontSize'),'FontSize',30)

%% Save figure
figPath = 'D:\ManuscriptData\summaryFigures';
statusStr = checkRepoStatus;
filename = [figPath,'\particleVelocityTraces','_',statusStr,'.pdf'];
export_fig(filename,'-pdf','-painters')

end
