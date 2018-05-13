
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
prefixCodes = {'RightGlued',1;'LeftGlued',1;'RightGlued',2;'LeftGlued',2};
labels = {'Stimulus';'No stimulus'};
figName = 'Fig3_LatVelQuant';
dim = 1;
fig3QuantVel(prefixCodes,'y',labels,figName,dim)

%% Figure 4 analysis 
prefixCodes = {'Diag'};
runAllAnalysisScript(prefixCodes)

%% Figure 4 figures 
% for i = 1:5
%     figName = sprintf('Fig4_DiagDisp%d',i);
%     plotMeanAcrossFliesDisp('Diag','y','n','n','y',figName,'y','n',i)
% end
% for i = 1:5
%     figName = sprintf('Fig4_DiagVel%d',i);
%     plotMeanAcrossFliesVel('Diag','y','n','n','y',figName,'y','n',i)
% end
% 
% plotMeanAcrossFliesDisp('Diag','n','n','n','y','Fig4_Diag_MeanDisp','y','y',i)


plotMeanDispGrid('Diag','n','Fig4_Diag_DispGrid','y',1:4)

% Lateral velocity quant
prefixCodes = {'Diag',1;'Diag',2;'Diag',3;'Diag',4};
labels = {'45';'135';'225';'315'};
figName = 'Fig4_LatVelQuant';
dim = 1;
fig4QuantVel(prefixCodes,'y',labels,figName,dim)
dim = 2; 
figName = 'Fig4_ForwardVelQuant';
fig4QuantVel(prefixCodes,'y',labels,figName,dim)

%% Figure 5 analysis 
prefixCodes = {'Cardinal'};
runAllAnalysisScript(prefixCodes)

%% Figure 5 figures
% plotMeanAcrossFliesDisp('Cardinal','y','n','n','y','Fig5_CardinalDisp','y','n')
% plotMeanAcrossFliesVel('Cardinal','y','n','n','y','Fig5_CardinalVel','y','n')

plotMeanDispGrid('Cardinal','n','Fig5_Cardinal_DispGrid','y',1:4)

% Lateral velocity quant
prefixCodes = {'Cardinal',1;'Cardinal',2;'Cardinal',3;'Cardinal',4};
labels = {'45 deg speakers';'90 deg speakers'};
figName = 'Fig5_LatVelQuant';
dim = 1;
fig5QuantVel(prefixCodes,'y',labels,figName,dim)
figName = 'Fig5_LatVelDiff';
fig5VelDiff(prefixCodes,'y',labels,figName,dim)
dim = 2; 
figName = 'Fig5_ForwardVelQuant';
fig5QuantVel(prefixCodes,'y',labels,figName,dim)

%% Figure 6 analysis 
prefixCodes = {'Males'};
runAllAnalysisScript(prefixCodes)

%% Figure 6 figures
plotMeanAcrossFliesDisp('Males','y','n','n','y','Fig6_MalesDisp','y','n',1:2)
plotMeanAcrossFliesDisp('Diag','y','n','n','y','Fig6_DiagDisp','y','n',[1,4])

plotMeanAcrossFliesVel('Males','y','n','n','y','Fig6_MalesVel','y','n',1:2)
plotMeanAcrossFliesVel('Diag','y','n','n','y','Fig6_DiagVel','y','n',[1,4])

%% Figure 7 analysis 
prefixCodes = {'Freq'};
runAllAnalysisScript(prefixCodes)

%% Figure 7 figures
plotMeanAcrossFliesDisp('Freq','y','n','n','y','Fig7_Freq','y','n')
plotMeanAcrossFliesVel('Freq','y','n','n','y','Fig7_Freq','y','n')