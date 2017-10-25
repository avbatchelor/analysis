function dB = mmPerSecTodB(inputSpeed)

inputSpeedInM = inputSpeed*(10^(-3));
refSpeed = 5*(10^(-8));
dB = 20*log10(inputSpeedInM/refSpeed);

end