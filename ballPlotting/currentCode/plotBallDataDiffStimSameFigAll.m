function plotBallDataDiffStimSameFigAll(prefixCode,expNum,flyNum,flyExpNum,allTrials,sameFig)


%% Load group filename
exptInfo.prefixCode     = prefixCode;
exptInfo.expNum         = expNum;
exptInfo.flyNum         = flyNum;
exptInfo.flyExpNum      = flyExpNum;

%% Load data 
% Get paths 
[~, path, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
pPath = getProcessedDataFileName(exptInfo);

% Grouped data 
fileName = [pPath,fileNamePreamble,'groupedData.mat'];
load(fileName);

% Expt data 
fileName = [path,fileNamePreamble,'exptData.mat'];
load(fileName);

% First trial
firstTrialFileName = [path,fileNamePreamble,'trial',num2str(1,'%03d'),'.mat'];
load(firstTrialFileName);

% Fly data 
flyDataPath = char(regexp(path,'.*(?=flyExpNum)','match'));
flyDataPreamble = char(regexp(fileNamePreamble,'.*(?=flyExpNum)','match'));
flyDataFileName = [flyDataPath,flyDataPreamble,'flyData'];
load(flyDataFileName);

%% Create save folder 
fileStem = char(regexp(pPath,'.*(?=flyExpNum)','match'));
saveFolder = [fileStem,'Figures\'];
mkdir(saveFolder)

%% Assign empty matrices 
fvTemp = [];
lvTemp = [];

%% Figure prep
close all

% Set colors
uniqueStim = unique(groupedData.stimNum);

gray = [192 192 192]./255;

% Subplot settings 
numCols = 3;
numRows = 5;
spIndex = reshape(1:numCols*numRows, numCols, numRows).';

%% Data for title
dateNumber = datenum(exptInfo.dNum,'yymmdd');
dateAsString = datestr(dateNumber,'mm-dd-yy');

if ~isfield(FlyData,'aim')
    FlyData.aim = '';
end
if ~isfield(exptInfo,'flyExpNotes')
    exptInfo.flyExpNotes = '';
end


%% Hardcoded paramters
dsFactor = 400;
timeBefore = 0.3;
pipStartInd = Stim.startPadDur*Stim.sampleRate/dsFactor + 1;
indBefore = pipStartInd - timeBefore*Stim.sampleRate/dsFactor;
indAfter = pipStartInd + timeBefore*Stim.sampleRate/dsFactor;

%% Select trials based on speed 
trialsToInclude = 3<groupedData.trialSpeed & groupedData.trialSpeed<30;

%% Rotate all trials
refVect = [0; -1];
if sum(trialsToInclude) == 0
    return
end
trialNums = 1:length(groupedData.stimNum);
allFastTrials = trialNums(trialsToInclude);
xDispAFT = [groupedData.startChunk.xDisp{allFastTrials}];
yDispAFT = [groupedData.startChunk.yDisp{allFastTrials}];
trialVect = [mean(xDispAFT(1,:));mean(yDispAFT(1,:))];
rotAng = acos(dot(trialVect,refVect)/(norm(trialVect)*norm(refVect)));
if trialVect(1) > 0
    R = [cos(rotAng) sin(rotAng);-sin(rotAng) cos(rotAng)];
elseif trialVect(1) <= 0
    R = [cos(rotAng) -sin(rotAng);sin(rotAng) cos(rotAng)];
end


%% Find out number of stim types
stimType = sameStim(StimStruct);
uniqueStimTypes = unique(stimType);
if strcmp(sameFig,'y')
   uniqueStimTypes = 1; 
end

for k = uniqueStimTypes
    
    figure(1)
    set(0,'DefaultFigureWindowStyle','normal')
    setCurrentFigurePosition(1);
    subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.05], [0.1 0.01], [0.1 0.01]);
    set(0,'DefaultFigureColor','w')
    
    stimTypeInd = find(stimType == k);
    
    sumTitle = {[dateAsString,', ',exptInfo.prefixCode,', ExpNum ',num2str(exptInfo.expNum),', FlyNum ',num2str(exptInfo.flyNum),...
    ', FlyExpNum ',num2str(exptInfo.flyExpNum)];['Aim: ',char(FlyData.aim),', Description: ',StimStruct(stimTypeInd(1)).stimObj.description]};
    
    legendText = {};
    
    stimCount = 0; 
    
    if strcmp(sameFig,'y')
       	stimTypeInd = uniqueStim; 
    end
    
    %% Plot for each stim Num
    for i = stimTypeInd
        
        colorSet = distinguishable_colors(length(stimTypeInd)/2,'w');
        colorSet = [colorSet;colorSet];

        stimCount = stimCount + 1; 
        currColor = colorSet(stimCount,:);
        
        %% Select the trials for this stimulus
        trialsToIncludeNums = trialNums(trialsToInclude);
        stimNumIndNotSelected = find(groupedData.stimNum == uniqueStim(i));
        stimNumInd = intersect(trialsToIncludeNums,stimNumIndNotSelected);
        pipEndInd = Stim.totalDur - Stim.endPadDur;
        
        randInd = randperm(length(stimNumInd));
        stimIndSamp = randInd(1:10);
        
        if isfield(StimStruct(i).stimObj,'speakerAngle')
            legendText{end+1} = ['Angle = ',num2str(StimStruct(i).stimObj.speakerAngle),...
                ' Envelope = ',num2str(StimStruct(i).stimObj.envelope),...
                ', ',num2str(StimStruct(i).stimObj.description)];
        else 
            legendText{end+1} = '';
        end
        
