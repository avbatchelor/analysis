function psth(spikeIdxs,time,binSize)

numBins = time(end)/binSize;

spikeTimes = [];
for i = 1:length(spikeIdxs) 
    spikeTimes = [spikeTimes,time(spikeIdxs{i})];
end

h = histogram(spikeTimes,numBins);

h.EdgeColor = 'none';