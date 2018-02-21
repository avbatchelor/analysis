function tuningPlot(prefixCode,expNum,flyNum,flyExpNum)

%% Load group filename
dsFactor = 400;
exptInfo.prefixCode     = prefixCode;
exptInfo.expNum         = expNum;
exptInfo.flyNum         = flyNum;
exptInfo.flyExpNum      = flyExpNum;
[~, path, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
fileName = [path,fileNamePreamble,'groupedData.mat'];
load(fileName);
fileName = [path,fileNamePreamble,'exptData.mat'];
load(fileName);

firstTrialFileName = [path,fileNamePreamble,'trial',num2str(1,'%03d'),'.mat'];
load(firstTrialFileName);
%% Figure prep
%         figure
%         set(0,'DefaultFigureWindowStyle','normal')
%         setCurrentFigurePosition(1);
%         subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.05], [0.1 0.01], [0.1 0.01]);
%         set(0,'DefaultFigureColor','w')
close all

%% Calculate title
dateNumber = datenum(exptInfo.dNum,'yymmdd');
dateAsString = datestr(dateNumber,'mm-dd-yy');
fileStem = char(regexp(path,'.*(?=flyExpNum)','match'));
saveFolder = [fileStem,'Figures\'];
if ~isdir(saveFolder)
    mkdir(saveFolder)
end
saveFileName = [saveFolder,'flyExpNum',num2str(exptInfo.flyExpNum,'%03d'),'.pdf'];
flyDataPreamble = char(regexp(fileNamePreamble,'.*(?=flyExpNum)','match'));
flyDataFileName = [fileStem,flyDataPreamble,'flyData'];
load(flyDataFileName);
if ~isfield(FlyData,'aim')
    FlyData.aim = '';
end
if ~isfield(exptInfo,'flyExpNotes')
    exptInfo.flyExpNotes = '';
end
sumTitle = {[dateAsString,', ',exptInfo.prefixCode,', ExpNum ',num2str(exptInfo.expNum),', FlyNum ',num2str(exptInfo.flyNum),...
    ', FlyExpNum ',num2str(exptInfo.flyExpNum)];['Aim: ',FlyData.aim];['Expt Notes: ',exptInfo.flyExpNotes]};

%% Hardcoded paramters
timeBefore = 0.3;
pipStartInd = Stim.startPadDur*Stim.sampleRate/dsFactor + 1;
indBefore = pipStartInd - timeBefore*Stim.sampleRate/dsFactor;
indAfter = pipStartInd + timeBefore*Stim.sampleRate/dsFactor;

%% Plot stimulus
uniqueStim = unique(groupedData.stimNum);
colorSet = distinguishable_colors(length(uniqueStim),'w');

%% Rotate all trials
refVect = [0; -1];
if sum(groupedData.trialsToInclude) == 0
    return
end
trialNums = 1:length(groupedData.stimNum);
allFastTrials = trialNums(groupedData.trialsToInclude);
xDispAFT = [groupedData.midChunk.xDisp{allFastTrials}];
yDispAFT = [groupedData.midChunk.yDisp{allFastTrials}];
trialVect = [mean(xDispAFT(1,:));mean(yDispAFT(1,:))];
rotAng = acos(dot(trialVect,refVect)/(norm(trialVect)*norm(refVect)));
if trialVect(1) > 0
    R = [cos(rotAng) sin(rotAng);-sin(rotAng) cos(rotAng)];
elseif trialVect(1) <= 0
    R = [cos(rotAng) -sin(rotAng);sin(rotAng) cos(rotAng)];
end

%% Figure settings
figure
hold on
set(0,'DefaultFigureWindowStyle','normal')
setCurrentFigurePosition(1);
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.05], [0.1 0.01], [0.1 0.01]);
set(0,'DefaultFigureColor','w')

%% Plot for each stim Num
for i = 1:length(uniqueStim)
    
    if mod(i,2)
        currColor = 'b';
        
    else
        currColor = 'r';
    end
    
    %% Select the trials for this stimulus
    trialsToIncludeNums = trialNums(groupedData.trialsToInclude);
    stimNumIndNotSelected = find(groupedData.stimNum == uniqueStim(i));
    stimNumInd = intersect(trialsToIncludeNums,stimNumIndNotSelected);
    
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
    
    dispLength = length(rotXDisp(1,pipStartInd:end));
    ts = (1:dispLength).*1/100;
    dispSum{i} = trapz(ts,rotXDisp(:,pipStartInd:end)');
    plot(ceil(i/2),dispSum{i},'Marker','.','Color',currColor,'MarkerSize',12)
    
    
    % xlabels 
    if mod(i,2)
        freqLabel(ceil(i/2)) = groupedData.stimFreq(i);
        meanDisp1(ceil(i/2)) = mean(dispSum{i});
    else
        meanDisp2(ceil(i/2)) = mean(dispSum{i});
    end
    
    clear rotVel rotDisp
    
    
    
    
end

plot(7:16,meanDisp1(7:16),'b','LineWidth',4)
plot(7:16,meanDisp2(7:16),'r','LineWidth',4)

moveXAxis

xlim([6.5 16.5])
ylim([-25 25])
set(gca,'XTick',1:21,'TickDir','out','FontSize',32)%
set(gca,'XTickLabel',round(freqLabel))

xlabel('Stimulus frequency (Hz)')
ylabel('Integral of x displacment vs. time (mm s)')
% suptitle(sumTitle)
saveFileName = [saveFolder,'flyExpNum',num2str(exptInfo.flyExpNum,'%03d'),'tuningPlot','.pdf'];
mySave(saveFileName,[5 5]);



end

function moveXAxis
% set(gca,'XColor','white')
hold on
line([1,21],[0,0],'Color','k')
end