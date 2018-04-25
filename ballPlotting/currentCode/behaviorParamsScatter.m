function behaviorParamsScatter(plotData)

%% Figure settings

for stimNum = 1:plotData.numUniqueStim
    goFigure(40+stimNum)
    
    %% Pre stim vs. stop speed
    subplot(3,1,1)
    plot(plotData.preStimSpeed{stimNum},plotData.stopSpeed{stimNum},'ro')
    xlabel('Pre stim speed','FontSize',20)
    ylabel({'Stop';'speed'},'FontSize',20)
    title(plotData.legendText{stimNum},'FontSize',30)
    bottomAxisSettings
    ylim([0,max(ylim)])
    
    %% Pre stim speed vs. lateral displacement 
    subplot(3,1,2)
    plot(plotData.preStimSpeed{stimNum},plotData.latDisp{stimNum} ,'o')
    
    % Axis settings 
    xlabel('Pre stim speed','FontSize',20)
    ylabel({'Lat';'disp'},'FontSize',20)
    bottomAxisSettings
    line(xlim,[0,0],'Color','k')
    symAxisY(gca)
    
    %% Stop speeed vs. lateral displacement 
    subplot(3,1,3)
    plot(plotData.stopSpeed{stimNum},plotData.latDisp{stimNum} ,'o')
    
    % Axis settings 
    xlabel('Stop speed','FontSize',20)
    ylabel({'Lat';'disp'},'FontSize',20)
    bottomAxisSettings
    line(xlim,[0,0],'Color','k')
    symAxisY(gca)
    
    %% Title
    if stimNum == 1    
        suptitle(plotData.sumTitle{1})
    end

    
    %% Save figure 
    histFileName = strrep(plotData.saveFileName{1},'fig1_stim001.pdf',['fig4_scatter',num2str(stimNum,'%03d'),'.pdf']);
    figurePath = fileparts(plotData.saveFileName{1});
    mkdir(figurePath);
    export_fig(histFileName,'-pdf','-painters')

    
end



