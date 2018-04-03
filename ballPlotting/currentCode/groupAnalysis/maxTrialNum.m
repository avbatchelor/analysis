function maxTrialNum(threshold,prefixCode,varargin)

if ~exist('prefixCode','var')
    prefixCodes = {'Freq','Males','a2Glued','a3Glued','ShamGlued-45','RightGlued','LeftGlued','ShamGlued-0','Diag','Cardinal'};
else 
    prefixCodes = {prefixCode};
end

%% Get flies 
for i = 1:length(prefixCodes)
    prefixCode = prefixCodes{i};
    numFastTrials = numAboveThresholdTrials(prefixCode,threshold);
    disp([prefixCode,': ',num2str(min(numFastTrials(:)))])
end

