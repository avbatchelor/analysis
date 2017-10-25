function noXAxisSettings

set(gca,'Box','off','TickDir','out','XTickLabel','','xtick',[],'XColor','white')
axis tight
set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')

end