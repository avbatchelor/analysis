function mySimplePlot(varargin)

plot(varargin{:});
box off;
set(gca,'TickDir','out')
axis tight
hold on 

end