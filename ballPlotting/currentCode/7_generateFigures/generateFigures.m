
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
plotMeanAcrossFliesDisp('a3Glued','y','n','n','y','Fig2_a3Glued','y','n')
plotMeanAcrossFliesVel('a2Glued','y','n','n','y','Fig2_a2GluedVel','y','n')
plotMeanAcrossFliesVel('a3Glued','y','n','n','y','Fig2_a3GluedVel','y','n')

% Lateral velocity quant
prefixCodes = {'a2Glued',1:2;'a3Glued',1:2;'ShamGlued-45',1:2;'ShamGlued-45',3};
labels = {'a2 Glued';'a3 Glued';'Sham Glued';'Sham Glued - no stim'};
figName = 'Fig2_MirroredLatVelQuant';
dim = 1;
mirroredVelocityPlot(prefixCodes,'y',labels,figName,dim)
dim = 2; 
figName = 'Fig2_ForwardVelQuantDiffAvg';
mirroredVelocityPlot(prefixCodes,'y',labels,figName,dim)

%% Figure 3 Figures 
prefixCodes = {'LeftGlued';'RightGlued'};
runAllAnalysisScript(prefixCodes)

plotMeanAcrossFliesDisp('RightGlued','y','n','n','y','Fig3_RightGluedDisp','y','n')
plotMeanAcrossFliesDisp('LeftGlued','y','n','n','y','Fig3_LeftGluedDisp','y','n')
plotMeanAcrossFliesVel('RightGlued','y','n','n','y','Fig3_RightGluedVel','y','n')
plotMeanAcrossFliesVel('LeftGlued','y','n','n','y','Fig3_LeftGluedVel','y','n')

% Lateral velocity quant
prefixCodes = {'a2Glued',1:2;'a3Glued',1:2;'ShamGlued-45',1:2;'ShamGlued-45',3};
labels = {'a2 Glued';'a3 Glued';'Sham Glued';'Sham Glued - no stim'};
figName = 'Fig2_MirroredLatVelQuant';
dim = 1;
mirroredVelocityPlot(prefixCodes,'y',labels,figName,dim)
dim = 2; 
figName = 'Fig2_ForwardVelQuantDiffAvg';
mirroredVelocityPlot(prefixCodes,'y',labels,figName,dim)