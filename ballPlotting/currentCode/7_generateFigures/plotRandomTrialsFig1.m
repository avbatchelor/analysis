function plotRandomTrialsFig1(prefixCode,expNum,flyNum,flyExpNum)

close all

%% Plot settings
numSamples = 4;

%% Colors 
black = [0,0,0];
green = [91,209,82]./255;
purple = [178,102,255]./255;
orange = [255,178,102]./255;
colorSet = [purple;black];

%% Put exptInfo in a struct
exptInfo = exptInfoStruct(prefixCode,expNum,flyNum,flyExpNum);

%% Load plot data
% Get paths
pPath = getProcessedDataFileName(exptInfo);

% Plot data
fileName = [pPath,'ShamGlued_expNum001_flyNum001_flyExpNum002_plotData_labMeeting.mat'];
load(fileName);

%% Subplot settings
numCols = numSamples;
numRows = 2;
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
for stimNum = 2%plotData.numUniqueStim
    % Stimulus angle
    angleStr = char(regexp(plotData.legendText{stimNum},'Angle = \d+','match'));
    
    
    
    % Plot lateral and forward velocity
    for dim = 1:2
        colCount = colCount + 1;
        
        % Loop through samples
        for sampleNum = 2:5
            
            plotCount = plotCount + 1;
            subplot(numRows,numCols,plotCount)
            hold on
            shadestimArea(plotData,stimNum,-100,100);
            if plotCount == 1
                xStart = 2.7; xEnd = 3.2; xText = '500 ms'; yStart = -15; yEnd = -15; yText = '';
                scalebar(xStart,xEnd,yStart,yEnd,xText,yText)
            end
            
            plot([-10,plotData.dsTime(1,end)],[0,0],'k','Linewidth',0.5)
            
            if dim == 1
                plot(plotData.dsTime(1,:),plotData.sampleTrialsXVel{stimNum}(sampleNum,:),'Color',colorSet(colCount,:),'Linewidth',1.5)                
                hold on 
                plot(plotData.dsTime(1,:),plotData.meanXVel(stimNum,:),'Color',colorSet(colCount,:),'Linewidth',0.5)
                if sampleNum == 2
                    ylabel({'lateral';'velocity';'(mm/s)'},'HorizontalAlignment','center')
                end
            else
                plot(plotData.dsTime(1,:),plotData.sampleTrialsYVel{stimNum}(sampleNum,:),'k','Linewidth',1.5)
                hold on 
                plot(plotData.dsTime(1,:),plotData.meanYVel(stimNum,:),'Color',colorSet(colCount,:),'Linewidth',0.5)
                if sampleNum == 2
                    ylabel({'forward';'velocity';'(mm/s)'},'HorizontalAlignment','center')
                end
            end
            
            if stimNum == 1 && dim == 1
                    title(['Sample trial ',num2str(sampleNum)])
            end
            

            if sampleNum == 2             
                noXAxisSettings('w')
            else
                noAxisSettings('w');
            end
            
            if dim == 1
                ylim([-33 33])
                set(gca,'yTick',[-15,0,15])
            else
                ylim([-5 60])
                set(gca,'yTick',[0,25,50])
            end
            
            xlim([-0.1 4.25])
            set(gca,'xTick',[0,2,4])
            set(gca,'Layer','top')
            
        end
    end
end

% suplabel('Speed (mm/s)','y')
set(findall(gcf,'-property','FontSize'),'FontSize',16)

%% Save figure 
statusStr = checkRepoStatus;
folder = 'D:\ManuscriptData\summaryFigures\';
[~, ~, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
filename = [folder,fileNamePreamble,'random_trials_',statusStr,'.pdf'];
export_fig(filename,'-pdf','-painters')

end