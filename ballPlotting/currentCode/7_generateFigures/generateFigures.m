
%% Figure 1 
% Need to go back and do block rotation for this figure 

% Process the data 
singleFlyAnalysis('ShamGlued',1,1,2,20)

% Mean displacement 
plotMeanAcrossFliesDisp('ShamGlued-45','y','n','n','y','forFig1_withBlockRotation','y',20)

% Example trials 
plotRandomTrials('ShamGlued',1,1,2)