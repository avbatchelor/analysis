
%% Process data
load('C:\Users\Alex\Dropbox\PhD\Year2 and onward\DataTemp\groomingWindExampleVariables')
windStarts = findstr(wind',[0,1]); 
windEnds = findstr(wind',[1,0]);
windDur = median(windEnds-windStarts);

frameIntTime=median(diff(Time));

minNumIntFrames = min(diff(windStarts));
numFramesAfter = floor(minNumIntFrames*0.75);
numFramesBefore = floor(minNumIntFrames*0.25); 

startFrames = windStarts-numFramesBefore; 
endFrames = windStarts+numFramesAfter; 

numTrials = length(windStarts);
for i = 1:numTrials
    rasterMatrix(i,:) = behaviour(startFrames(i):endFrames(i));
end

windTimeCourse = zeros(1,size(rasterMatrix,2));
windTimeCourse(numFramesBefore:numFramesBefore+windDur) = 1;

%% Figure formatting 
set(0,'DefaultAxesFontSize', 12)
set(0,'DefaultFigureColor','w')
set(0,'DefaultAxesBox','off')
load('MyColors')
close all

%% Make figure
figure
subplot(4,1,1)
plot(windTimeCourse,'Color',gray,'Linewidth',2)
set(gca,'XColor','w','YColor','w')
subplot(4,1,2:4)
imagesc(rasterMatrix)
load('MyColorMaps')
set(gcf,'Colormap',magToWhiteCmap)
ylabel('Trial number')
xlabel('Time (s)')
set(gca,'Box','off','TickDir','out')
currXlabels = get(gca,'XTickLabel');
currXlabels = str2num(currXlabels);

xlabelTimes = [0 5 10 15 20];
xlabelStrs = num2str(xlabelTimes');
labelFrameNums = round(xlabelTimes./frameIntTime);
set(gca,'XTick',labelFrameNums,'XTickLabel',xlabelStrs)

spaceplots

%% Save figure 
mySave('C:\Users\Alex\Documents\Data\flyGroomingVideos\RO1data\windEvokedGroomingRaster.pdf',[5,1])


%% Check timing     
figure
plot(wind)
hold on 
plot(windStarts,1,'ro')
plot(startFrames,1,'go')
plot(endFrames,1,'ko')
plot(windEnds,1,'mo')