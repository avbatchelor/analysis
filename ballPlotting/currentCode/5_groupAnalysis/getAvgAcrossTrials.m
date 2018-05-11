function avgAcrossTrials = getAvgAcrossTrials(plotData)

avgAcrossTrials = cellfun(@(x) squeeze(mean(x,2)),plotData.vel,'UniformOutput',false);
% Convert to matrix 
for i = 1:plotData.numFlies
   temp(i,:,:,:) = avgAcrossTrials{i}; 
end
avgAcrossTrials = temp;