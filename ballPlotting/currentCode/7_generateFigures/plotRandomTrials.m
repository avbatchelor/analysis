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
numCols = numSamples;
numRows = 4;
spIndex = reshape(1:numCols*numRows, numCols, numRows).';
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.1 0.075], [0.1 0.01]);


%%

% Select 5 random left trials

% Plot the forward and lateral velocity
goFigure;

plotCount = 0;
colCount = 0;
% Loop through stimuli
% Only plot the first two stimuli and not the noStimulus 
for stimNum = 1:2%plotData.numUniqueStim
    % Stimulus angle
    angleStr = char(regexp(plotData.legendText{stimNum},'Angle = \d+','match'));
    
    
    
    % Plot lateral and forward velocity
    for dim = 1:2
        colCount = colCount + 1;
        
        % Loop through samples
        for sampleNum = 1:numSamples
            
            plotCount = plotCount + 1;
            subplot(numRows,numCols,plotCount)
            hold on
            shadestimArea(plotData,stimNum,-50,50);
            
            plot([-10,plotData.dsTime(1,end)],[0,0],'k','Linewidth',0.5)
            
            if dim == 1
                plot(plotData.dsTime(1,:),plotData.sampleTrialsXVel{stimNum}(sampleNum,:),'Color',colorSet(colCount,:),'Linewidth',1.5)                
                if sampleNum == 1
                    ylabel({'Lateral';'velocity';'(mm/s)'},'HorizontalAlignment','center')
                end
            else
                plot(plotData.dsTime(1,:),plotData.sampleTrialsYVel{stimNum}(sampleNum,:),'k','Linewidth',1.5)
                if sampleNum == 1
                    ylabel({'Forward';'velocity';'(mm/s)'},'HorizontalAlignment','center')
                end
            end
            
            if stimNum == 1 && dim == 1
                    title(['Sample trial ',num2str(sampleNum)])
            end
            

            if sampleNum == 1 && stimNum == 2 && dim == 2               
                bottomAxisSettings
            elseif sampleNum ~= 1 && stimNum == 2 && dim == 2
                noYAxisSettings('w') 
            elseif sampleNum == 1 && stimNum == 1
                noXAxisSettings('w')
                set(gca,'XColor','w')
            elseif sampleNum == 1 && stimNum == 2 && dim == 1   
                noXAxisSettings('w')
                set(gca,'XColor','w')
            else
                noAxisSettings('w');
            end
            
            if dim == 1
                ylim([-30 30])
                set(gca,'yTick',[-15 15])
            else
                ylim([-60 60])
                set(gca,'yTick',[-25 25])
            end
            
            xlim([-0.1 4.25])
            set(gca,'xTick',[0,2,4])
            set(gca,'Layer','top')
            
        end
    end
end

suplabel('Time (s)','x')
% suplabel('Speed (mm/s)','y')
set(findall(gcf,'-property','FontSize'),'FontSize',16)

folder = 'D:\ManuscriptData\summaryFigures\';
[~, ~, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
filename = [folder,fileNamePreamble,'random_trials.pdf'];
export_fig(filename,'-pdf','-painters')

end