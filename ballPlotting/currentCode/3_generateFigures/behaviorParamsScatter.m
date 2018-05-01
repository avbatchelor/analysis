function behaviorParamsScatter(plotData,groupedData)

% Define colors 
darkGray = [110 110 110]./255;

%% Figure settings

for stimNum = 1:plotData.numUniqueStim
    goFigure(40+stimNum)
    ymax = max(vertcat(plotData.latDisp{:}));
    
    %% Pre stim vs. stop speed
    subplot(4,2,1)
    plot(plotData.preStimSpeed{stimNum},plotData.stopSpeed{stimNum},'ro')
    xlabel('Pre stim speed','FontSize',20)
    ylabel({'Stop';'speed'},'FontSize',20)
    title(plotData.legendText{stimNum},'FontSize',30)
    bottomAxisSettings
    ylim([0,max(ylim)])
    
    %% Pre stim speed vs. lateral displacement 
    subplot(4,2,2)
    plot(plotData.preStimSpeed{stimNum},plotData.latDisp{stimNum} ,'o')
    
    % Axis settings 
    xlabel('Pre stim speed','FontSize',20)
    ylabel({'Lat';'disp'},'FontSize',20)
    bottomAxisSettings
    line(xlim,[0,0],'Color','k')
    symAxisY(gca)
    ylim([-ymax,ymax])
    
    %% Stop speed vs. lateral displacement 
    subplot(4,2,3)
    plot(plotData.stopSpeed{stimNum},plotData.latDisp{stimNum} ,'o')
    
    % Axis settings 
    xlabel('Stop speed','FontSize',20)
    ylabel({'Lat';'disp'},'FontSize',20)
    bottomAxisSettings
    line(xlim,[0,0],'Color','k')
    symAxisY(gca)
    ylim([-ymax,ymax])
    
    %% Trial speed vs. lateral displacement 
    subplot(4,2,4)
    plot(plotData.trialSpeedForScatter{stimNum},plotData.latDisp{stimNum} ,'o')
    
    % Axis settings 
    xlabel('Trial speed','FontSize',20)
    ylabel({'Lat';'disp'},'FontSize',20)
    bottomAxisSettings
    line(xlim,[0,0],'Color','k')
    symAxisY(gca)
    ylim([-ymax,ymax])
    
    %% Trial number vs. lateral displacement 
    subplot(4,2,5)
    plot(plotData.trialNumForScatter{stimNum},plotData.latDisp{stimNum} ,'o')
    
    % Axis settings 
    xlabel('Trial number','FontSize',20)
    ylabel({'Lat';'disp'},'FontSize',20)
    bottomAxisSettings
    line(xlim,[0,0],'Color','k')
    symAxisY(gca)
    ylim([-ymax,ymax])
    
    %% Lateral displacement histogram
    subplot(4,2,6)
    h = histogram(plotData.latDisp{stimNum});
    h.BinEdges = [-5.25:0.5:5.25];
    
    % Axis settings 
    xlabel('Lat disp','FontSize',20)
    ylabel({'Counts'},'FontSize',20)
    bottomAxisSettings
    line(xlim,[0,0],'Color','k')
    
    txtYPos = max(h.Values)/2;
    txt1 = {['Median disp = ',num2str(median(plotData.latDisp{stimNum}))];['Mean disp = ',num2str(mean(plotData.latDisp{stimNum}))]};
    text(3,txtYPos,txt1)
    
    %% Trial speed vs trial num plot
    subplot(4,2,7)
    hold on 
    plot(1:plotData.numTrials,plotData.trialSpeed,'.','Color',darkGray)
    bothSaturationWarnings = and(groupedData.xSaturationWarning,groupedData.ySaturationWarning);
    plot(groupedData.trialNum(logical(groupedData.xSaturationWarning)),plotData.trialSpeed(logical(groupedData.xSaturationWarning)),'b.')
    plot(groupedData.trialNum(logical(groupedData.ySaturationWarning)),plotData.trialSpeed(logical(groupedData.ySaturationWarning)),'g.')
    plot(groupedData.trialNum(bothSaturationWarnings),plotData.trialSpeed(bothSaturationWarnings),'r.')
    
    % Axis settings 
    xlabel('Lat disp','FontSize',20)
    ylabel({'Counts'},'FontSize',20)
    bottomAxisSettings    
    
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



