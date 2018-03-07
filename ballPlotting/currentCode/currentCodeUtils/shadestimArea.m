function shadestimArea(plotData)
hold on
gray = [192 192 192]./255;
pipStarts = plotData.pipStartTime;
pipEnds = plotData.pipEndTime;
Y = ylim(gca);
X = [pipStarts,pipEnds];
line([X(1) X(1)],[Y(1) Y(2)],'Color',gray);
line([X(2) X(2)],[Y(1) Y(2)],'Color',gray);
colormap hsv
alpha(.1)
end