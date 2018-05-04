function noXAxisSettings(color,varargin)

if exist('color','var')
    if strcmp(color,'w')
        set(gca,'XColor','white')
    end
end

set(gca,'Box','off','TickDir','out','XTickLabel','','xtick',[])
axis tight
set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')

end