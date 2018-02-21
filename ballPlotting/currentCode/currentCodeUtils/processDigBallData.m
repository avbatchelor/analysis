function [velMmFilt,disp,saturationWarning] = processDigBallData(inputMat,stim,axis,exptInfo)

%% Convert binary matrix to integer
asDec = binaryVectorToDecimal(inputMat,'LSBFirst');

%% Check for saturation 
if any(asDec == 254)  || any(asDec == 0)
    saturationWarning = 1;
else
    saturationWarning = 0;
end


%% Convert integer to signed integer 
if strcmp(axis,'x')
    asDec = asDec - 127;
else
    if datenum(exptInfo.dNum,'yymmdd') >= datenum('180206','yymmdd')
        asDec = asDec - 50;
    else 
        asDec = asDec - 127; 
    end
end

%% Convert to units of mm/s
% Load ball settings 
settings = ballSettings;

% Convert counts to mm/s
velMm = asDec.*settings.mmPerCount.*settings.sensorPollFreq;
 

%% Mode filter
% removes errors that occur becuase output bits aren't set simultaneously
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