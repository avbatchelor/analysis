%% Run all analysis 
% runAllAnalysisScript;

%% Figure 1 
figNum = 1;
prefixCodes = {'ShamGlued-45';'Diag';'Cardinal';'Freq'};
stimToPlot = {1:2;[1,4];2:3;[8,18]};
plotMeanAcrossFliesDisp(prefixCodes,'y','n','n','y','Fig1_disp_alldata','y','n',stimToPlot,figNum)
plotMeanAcrossFliesVel(prefixCodes,'y','n','n','y','Fig1_vel_alldata','y','n',stimToPlot,figNum)


% plotMeanAcrossFliesDisp('ShamGlued-45','y','n','n','y','Fig1_disp','y','n')
plotMeanAcrossFliesVel('ShamGlued-45','y','n','n','y','Fig1_vel','y','n')

stimToPlot = {1:3;[1,4];[2,3,5];[8,18,21]};
fig1QuantVel(prefixCodes,'y',stimToPlot)

% Example trials 
plotRandomTrialsFig1('ShamGlued',1,1,2)

velCorr(prefixCodes,'y',stimToPlot)

%% Figure 2 Figures 
stimToPlot = 1:2;
plotMeanAcrossFliesDisp('a2Glued','y','n','n','y','Fig2_a2Glued','y','n',stimToPlot)
plotMeanAcrossFliesDisp('a3Glued','y','n','n','y','Fig2_a3Glued','y','n',stimToPlot)
plotMeanAcrossFliesVel('a2Glued','y','n','n','y','Fig2_a2GluedVel','y','n',stimToPlot)
plotMeanAcrossFliesVel('a3Glued','y','n','n','y','Fig2_a3GluedVel','y','n',stimToPlot)

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

%% Figure 4 figures
% Cardinal without 0 degree stimulus 
plotMeanDispGrid('Cardinal','n','Fig4_Cardinal_DispGrid','y',1:4)

% Quantification 
prefixCodes = {'Cardinal',1;'Cardinal',2;'Cardinal',3;'Cardinal',4};
labels = {'45 deg speakers';'90 deg speakers'};
% Lateral velocity 
dim = 1; figName = 'Fig4_LatVelQuant';
fig5QuantVel(prefixCodes,'y',labels,figName,dim)
% Forward velocity 
dim = 2; figName = 'Fig4_ForwardVelQuant';
fig5QuantVel(prefixCodes,'y',labels,figName,dim)

% Cardinal with 0 degree stimulus 
plotMeanDispGrid('Cardinal-0','n','Fig4_CardinalWithZero_DispGrid','y',1:4)

% Quantification 
prefixCodes = {'Cardinal-0',3;'Cardinal-0',2;'Cardinal-0',1;'Cardinal-0',4};
labels = {'0';'45';'90';'180'};
% Lateral velocity 
dim = 1; figName = 'Fig4_CardinalZero_LatVelQuant';
fig4QuantVel(prefixCodes,'y',labels,figName,dim)
% Forward velocity 
dim = 2; figName = 'Fig4_CardinalZero_ForwardVelQuant';
fig4QuantVel(prefixCodes,'y',labels,figName,dim)



%% Figure 5 figures 
plotMeanDispGrid('Diag','n','Fig5_Diag_DispGrid','y',1:4)

% Lateral velocity quant
prefixCodes = {'Diag',1;'Diag',2;'Diag',3;'Diag',4};
labels = {'45';'135';'225';'315'};
figName = 'Fig5_LatVelQuant';
dim = 1;
fig4QuantVel(prefixCodes,'y',labels,figName,dim)
dim = 2; 
figName = 'Fig5_ForwardVelQuant';
fig4QuantVel(prefixCodes,'y',labels,figName,dim)


%% Figure 6 figures
stimulusExamples;
plotMeanAcrossFliesDisp('Freq','n','n','y','y','Fig6_Freq_Disp','y','y')
plotMeanAcrossFliesVel('Freq','n','n','y','y','Fig6_Freq','y','y')
fig7QuantVel('Freq','y','Fig6_Freq_latVelQuant',1)
fig7QuantVel('Freq','y','Fig6_Freq_forVelQuant',2)

sineIdxs = [1:5,11:15];
pipIdxs = [6:10,16:20];
plotMeanDispGrid('Freq','y','Fig6_Freq_DispGrid','y',pipIdxs)

integrationCheck('Freq','y',pipIdxs)

%% Figure 7 figures
figNum = 7;
plotMeanAcrossFliesDisp('Males','y','n','n','y','Fig7_MalesDisp','y','n',1:2,figNum)
plotMeanAcrossFliesDisp('Diag','y','n','n','y','Fig7_DiagDisp','y','n',[1,4],figNum)

plotMeanAcrossFliesVel('Males','y','n','n','y','Fig7_MalesVel','y','n',1:2,figNum)
plotMeanAcrossFliesVel('Diag','y','n','n','y','Fig7_DiagVel','y','n',[1,4],figNum)

%% Supplementary figures
plotRandomTrialsSupp('ShamGlued',1,1,2)