%         checkRotation(groupedData,R,stimNumInd)
%         pause 
%         
        %% Rotate each of these trials
        count = 0;
        for j = stimNumInd
            count = count+1;
            rotVel(count,:,:) = R*[groupedData.xVel{j}';groupedData.yVel{j}'];
            rotDisp(count,:,:) = R*[groupedData.xDisp{j}';groupedData.yDisp{j}'];
        end
        
        if isempty(stimNumInd)
            disp('no trials fast enough for this stim')
            continue
        end
        
        rotXDisp = squeeze(rotDisp(:,1,:));
        rotYDisp = squeeze(rotDisp(:,2,:));
        rotXVel = squeeze(rotVel(:,1,:));
        rotYVel = squeeze(rotVel(:,2,:));
        
        if length(stimNumInd) == 1
            rotXDisp = rotXDisp';
            rotYDisp = rotYDisp';
            rotXVel = rotXVel';
            rotYVel = rotYVel';
        end
        
        %% Find the mean and std of these trials
        meanXDisp = mean(rotXDisp);
        meanYDisp = mean(rotYDisp);
        meanXVel = mean(rotXVel);
        meanYVel = mean(rotYVel);
        stdXDisp = std(rotXDisp);
        stdYDisp = std(rotYDisp);
        stdXVel = std(rotXVel);
        stdYVel = std(rotYVel);
        
        %% Get LED data
        if isfield('groupedData','led')
            LEDStim = groupedData.led{i};
        end
        
        %% Plot stimulus
        figure(1)
        sph(1) = subtightplot (numRows, numCols, spIndex(1), [0.01 0.05], [0.1 0.01], [0.1 0.01]);
        mySimplePlot(groupedData.stimTimeVect{i},groupedData.stim{i})
        set(gca,'XTick',[])
        ylabel({'Stim';'(V)'})
        set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')
        set(gca,'XColor','white')
        
        %% Plot data
        sph(2) = subplot(numRows, numCols, spIndex(2));
        hold on
        mySimplePlot(groupedData.dsTime{i},meanXVel,'Color',currColor,'Linewidth',2)
        if strcmp(allTrials,'y')
            mySimplePlot(groupedData.dsTime{i},rotXVel(stimIndSamp,:),'Color',currColor,'Linewidth',0.5)
        end
        %     mySimplePlot(groupedData.dsTime,meanXVel+stdXVel,'Color',colorSet(i,:),'Linewidth',0.5)
        %     mySimplePlot(groupedData.dsTime,meanXVel-stdXVel,'Color',colorSet(i,:),'Linewidth',0.5)
        set(gca,'XTick',[])
        ylabel({'Lateral Speed';'(mm/s)'})
        set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')
        moveXAxis(groupedData,i)
        shadestimArea(groupedData,i)
        if exist('LEDStim','var')
            shadeLEDArea(LEDStim,Stim)
        end
        symAxisY
        
        sph(3) = subplot(numRows, numCols, spIndex(3));
        hold on
        mySimplePlot(groupedData.dsTime{i},meanYVel,'Color',currColor,'Linewidth',2)
        if strcmp(allTrials,'y')
            mySimplePlot(groupedData.dsTime{i},rotYVel(stimIndSamp,:),'Color',currColor,'Linewidth',0.5)
        end
        %     mySimplePlot(groupedData.dsTime,meanYVel+stdYVel,'Color',colorSet(i,:),'Linewidth',0.5)
        %     mySimplePlot(groupedData.dsTime,meanYVel-stdYVel,'Color',colorSet(i,:),'Linewidth',0.5)
        set(gca,'XTick',[])
        ylabel({'Forward Speed';'(mm/s)'})
        set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')
        shadestimArea(groupedData,i)
        if exist('LEDStim','var')
            shadeLEDArea(LEDStim,Stim)
        end
        moveXAxis(groupedData,i)
        symAxisY
        
        sph(4) = subplot(numRows, numCols, spIndex(4));
        hold on
        mySimplePlot(groupedData.dsTime{i},meanXDisp,'Color',currColor,'Linewidth',2)
        if strcmp(allTrials,'y')
            mySimplePlot(groupedData.dsTime{i},rotXDisp(stimIndSamp,:),'Color',currColor,'Linewidth',0.5)
        end
        %     mySimplePlot(groupedData.dsTime,meanXDisp+stdXDisp,'Color',colorSet(i,:),'Linewidth',0.5)
        %     mySimplePlot(groupedData.dsTime,meanXDisp-stdXDisp,'Color',colorSet(i,:),'Linewidth',0.5)
        %
        %     shadedErrorBar(groupedData.dsTime,mean(groupedData.xDisp(stimNumInd,:)),std(groupedData.xDisp(stimNumInd,:)))
        set(gca,'XTick',[])
        ylabel({'X Disp';'(mm)'})
        set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')
        shadestimArea(groupedData,i)
        if exist('LEDStim','var')
            shadeLEDArea(LEDStim,Stim)
        end
        moveXAxis(groupedData,i)
        symAxisY
        
        sph(5) = subplot(numRows, numCols, spIndex(5));
        hold on
        mySimplePlot(groupedData.dsTime{i},meanYDisp,'Color',currColor,'Linewidth',2)
        if strcmp(allTrials,'y')
            mySimplePlot(groupedData.dsTime{i},rotYDisp(stimIndSamp,:),'Color',currColor,'Linewidth',0.5)
        end
        %     mySimplePlot(groupedData.dsTime,meanYDisp+stdYDisp,'Color',colorSet(i,:),'Linewidth',0.5)
        %     mySimplePlot(groupedData.dsTime,meanYDisp-stdYDisp,'Color',colorSet(i,:),'Linewidth',0.5)
        ylabel({'Y Disp';'(mm)'})
        set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')
        hold on
        line([groupedData.dsTime{i}(1),groupedData.dsTime{i}(end)],[0,0],'Color','k')
        shadestimArea(groupedData,i)
        if exist('LEDStim','var')
            shadeLEDArea(LEDStim,Stim)
        end
        xlabel('Time (s)')
        linkaxes(sph(1:5),'x')
        symAxisY
        
        sph(9) = subtightplot (numRows, numCols, spIndex(6:10),[0.01 0.05], [0.1 0.01], [0.1 0.01]);
        hold on
        plot(meanXDisp,meanYDisp,'Color',currColor,'Linewidth',2)
        if strcmp(allTrials,'y')
            plot(rotXDisp(stimIndSamp,:)',rotYDisp(stimIndSamp,:)','Color',currColor,'Linewidth',0.5)
        end
        %     xEndSubtracted = rotXDisp - rotXDisp(pipEndInd);
        %     yEndSubtracted = rotYDisp - rotYDisp(pipEndInd);
        %     plot(mean(xEndSubtracted),mean(yEndSubtracted),'Color',colorSet(i,:))
        
        %     plot(meanXDisp+stdXDisp,meanYDisp,'Color',colorSet(i,:),'Linewidth',0.5)
        %     plot(meanXDisp-stdXDisp,meanYDisp,'Color',colorSet(i,:),'Linewidth',0.5) 
        xlim([-3.5 3.5])
        xlabel('X displacement (mm)')
        ylabel('Y displacement (mm)')
        
        
        clear rotVel rotDisp
        
        

        

        
    end
    
    legend(sph(9),legendText,'Location','eastoutside')
    legend('boxoff')
    
    suptitle(sumTitle)
