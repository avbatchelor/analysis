function symAxisX(axisHandle)

axis(axisHandle,'tight')
xlimits = xlim; 
xMax = max(abs(xlimits)); 
xlim([-xMax,xMax])