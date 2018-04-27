function plotLineHist(plotData,currColor,stimNum)

%% Subplot settings
numRows = ceil(plotData.numUniqueStim/2);
numCols = 2;
spIndex = reshape(1:numCols*numRows, numCols, numRows).';

goFigure (60)
subtightplot(numRows, numCols, spIndex(stimNum),[0.075 0.1], [0.1 0.1], [0.1 0.01]);

% Plot
plot(plotData.xDispLinePlot{stimNum}',plotData.yDispLinePlot{stimNum}','Color',currColor)

% Axis labels
ylabel({'Y disp';'(mm)'})
xlabel('X disp (mm)')
title(plotData.legendText{stimNum})

% Axis settings
bottomAxisSettings
xlim([-3 3]);

%% Title
suptitle(plotData.sumTitle)

%% Save figure 
histFileName = strrep(plotData.saveFileName{1},'fig1_stim001.pdf','fig3_line_hist.pdf');
figurePath = fileparts(plotData.saveFileName{1});
mkdir(figurePath);
if stimNum == plotData.numUniqueStim
    export_fig(histFileName,'-pdf','-painters')
end