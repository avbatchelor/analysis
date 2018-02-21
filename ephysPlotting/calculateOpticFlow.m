function calculateOpticFlow(exptInfo)

% Calculate optic flow

%% Get paths
[~,path,~,idString] = getDataFileName(exptInfo);
vidPath = [path,'groupedVideos\'];
pPath = getProcessedDataFileName(exptInfo);

%% Calculate number of trials
try
    cd(vidPath)
catch
    disp('No videos')
    return
end
fileNames = dir('*.avi');
numTrials = length(fileNames);
if isempty(fileNames)
    disp('No movies')
    return
end

%%  Make avi files for each trial
for n = 1:numTrials    
    % Load movie for the current trial
    myMovie = [];
    myVid = VideoReader(fullfile(vidPath,fileNames(n).name));
    while hasFrame(myVid)
        currFrame = readFrame(myVid);
        myMovie(:,:,end+1) = rgb2gray(currFrame);
    end
    myMovie = uint8(myMovie(:,:,2:end)); % Adds a black first frame for some reason, so drop that
    
    % Calculate mean optical flow magnitude across frames for each trial
    opticFlowObj = opticalFlowFarneback;
    flowMag = zeros(size(myMovie, 3),1);
    for iFrame = 1:size(myMovie, 3)
        currFlow = estimateFlow(opticFlowObj, myMovie(:,:,iFrame));
        flowMag(iFrame) = mean(mean(currFlow.Magnitude));
    end
    opticFlow(n,:) = flowMag;
end

%% Save data 
saveFileName = fullfile(pPath,[idString,'opticFlow.mat']);
save(saveFileName,'opticFlow')

end
