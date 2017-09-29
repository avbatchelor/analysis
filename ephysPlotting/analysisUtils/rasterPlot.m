function rasterPlot(spikeIdxs,time)

for i = 1:length(spikeIdxs) 
    spikes = time(spikeIdxs{i});
    plot([spikes;spikes],[i-0.1.*ones(size(spikes));(i-0.9).*ones(size(spikes))],'k-')
    hold on 
    clear spikes 
end

set(gca,'YColor',get(gcf,'Color')) % hide the y axis
set(gca,'Box','off')