function plotAngleHist(beforeDisp,afterDisp,currColor,numUniqueStim,stimCount)

%% Figure settings 
figure(2);
set(0,'DefaultFigureWindowStyle','normal')
setCurrentFigurePosition(1);

%% Calculate angles
beforeStraightVector = [0 -1];
afterStraightVector = [0 1];

for j = 1:length(beforeDisp)
    beforeComparisonVector = beforeDisp(j,:);
    beforeAngle(j) =  -(180/pi) * (atan2(det([beforeStraightVector',beforeComparisonVector']),dot(beforeStraightVector,beforeComparisonVector)));
    afterComparisonVector = afterDisp(j,:);
    afterAngle(j) = -(180/pi) * (atan2(det([afterStraightVector',afterComparisonVector']),dot(afterStraightVector,afterComparisonVector)));
end

%% Histogram settings
gray = [192 192 192]./255;
bins = -180:5:180;
numRows = numUniqueStim;
numCols = 2;
spIndex = reshape(1:numCols*numRows, numCols, numRows).';


%% Plot before angle 
% sph(stimCount) = subtightplot (numRows, numCols, spIndex(stimCount),[0.1 0.05], [0.1 0.01], [0.1 0.01]);
sph(stimCount) = subplot(numRows, numCols, spIndex(stimCount));
h1 = histogram(beforeAngle,bins,'FaceColor',gray);
line([0,0],[0,max(h1.Values)],'Color','k','Linewidth',3)
xlim([-50 50])
xlabel('Angle')
ylabel('Counts')
% if stimCount == numRows || stimCount == numUniqueStim
    bottomAxisSettings;
% else
%     noXAxisSettings;
% end
title(['Before Angle, Median = ',num2str(median(beforeAngle))])
 
%% Plot after angle 
% sph(stimCount) = subtightplot (numRows, numCols, spIndex(numRows+stimCount),[0.1 0.05], [0.1 0.01], [0.1 0.01]);
sph(stimCount) = subplot (numRows, numCols, spIndex(numRows+stimCount));
h2 = histogram(afterAngle,bins,'FaceColor',currColor);
line([0,0],[0,max(h2.Values)],'Color','k','Linewidth',3)
xlim([-50 50])
xlabel('Angle')
ylabel('Counts')
% if stimCount == numRows || stimCount == numUniqueStim
    bottomAxisSettings;
% else
%     noXAxisSettings;
% end
title(['After Angle, Median = ',num2str(median(afterAngle))])



