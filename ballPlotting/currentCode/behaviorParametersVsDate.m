prefixCodes = {'Freq','Males','a2Glued','a3Glued','ShamGlued-45','RightGlued','LeftGlued','ShamGlued-0','Diag','Cardinal'};
threshold = 10;
%% Loop through experiments
dateArray = {};
speedArray = {};
for experiment = 1:length(prefixCodes)
    prefixCode = prefixCodes{experiment};
    
    plotData = multiFlyAnalysis(prefixCode,'y',threshold);

    dateArray = [dateArray,plotData.date];
    speedArray = [speedArray,plotData.firstSecondSpeed];
    
    
end

%% Sort and plot
[sortedDates, sortIdxs] = sort(dateArray);

figure;

bar(cell2mat(speedArray(sortIdxs)))
title(['Threshold = ',num2str(threshold)])
xlabel('Date')
ylabel('Forward speed')
