% Create avi movies from tiff files

function aviFromTiff(exptInfo)
%% Load settings
ephysSettings;

%% Get paths
[~,path,~,idString] = getDataFileName(exptInfo);
vidPath = [path,'groupedVideos\'];

%% Calculate number of trials
try
    cd(vidPath)
catch
    disp('No videos')
    return
end
fileNames = dir('trial*');
if isempty(fileNames)
    disp('Tiffs already converted to avi')
    return
end
numTrials = length(fileNames);

%%  Make avi files for each trial
for n = 1:numTrials
    % Get diff file names
    cd([vidPath,fileNames(n).name])
    tiffFiles = dir('*.tif');
    tiffFrames = {tiffFiles.name}';
    
    % Create video writer object
    vidFileName = [vidPath, idString, fileNames(n).name, '.avi'];
    outputVid = VideoWriter(vidFileName);
    outputVid.FrameRate = settings.camRate;
    open(outputVid)
    
    % Write each .tif file to video
    for iFrame = 1:length(tiffFrames)
        currImg = imread([vidPath, fileNames(n).name,'\', tiffFrames{iFrame}]);
        writeVideo(outputVid, currImg);
    end
    close(outputVid)
    
end

%% Delete tiffs
cd(vidPath)
rmdir('trial*','s')

