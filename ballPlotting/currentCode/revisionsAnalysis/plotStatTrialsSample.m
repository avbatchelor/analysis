function plotStatTrialsSample(prefixCode,expNum,flyNum,flyExpNum)

close all

%% Plot settings
numSamples = 10;

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
numCols = 10;
numRows = 4;
spIndex = reshape(1:numCols*numRows, numCols, numRows).';
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.1 0.075], [0.1 0.01]);


%%

% Select 5 random left trials
numSamples = max([size(plotData.statTrialsX{1},1),...
    size(plotData.statTrialsX{2},1)]);
numFigures = ceil(numSamples/10);

for figNum = 1:numFigures
    % Plot the forward and lateral velocity
    goFigure;

    plotCount = 0;
    colCount = 0;
    % Loop through stimuli
    % Only plot the first two stimuli and not the noStimulus 
    for stimNum = 1:2%plotData.numUniqueStim
        % Stimulus angle
        angleStr = char(regexp(plotData.legendText{stimNum},'Angle = \d+','match'));

        samplesPerStim = size(plotData.statTrialsX{stimNum},1);

        % Plot lateral and forward velocity
        for dim = 1:2
            colCount = colCount + 1;

            if stimNum == 1 && dim == 2
                plotCount = 10;
            elseif stimNum == 2 && dim == 1
                plotCount = 20; 
            elseif stimNum == 2 && dim == 2
                plotCount = 30;
            end
                

            % Loop through samples
            for sampleNum = ((figNum-1)*10)+1 : min([samplesPerStim,((figNum-1)*10)+10])

                %% Plot data 
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
                    plot(plotData.dsTime(1,:),plotData.statTrialsX{stimNum}(sampleNum,:),'Color',colorSet(colCount,:),'Linewidth',1.5)                
                    hold on 
                    plot(plotData.dsTime(1,:),mean(plotData.statTrialsX{stimNum}),'Color',colorSet(colCount,:),'Linewidth',0.5)
                    if sampleNum == 1
                        ylabel({'Lateral';'velocity';'(mm/s)'},'HorizontalAlignment','center')
                    end
                else
                    plot(plotData.dsTime(1,:),plotData.statTrialsY{stimNum}(sampleNum,:),'k','Linewidth',1.5)
                    hold on 
                    plot(plotData.dsTime(1,:),mean(plotData.statTrialsY{stimNum}),'Color',colorSet(colCount,:),'Linewidth',0.5)
                    if sampleNum == 1
                        ylabel({'Forward';'velocity';'(mm/s)'},'HorizontalAlignment','center')
                    end
                end

                %% Check speed thresholding 
%                 checkAvgSpeed(exptInfo,plotData.sampleTrialsXVel{stimNum}(sampleNum,:),plotData.sampleTrialsYVel{stimNum}(sampleNum,:))

                %% Plot formatting 
                if stimNum == 1 && dim == 1
                        title(['Trial ',num2str(sampleNum)])
                end


                if sampleNum == 1             
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

                xlim([1.5 3])
                set(gca,'xTick',[0,2,4])
                set(gca,'Layer','top')

            end
        end
    end

    suplabel('Time (s)','x')
    % suplabel('Speed (mm/s)','y')
    set(findall(gcf,'-property','FontSize'),'FontSize',16)

    %% Save figure 
    statusStr = checkRepoStatus;
    folder = 'D:\ManuscriptData\summaryFigures\';
    [~, ~, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
    filename = [folder,fileNamePreamble,'random_trials_supp',statusStr,'_figNum',num2str(figNum),'.pdf'];
    export_fig(filename,'-pdf','-painters')

end

end