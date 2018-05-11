function scalebar(xStart,xEnd,yStart,yEnd,xText,yText)

plot([xStart xEnd],[yStart yStart],'k','Linewidth',1)
plot([xStart xStart],[yStart yEnd],'k','Linewidth',1)

xLength = xEnd - xStart;
yLength = yEnd - yStart;

xDelta = xLength/10;
yDelta = yLength/10;

xMid = xStart + (xEnd - xStart)/2;
yMid = yStart + (yEnd - yStart)/2;

text(xMid,yStart-yDelta,xText,'HorizontalAlignment','center','VerticalAlignment','cap')
text(xStart-xDelta,yMid,yText,'HorizontalAlignment','right','VerticalAlignment','middle')