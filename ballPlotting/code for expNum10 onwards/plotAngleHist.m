function plotAngleHist(beforeDisp,afterDisp,currColor,numRows,numCols,stimCount)

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
spIndex = reshape(1:numCols*numRows, numCols, numRows).';


%% Calculate and plot histograms
if stimCount == 1
    sph(10) = subtightplot (numRows, numCols, spIndex(15),[0.1 0.05], [0.1 0.01], [0.1 0.01]);
elseif stimCount == 2
    sph(11) = subtightplot (numRows, numCols, spIndex(16),[0.1 0.05], [0.1 0.01], [0.1 0.01]);
elseif stimCount == 3
    sph(12) = subtightplot (numRows, numCols, spIndex(17),[0.1 0.05], [0.1 0.01], [0.1 0.01]);
end
h1 = histogram(beforeAngle,bins,'FaceColor',gray);
line([0,0],[0,max(h1.Values)],'Color','k')
xlim([-50 50])
noXAxisSettings;
title(['Before Angle, Median = ',num2str(median(beforeAngle))])
 
if stimCount == 1
    sph(13) = subtightplot (numRows, numCols, spIndex(18),[0.1 0.05], [0.1 0.01], [0.1 0.01]);
elseif stimCount == 2
    sph(14) = subtightplot (numRows, numCols, spIndex(19),[0.1 0.05], [0.1 0.01], [0.1 0.01]);
elseif stimCount == 3
    sph(15) = subtightplot (numRows, numCols, spIndex(20),[0.1 0.05], [0.1 0.01], [0.1 0.01]);
    bottomAxisSettings;
end
h2 = histogram(afterAngle,bins,'FaceColor',currColor);
line([0,0],[0,max(h2.Values)],'Color','k')
xlim([-50 50])
xlabel('Angle')
ylabel('Counts')
if stimCount == 1
    noXAxisSettings;
else 
    bottomAxisSettings;
end
title(['After Angle, Median = ',num2str(median(afterAngle))])



