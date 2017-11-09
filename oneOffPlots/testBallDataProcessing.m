exptInfo.prefixCode     = 'rotRep2';
exptInfo.expNum         = 1;
exptInfo.flyNum         = 2;
exptInfo.flyExpNum      = 2;
[~, path, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
cd(path);
dirCont = dir('*trial*');
for i = 1:length(dirCont)
    %% Load data
    load(dirCont(i).name);
    trialNum = trialMeta.trialNum;
    settings = ballSettings;
    
    %% Process data
    [procData.vel(:,1),procData.disp(:,1),seq(:,1),seqRound(:,1)] = processBallData(data.xVel,settings.xMinVal,settings.xMaxVal,settings,Stim);
    [procData.vel(:,2),procData.disp(:,2),seq(:,2),seqRound(:,2)] = processBallData(data.yVel,settings.yMinVal,settings.yMaxVal,settings,Stim);
    
    xVoltsPerStep = (settings.xMaxVal - settings.xMinVal)/(settings.numInts - 1);
    yVoltsPerStep = (settings.yMaxVal - settings.yMinVal)/(settings.numInts - 1);

    zeroVal = -1 + (settings.numInts + 1)/2;
    xMidVal = (settings.xMaxVal - settings.xMinVal)/2;
    yMidVal = (settings.yMaxVal - settings.yMinVal)/2;
% 
%     figure; 
%     subplot(2,1,1)
%     hold on 
%     plot(data.xVel)
%     plot(1:length(data.xVel),repmat(xMidVal,size(data.xVel)),'r')
%     plot(1:length(data.xVel),repmat(settings.xMidVal,size(data.xVel)),'g')
% 
%     subplot(2,1,2)
%     hold on 
%     plot(data.yVel)
%     plot(1:length(data.yVel),repmat(yMidVal,size(data.xVel)),'r')     
%     plot(1:length(data.xVel),repmat(settings.yMidVal,size(data.xVel)),'g')
    
    figure;
    subplot(2,1,1)
    hold on 
    plot(((data.xVel - xMidVal)./xVoltsPerStep),'b')
    plot(seqRound(:,1),'r')
    plot(seq(:,1),'g')
    subplot(2,1,2)
    hold on 
    plot(((data.yVel - yMidVal)./yVoltsPerStep),'b')
    plot(seqRound(:,2),'r')
    plot(seq(:,2),'g')
    
    pause
    close all

    
    
end
