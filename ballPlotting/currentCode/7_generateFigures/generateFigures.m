
%% Figure 1 
% Need to go back and do block rotation for this figure 

% Process the data 

% Mean displacement 
plotMeanAcrossFliesDisp('ShamGlued-45','y','n','n','y','forFig1_withBlockRotation','y','n')
plotMeanAcrossFliesVel('ShamGlued-45','y','n','n','y','VelforFig1_withBlockRotation','y','n')

% Example trials 
plotRandomTrials('ShamGlued',1,1,2)

%% Figure 2 Analysis
prefixCodes = {'a2Glued';'a3Glued'};
runAllAnalysisScript(prefixCodes)

%% Figure 2 Figures 
plotMeanAcrossFliesDisp('a2Glued','y','n','n','y','Fig2_a2Glued','y','n')
plotMeanAcrossFliesVel('a2Glued','y','n','n','y','Fig2_a2GluedVel','y','n')
plotMeanAcrossFliesDisp('a3Glued','y','n','n','y','Fig2_a3Glued','y','n')
plotMeanAcrossFliesVel('a3Glued','y','n','n','y','Fig2_a3GluedVel','y','n')

prefixCodes = {'a2Glued',1:2;'a3Glued',1:2;'ShamGlued-45',1:2;'ShamGlued-45',3};
mirroredVelocityPlot(prefixCodes,'y')