function noAxisSettings(color,varargin)

if exist('color','var')
    if strcmp(color,'w')
        set(gca,'YColor','white')
        set(gca,'XColor','white')
    end
end

set(gca,'Box','off','TickDir','out','YTickLabel','','ytick',[],'XTickLabel','','xtick',[])
axis tight
set(get(gca,'XLabel'),'Rotation',0,'HorizontalAlignment','right')
set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')

end