%     saveFileName = [saveFolder,'flyExpNum',num2str(exptInfo.flyExpNum,'%03d'),'_stim',num2str(i-1,'%03d'),'_to_',num2str(i,'%03d'),'.pdf'];
%     mySave(saveFileName,[5 5]);
%     close all
%     
%     groupPdfs(saveFolder)

    
end

end

function shadestimArea(groupedData,stimNum)
hold on
gray = [192 192 192]./255;
pipStarts = groupedData.stimStartPadDur{stimNum};
pipEnds = pipStarts + groupedData.stimDur{stimNum};
Y = ylim(gca);
X = [pipStarts,pipEnds];
line([X(1) X(1)],[Y(1) Y(2)],'Color',gray);
line([X(2) X(2)],[Y(1) Y(2)],'Color',gray);
colormap hsv
alpha(.1)
end

function shadeLEDArea(LEDStim,Stim)
hold on
LEDStart = strfind(LEDStim',[0,1]);
if isempty(LEDStart)
    return
end
LEDEnd = strfind(LEDStim',[1,0]);
LEDStartTime = LEDStart/Stim.sampleRate;
LEDEndTime = LEDEnd/Stim.sampleRate;
Y = ylim(gca);
X = [LEDStartTime,LEDEndTime];
line([X(1) X(1)],[Y(1) Y(2)],'Color','g','LineWidth',2);
line([X(2) X(2)],[Y(1) Y(2)],'Color','g','LineWidth',2);
% colormap hsv
% alpha(.1)
end

function moveXAxis(groupedData,stimNum)
set(gca,'XColor','white')
hold on
line([groupedData.dsTime{stimNum}(1),groupedData.dsTime{stimNum}(end)],[0,0],'Color','k')
end