function scalebar(xStart,xEnd,yStart,yEnd,xText,yText)

hold on 

plot([xStart xEnd],[yStart yStart],'k','Linewidth',1)
plot([xStart xStart],[yStart yEnd],'k','Linewidth',1)

xLength = xEnd - xStart;
yLength = yEnd - yStart;

d = daspect;
if xLength == 0
    yDelta = yLength/10;
    xDelta = d(1)/d(2) * yDelta;
else
    xDelta = xLength/10;
    yDelta = d(2)/d(1)*xDelta;
end    

xMid = xStart + (xEnd - xStart)/2;
yMid = yStart + (yEnd - yStart)/2;

text(xMid,yStart-yDelta,xText,'HorizontalAlignment','center','VerticalAlignment','cap')
text(xStart-xDelta,yMid,yText,'HorizontalAlignment','right','VerticalAlignment','middle')