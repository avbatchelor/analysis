set(0,'DefaultAxesFontSize', 12)
set(0,'DefaultFigureColor','w')
set(0,'DefaultAxesBox','off')
close all

load('C:\Dropbox\PhD\Year2 and onward\DataTemp\groomingWindExampleVariables.mat')

% frameRate = 71.7; 
% int = 1/frameRate; 
% time = (int.*(1:length(behaviour_bin2)))./60;

wind = wind==1; 
behaviour = behaviour == 1;
figure
newTime = 2.300e-04.*(1:length(Time));
b1 = bar(newTime,wind,1,'b');
b1.FaceAlpha = 0.2;
hold on 
b2 = bar(newTime,behaviour,1,'r');
%b2.FaceAlpha = 1;
legend('Wind stimulus','Antennal reaching','Location','northoutside')
legend('boxoff')
xlabel('Time (minutes)')
set(gca,'Box','off','TickDir','out','YTick',[],'YColor','white')
axis tight
xlim([0 6])
spaceplots([0 0 0.15 0])
%mySave('C:\Dropbox\PhD\Year2 and onward\DataTemp\windEvokedGrooming.pdf',[5,1])

