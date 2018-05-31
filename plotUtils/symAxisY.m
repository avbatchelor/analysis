function symAxisY(axisHandle,varargin)

if exist('axisHandle','var')
    axis(axisHandle,'tight')
else
    axis('tight')
end
    
ylimits = ylim; 
yMax = max(abs(ylimits)); 
ylim([-yMax,yMax])