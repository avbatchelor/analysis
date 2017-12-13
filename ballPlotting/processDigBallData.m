function velMmFilt = processDigBallData(inputMat)

asDec = binaryVectorToDecimal(inputMat,'LSBFirst');
asDec = asDec -127;

settings = ballSettings;
velMm = asDec.*settings.mmPerCount.*settings.sensorPollFreq;

% Mode filter 
velMmFilt = colfilt(velMm, [11 1], 'sliding', @mode);