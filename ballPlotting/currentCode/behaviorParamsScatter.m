function behaviorParamsScatter(plotData)

%% Figure settings

for stimNum = 1:plotData.numUniqueStim
    goFigure(40+stimNum)
    
    %% Pre stim vs. stop speed
    subplot(3,1,1)
    plot(plotData.preStimSpeed{stimNum},plotData.stopSpeed{stimNum},'ro')
    xlabel('Pre stim speed')
    ylabel('Stop speed')
    
    %% Pre stim speed vs. lateral displacement 
    subplot(3,1,2)
    plot(plotData.preStimSpeed{stimNum},plotData.latDisp{stimNum} ,'o')
    
    % Axis settings 
    xlabel('Pre stim speed')
    ylabel('Lateral displacement')
    symAxisY(gca)
    ax = gca;
    ax.XAxisLocation = 'origin';
    
    %% Stop speeed vs. lateral displacement 
    subplot(3,1,3)
    plot(plotData.stopSpeed{stimNum},plotData.latDisp{stimNum} ,'o')
    
    % Axis settings 
    xlabel('Stop speed')
    ylabel('Lateral displacement')
    symAxisY(gca)
    ax = gca;
    ax.XAxisLocation = 'origin';
    
end

