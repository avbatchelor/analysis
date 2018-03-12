function plotAngleHist(beforeDisp,afterDisp,currColor,plotData,stimCount)

%% Figure settings
goFigure(30);

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
numRows = plotData.numUniqueStim;
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

%% Title
suptitle(plotData.sumTitle)

%% Save figure 
histFileName = strrep(plotData.saveFileName{1},'fig1_stim001.pdf','fig2_hist.pdf');
figurePath = fileparts(plotData.saveFileName{1});
mkdir(figurePath);
if stimCount == plotData.numUniqueStim
    export_fig(histFileName,'-pdf','-painters')
end
