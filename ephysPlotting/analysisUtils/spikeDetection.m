function [spikeIdxs, spikes] = spikeDetection(current)

normCurrent = current-mean(current);
normCurrent(normCurrent<7.5) = 0;
[~,spikeIdxs] = findpeaks(normCurrent,'MinPeakDistance',40);
spikes = zeros(size(current));
spikes(spikeIdxs) = 1; 

end