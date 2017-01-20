function [h,numSubPlot] = plotStimulus(exptInfo,GroupStim,GroupData,titleText,StimStruct,n,numExtraPlots)

%% For tight subplots
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.05], [0.1 0.15], [0.1 0.01]);

%%
purple = [97 69 168]./255;
gray = [192 192 192]./255;

% Determine if stimulus is piezo, speaker or neither
if ~isfield(exptInfo,'stimType')
    exptInfo.stimType = 'n';
end
% Plot stimulus appropriately
if strcmpi(exptInfo.stimType,'p')
    numStimPlots = 1;
    numSubPlot = numStimPlots+numExtraPlots;
    h(1) = subplot(numSubPlot,1,2);
    hold on
    plot(GroupStim(n).stimTime,GroupData(n).piezoCommand,'Color',gray)
    plot(GroupData(n).sampTime,GroupData(n).piezoSG,'Color',purple)
    if size(GroupData(n).piezoSG,1)>1
        plot(GroupData(n).sampTime,mean(GroupData(n).piezoSG),'k')
    end
    ylabel('Voltage (V)')
    noXAxisSettings
    t = title(h(1),titleText);
    set(t,'Fontsize',20);
elseif strcmpi(exptInfo.stimType,'s')
    numStimPlots = 1;
    numSubPlot = numStimPlots+numExtraPlots;
    h(1) = subplot(numSubPlot,1,1);
    if regexp(GroupData(n).description,'chirp')>=1
        plotChirp(StimStruct(n).stimObj)
    else
        plot(GroupData(n).sampTime,GroupData(n).speakerCommand,'Color',purple)
        ylabel('Voltage (V)')
    end
    hold on
    noXAxisSettings
    t = title(h(1),titleText);
    set(t,'Fontsize',20);
elseif strcmpi(exptInfo.stimType,'b')
    numStimPlots = 2;
    numSubPlot = numStimPlots+numExtraPlots;
    h(1) = subplot(numSubPlot,1,1);
    if regexp(GroupData(n).description,'chirp')>=1
        plotChirp(StimStruct(n).stimObj)
    else
        plot(GroupData(n).sampTime,GroupData(n).speakerCommand,'Color',purple)
        ylabel('Voltage (V)')
    end
    hold on
    noXAxisSettings
    t = title(h(1),titleText);
    set(t,'Fontsize',20);
    
    h(2) = subplot(numSubPlot,1,2);
    hold on
    plot(GroupStim(n).stimTime,GroupData(n).piezoCommand,'Color',gray)
    plot(GroupData(n).sampTime,GroupData(n).piezoSG,'Color',purple)
    if size(GroupData(n).piezoSG,1)>1
        plot(GroupData(n).sampTime,mean(GroupData(n).piezoSG),'k')
    end
    ylabel('Voltage (V)')
    noXAxisSettings
elseif strcmpi(exptInfo.stimType,'n')
    h = [];
    numSubPlot = numExtraPlots;
end

end