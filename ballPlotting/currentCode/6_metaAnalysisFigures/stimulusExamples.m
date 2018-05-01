%%
stim = SineWave;
% Stimulus parameters
stim.carrierFreqHz = 225;
% Direction
stim.speaker = 3;
stim.speakerChannel = 2;
stim.speakerAngle = 45;
plot(stim)
set(findall(gcf,'-property','FontSize'),'FontSize',30)
xlim([1.95 2.35])
title('Pure tone, 225Hz')

%%
stim = PipStimulus;
% Stimulus parameters
stim.carrierFreqHz = 225;
stim.envelope = 'cosine';
% Direction
stim.speaker = 3;
stim.speakerChannel = 2;
stim.speakerAngle = 45;
plot(stim)
set(findall(gcf,'-property','FontSize'),'FontSize',30)
xlim([1.95 2.35])
title('Pip stimulus, 225Hz')

%%
stim = SineWave;
% Stimulus parameters
stim.carrierFreqHz = 800;
% Direction
stim.speaker = 3;
stim.speakerChannel = 2;
stim.speakerAngle = 45;
plot(stim)
set(findall(gcf,'-property','FontSize'),'FontSize',30)
xlim([1.95 2.35])
title('Pure tone, 800Hz')

%%
stim = PipStimulusVolSet;
% Stimulus parameters
stim.carrierFreqHz = 225;
stim.envelope = 'cosine';
% Direction
stim.speaker = 3;
stim.speakerChannel = 2;
stim.speakerAngle = 45;
stim.maxVoltage = 1;
plot(stim)
set(findall(gcf,'-property','FontSize'),'FontSize',30)
xlim([1.95 2.35])
ylim([-1.1, 1.1])
% title('Pip stimulus, 800Hz')
export_fig('C:\Users\Alex\Dropbox\AVB & RIW Shared Behavior MS Folder\Figure panels\Figure 1\stim_example.eps','-eps','-painters')

%% 
stim = PipStimulus;
% Stimulus parameters
stim.carrierFreqHz = 225;
stim.envelope = 'cosine';
% Direction
stim.speaker = 3;
stim.speakerChannel = 2;
stim.speakerAngle = 45;
plot(stim)
set(findall(gcf,'-property','FontSize'),'FontSize',30)
xlim([1.99 2.03])
title('Pip stimulus, 800Hz')
