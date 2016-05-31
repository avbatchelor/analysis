close all 
clear all

set(0,'DefaultAxesFontSize', 40)
set(0,'DefaultFigureColor','w')
set(0,'DefaultAxesBox','off')

figure
setCurrentFigurePosition(2)
gb = [119 135 140]./255;
rd = [217 26 26]./255;
load('C:\Users\Alex\Documents\Data\ephysData\18C11\expNum001\flyNum009\cellNum002\cellExpNum002\18C11_expNum001_flyNum009_cellNum002_cellExpNum002_trial004.mat')
timestep = 1/1e4;
time = timestep:timestep:Stim.totalDur;
plot(time,data.voltage,'Color',gb,'Linewidth',1.4)
xlabel('Time (s)')
ylabel('Voltage (mV)')
hold on 
plot([5.9 24],[-50 -50],'Color',rd,'Linewidth',6)
axis tight
ylim([-52 -29])
set(gca,'Box','off','TickDir','out')
spaceplots
    
mySave('C:\Users\Alex\Documents\Data\flyGroomingVideos\RO1data\18C11_fly9_example.pdf',[5,1])
