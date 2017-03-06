%% CALCULATE OR LOAD MEAN OPTICAL FLOW

nTrials = length(expData.expInfo);
strDate = expData.expInfo(1).date;
parentDir = 'C:\Users\Wilson Lab\Documents\MATLAB\Data\_Movies';
allFlow = cell(nTrials, 1);
if isempty(dir(fullfile('C:\Users\Wilson Lab\Documents\MATLAB\Data', strDate,['E', num2str(expData.expInfo(1).expNum),'OpticFlowData.mat'])))
    for iTrial = 1:nTrials
        trialStr = ['E', num2str(expData.expInfo(1).expNum), '_T', num2str(iTrial)];
        disp(['E', num2str(expData.expInfo(1).expNum), '_T', num2str(iTrial)])
        
        % Load movie for the current trial
        myMovie = [];
        myVid = VideoReader(fullfile(parentDir, strDate, trialStr, [trialStr, '.avi']));
        while hasFrame(myVid)
            currFrame = readFrame(myVid);
            myMovie(:,:,end+1) = rgb2gray(currFrame);%double(rgb2gray(currFrame))./double(max(max(rgb2gray(currFrame))));
        end
        myMovie = uint8(myMovie(:,:,2:end)); % Adds a black first frame for some reason, so drop that
        
        % Calculate mean optical flow magnitude across frames for each trial
        opticFlow = opticalFlowFarneback;
        currFlow = []; flowMag = zeros(size(myMovie, 3),1);%size(allMovies{iTrial},3), 1);
        for iFrame = 1:size(myMovie, 3)%1:size(allMovies{iTrial}, 3)
            currFlow = estimateFlow(opticFlow, myMovie(:,:,iFrame));%allMovies{iTrial}(:,:,iFrame));
            flowMag(iFrame) = mean(mean(currFlow.Magnitude));
        end
        allFlow{iTrial} = flowMag;
    end
    
    % Save data to disk for future use
    save(fullfile('C:\Users\Wilson Lab\Documents\MATLAB\Data', strDate,['E', num2str(expData.expInfo(1).expNum),'OpticFlowData.mat']), 'allFlow');
    save(fullfile('U:\Data Backup', strDate,['E', num2str(expData.expInfo(1).expNum),'OpticFlowData.mat']), 'allFlow');
else
    load(fullfile('C:\Users\Wilson Lab\Documents\MATLAB\Data', strDate,['E', num2str(expData.expInfo(1).expNum),'OpticFlowData.mat']));
end