function runAnalysisSingleFlies(prefixCode,analysisType)

% Run analysis on all single flies 

% Get the experiment numbers for each fly 
flies = getFlyExpts(prefixCode);

% Loop through flies
for fly = 1:size(flies,1)
    % Make expt info
    [prefixCode,expNum,flyNum,flyExpNum] = flies{fly,:};
    
    % Do analysis 
    singleFlyAnalysis(prefixCode,expNum,flyNum,flyExpNum)
    if strcmp(analysisType,stimOrder)
        plotStimOrderSingleFly(prefixCode,expNum,flyNum,flyExpNum,'n','n','y')
    elseif strcmp(analysisType,blocks)       
        plotBlocksSingleFly(prefixCode,expNum,flyNum,flyExpNum,'n','n','y')
    end
    
end