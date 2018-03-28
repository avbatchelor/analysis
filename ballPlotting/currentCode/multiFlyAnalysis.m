function multiFlyAnalysis(prefixCode)

close all

%% Load analysis settings 
analysisSettings;

%% Get flies 
flies = getFlyExpts(prefixCode);

%% Determine number of trials to use
numTrialsPerFly = prefixCodeTrialNums(prefixCode);
numFlies = size(flies,1);

%% Loop through flies 
for fly = 1:size(flies,1)
    % Make expt info 
    [prefixCode,expNum,flyNum,flyExpNum] = flies{fly,:};
    exptInfo = exptInfoStruct(prefixCode,expNum,flyNum,flyExpNum);
      
    % Load groupedData
    [groupedData,StimStruct] = loadProcessedData(exptInfo);
    
    %% Loop through stimuli 
    for stimNum = unique(groupedData.stimNum)
        if prefixCode == 'Diag'
            angleOrder = [45, 135, 225, 315];
            stimIdx = find(angleOrder == StimStruct(stimNum).stimObj.speakerAngle);
        else
            stimIdx = stimNum;
        end
            
        
        allFastTrials = find(groupedData.trialSpeed > threshold & groupedData.stimNum == stimIdx);
        selectFastTrials = allFastTrials(1:numTrialsPerFly);
        
        % Make a matrix which has dimensions: fly x stim x trials x time x
        % axis
        allFliesDisp(fly,stimNum,:,:,1) = groupedData.rotXDisp(selectFastTrials,:);
        allFliesDisp(fly,stimNum,:,:,2) = groupedData.rotYDisp(selectFastTrials,:);

        %% Set legend text
        if fly == 1
            if isfield(StimStruct(stimIdx).stimObj,'speakerAngle')
                plotData.legendText{stimNum} = ['Angle = ',num2str(StimStruct(stimIdx).stimObj.speakerAngle),', ',num2str(StimStruct(stimIdx).stimObj.description)];
            else
                plotData.legendText{stimNum} = '';
            end
        end
        
        
    end
    
    

end

%%
numStim = length(unique(groupedData.stimNum));
timeLength = size(allFliesDisp,4);

%% Figures
% Average across trials 
avgAcrossTrials = squeeze(mean(allFliesDisp,3));

% Figure settings
colors = distinguishable_colors(numStim,'w');
goFigure;

% Plot each fly separately
for stim = 1:numStim
    plot(squeeze(avgAcrossTrials(:,stim,:,1))',squeeze(avgAcrossTrials(:,stim,:,2))','--','Color',colors(stim,:))
    hold on 
end

% Plot mean across flies 
for stim = 1:numStim
    hfl(stim) = plot(mean(squeeze(avgAcrossTrials(:,stim,:,1)),1)',mean(squeeze(avgAcrossTrials(:,stim,:,2)),1)','Color',colors(stim,:),'Linewidth',3);
    hold on 
end

% Plot settings
bottomAxisSettings;
xlabel('X Displacement (mm)')
ylabel('Y Displacement (mm)')
symAxisY(gca);
xlim([-3 3])
legend(hfl,plotData.legendText,'Location','southeast')
legend('boxoff')
title(prefixCode)
yTxtPos = min(ylim)+10;
text(-2.8,yTxtPos,['n = ',num2str(numFlies)])
set(findall(gcf,'-property','FontSize'),'FontSize',18)
set(findall(gcf,'-property','FontName'),'FontName','Calibri Light')

end