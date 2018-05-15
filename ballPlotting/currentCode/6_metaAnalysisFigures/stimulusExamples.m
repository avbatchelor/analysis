function stimulusExamples

%% Loop through stim types 
stimTypes = {'sine_225';'sine_800';'pip_225';'pip_800'};
for i = 1:length(stimTypes)
    close all
    plotStimType(stimTypes{i})
end

end

function plotStimType(stimType)

%% Get stimulus 
stim = getStim(stimType);

%% Set other parameters 
stim.speaker = 3;
stim.speakerChannel = 2;
stim.speakerAngle = 45;

%% Normalize and plot stimulus 
goFigure(1);
stimMax = max(abs(stim.stimulus));
plot(stim.timeVec,stim.stimulus./stimMax,'k')

%% Plot settings 
set(findall(gcf,'-property','FontSize'),'FontSize',30)
xlims = [2 - 0.05, 2 + stim.stimDur + 0.05];
xlim(xlims)
ylim([-1.1, 1.1])
bottomAxisSettings;
xlabel('Time (s)')
ylabel('Volume a.u','Rotation',90)

%% Save figure
saveFolder = 'D:\ManuscriptData\summaryFigures\';
statusStr = checkRepoStatus;
filename = [saveFolder,stimType,'_',statusStr,'_','.pdf'];
export_fig(filename,'-pdf','-painters')

%% Zoom in on figure 
ipi = 0.0340;
xlims = [2-0.25*ipi 2+1.75*ipi];
xmid = xlims(1) + (xlims(2)-xlims(1))/2;

if strcmp(stimType,'pip_225') || strcmp(stimType,'pip_800')     
    xlim(xlims)
%     xlim([1.99 2.03])
else
    xlims = xlims + 0.1;
    xlim(xlims)
    xmid = xlims(1) + (xlims(2)-xlims(1))/2;
end

ylim([-1.2 1.2])

% Scale bar
xStart = xmid - 0.005; xEnd = xmid + 0.005; yStart = -1.1; yEnd = -1.1; xText = '10ms'; yText = '';
scalebar(xStart,xEnd,yStart,yEnd,xText,yText)


%% Settings for inset 
set(gca,'XColor','white','YColor','white')

%% Save figure
filename = [saveFolder,stimType,'_',statusStr,'_zoomed.pdf'];
export_fig(filename,'-pdf','-painters')

end

function stim = getStim(stimType)

switch stimType
    case 'sine_225'
        % Sine 225 
        stim = SineWave;
        stim.carrierFreqHz = 225;

    case 'sine_800'
        % Sine 800 
        stim = SineWave;
        stim.carrierFreqHz = 800;

    case 'pip_225'
        % Pip 225 
        stim = PipStimulus;
        stim.carrierFreqHz = 225;
        stim.envelope = 'cosine';

    case 'pip_800'
        % Pip 800 
        stim = PipStimulus;
        stim.carrierFreqHz = 800;
        stim.envelope = 'cosine';
end

end

