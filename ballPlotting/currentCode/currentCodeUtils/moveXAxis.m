function moveXAxis%(groupedData,stimNum)
% set(gca,'XColor','white')
% hold on
% line([groupedData.dsTime{stimNum}(1),groupedData.dsTime{stimNum}(end)],[0,0],'Color','k')

ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';

end