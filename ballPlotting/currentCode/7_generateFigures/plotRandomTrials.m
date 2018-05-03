function plotRandomTrials(prefixCode,expNum,flyNum,flyExpNum)

close all

%% Plot settings
numSamples = 5;

%% Colors 
black = [0,0,0];
green = [91,209,82]./255;
purple = [178,102,255]./255;
orange = [255,178,102]./255;
colorSet = [green;black;purple;black;orange;black];

%% Put exptInfo in a struct
exptInfo = exptInfoStruct(prefixCode,expNum,flyNum,flyExpNum);

%% Load plot data
% Get paths
[~, ~, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
pPath = getProcessedDataFileName(exptInfo);

% Plot data
fileName = [pPath,fileNamePreamble,'plotData.mat'];
load(fileName);

%% Subplot settings
numCols = plotData.numUniqueStim*2;
numRows = numSamples;
spIndex = reshape(1:numCols*numRows, numCols, numRows).';

%%

% Select 5 random left trials

% Plot the forward and lateral velocity
goFigure;

plotCount = 0;
colCount = 0;
% Loop through stimuli
for i = 1:plotData.numUniqueStim
    % Stimulus angle
    angleStr = char(regexp(plotData.legendText{i},'Angle = \d+','match'));
    
    
    
    % Plot lateral and forward velocity
    for k = 1:2
        colCount = colCount + 1;
        
        % Loop through samples
        for j = 1:numSamples
            
            plotCount = plotCount + 1;
            subplot(numRows,numCols,spIndex(plotCount))
            hold on
            shadestimArea(plotData,i,-50,50);
            
            plot([plotData.dsTime(1,1),plotData.dsTime(1,end)],[0,0],'k','Linewidth',1.5)
            
            if k == 1
                plot(plotData.dsTime(1,:),plotData.sampleTrialsXVel{i}(j,:),'Color',colorSet(colCount,:),'Linewidth',1.5)
                if j == 1
                    title({angleStr;'Lateral velocity'})
                end
                if i == 1
                    ylabel(['Sample trial ',num2str(j)])
                end
            else
                plot(plotData.dsTime(1,:),plotData.sampleTrialsYVel{i}(j,:),'k','Linewidth',1.5)
                if j == 1
                    title({angleStr;'Forward velocity'})
                end
            end
            
            % Axis labels
            if j == numSamples
                xlabel('Time (s)')
                bottomAxisSettings
            else 
                noXAxisSettings('w')
            end
            
            ylim([-50 50])

            set(gca,'Layer','top')
            
        end
    end
end

set(findall(gcf,'-property','FontSize'),'FontSize',16)

folder = 'D:\ManuscriptData\summaryFigures\';
[~, ~, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
filename = [folder,fileNamePreamble,'random_trials.pdf'];
export_fig(filename,'-pdf','-painters')

end