function shadestimArea(plotData,stimNum,ymin,ymax,varargin)
if max(plotData.stimulus(stimNum,:)) == 0
    return
end
hold on
gray = [223 223 223]./255;
pipStarts = plotData.pipStartTime;
pipEnds = plotData.pipEndTime(stimNum);

if ~exist('ymin','var')
    ylims = ylim(gca);  
    ymin = ylims(1);
    ymax = ylims(2);
end

X = [pipStarts,pipEnds];

h = area([X(1) X(2)],[ymax,ymax],ymin,'Linestyle','None');
h.FaceColor = gray;

end