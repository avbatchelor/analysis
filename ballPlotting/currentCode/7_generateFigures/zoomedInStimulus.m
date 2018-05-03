function zoomedInStimulus

%% Get single fly data 
[~,plotDataSingleFly] = getExampleFlies('ShamGlued-45');

figure
stimMax = max(abs(plotDataSingleFly.stimulus(1,:)));
plot(plotDataSingleFly.stimTimeVector(1,:),plotDataSingleFly.stimulus(1,:)./stimMax,'k')
ylim([-1,1])
set(gca,'XColor','white','YColor','white')
ipi = 0.0340;
xlim([2-0.25*ipi 2+1.75*ipi])

%% Add scalebar
scalebar('XUnit','s','YLen',0)

%% Save figure
folder = 'D:\ManuscriptData\summaryFigures\';
filename = [folder,'zommedInStimulus.pdf'];
export_fig(filename,'-pdf','-painters')

