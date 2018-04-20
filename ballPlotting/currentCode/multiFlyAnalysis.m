function plotData = multiFlyAnalysis(prefixCode,allTrials)

%% Close all
close all

%% Load analysis settings
analysisSettings;

%% Fly data
flies = getFlyExpts(prefixCode);

% Count number of flies 
plotData.numFlies = size(flies,1);

%% Loop through flies
for fly = 1:size(flies,1)
    % Make expt info
    [prefixCode,expNum,flyNum,flyExpNum] = flies{fly,:};
    exptInfo = exptInfoStruct(prefixCode,expNum,flyNum,flyExpNum);
    
    % Load groupedData
    [groupedData,StimStruct] = loadProcessedData(exptInfo);
    
    %% Determine number of trials to use
    if allTrials == 'y'
        for stimNum = unique(groupedData.stimNum)
            fastTrialsPerStim(stimNum) = sum(groupedData.trialSpeed > speedThreshold & groupedData.stimNum == stimNum);
        end     
        plotData.numTrialsPerFly = min(fastTrialsPerStim);
    else
        plotData.numTrialsPerFly = prefixCodeTrialNums(prefixCode);
    end
    
    
    %% Loop through stimuli
    for stimNum = unique(groupedData.stimNum)
        
        % Fix problem with Diag switching speakers 
        if strcmp(prefixCode,'Diag')
            angleOrder = [45, 135, 225, 315];
            stimIdx = find(angleOrder == StimStruct(stimNum).stimObj.speakerAngle);
        else
            stimIdx = stimNum;
        end

        % Select first so many trials above threshold
        allFastTrials = find(groupedData.trialSpeed > speedThreshold & groupedData.stimNum == stimIdx);
        selectedTrials = allFastTrials(1:plotData.numTrialsPerFly);
        
        % Make displacement matrix which has dimensions: fly x stim x trials x time x axis
        plotData.disp{fly}(stimNum,:,:,1) = groupedData.rotXDisp(selectedTrials,:);
        plotData.disp{fly}(stimNum,:,:,2) = groupedData.rotYDisp(selectedTrials,:);
        
        % Velocity
        plotData.vel{fly}(stimNum,:,:,1) = groupedData.rotXVel(selectedTrials,:);
        plotData.vel{fly}(stimNum,:,:,2) = groupedData.rotYVel(selectedTrials,:);
        
        % Time
        plotData.time = groupedData.dsTime{1};
        
        %% Set legend text
        if fly == 2
            if isfield(StimStruct(stimIdx).stimObj,'speakerAngle')
                description = StimStruct(stimIdx).stimObj.description;
                description = regexprep(description,', IPI.*',' ');
                plotData.legendText{stimNum} = ['Angle = ',num2str(StimStruct(stimIdx).stimObj.speakerAngle),', ',description];
            else
                plotData.legendText{stimNum} = 'no stimulus';
            end
        end
        
        
    end  
end

%% Number of stimuli
plotData.numStim = length(unique(groupedData.stimNum));


