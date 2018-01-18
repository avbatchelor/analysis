function [velMmFilt,disp] = processDigBallData(inputMat,stim)

% Convert binary matrix to signed integer
asDec = binaryVectorToDecimal(inputMat,'LSBFirst');
asDec = asDec -127;

% Load ball settings 
settings = ballSettings;

% Convert counts to mm/s
velMm = asDec.*settings.mmPerCount.*settings.sensorPollFreq;

% Mode filter 
velMmFilt = colfilt(velMm, [11 1], 'sliding', @mode);

%% Calculate displacement 
if exist('stim','var')
    % Integrate to calcuate displacement 
    disp = cumtrapz(stim.timeVec,velMmFilt);

    % Set 0 displacement to stimulus start
    stimStartInt = stim.startPadDur*stim.sampleRate +1; 
    disp = disp - disp(stimStartInt,1);
else 
    disp = [];
end