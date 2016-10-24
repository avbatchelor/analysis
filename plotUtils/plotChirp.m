function plotChirp(Stim)

% Plots the frequency of a chirp stimulus vs. time

startInd = Stim.startPadDur * Stim.sampleRate; 
endInd = length(Stim.timeVec) - (Stim.endPadDur * Stim.sampleRate);

freqTrace = zeros(1,length(Stim.timeVec));
freqTrace(1,startInd:endInd-1) = linspace(Stim.startFrequency,Stim.endFrequency,endInd-startInd);

plot(Stim.timeVec,freqTrace)
ylabel('Frequency (Hz)')

end

