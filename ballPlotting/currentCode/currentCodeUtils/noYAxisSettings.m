function noYAxisSettings(color,varargin)

if exist('color','var')
    if strcmp(color,'w')
        set(gca,'YColor','white')
    end
end

set(gca,'Box','off','TickDir','out','YTickLabel','','ytick',[])
axis tight
set(get(gca,'XLabel'),'Rotation',0,'HorizontalAlignment','right')

end