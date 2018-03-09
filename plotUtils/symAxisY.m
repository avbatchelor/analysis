function symAxisY(axisHandle)

axis(axisHandle,'tight')
ylimits = ylim; 
yMax = max(abs(ylimits)); 
ylim([-yMax,yMax])