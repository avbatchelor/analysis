close all
settings = ballSettings;

%% Process data
[procData.vel(:,1),~,seq(:,1),seqRound(:,1)] = processBallData(rawData(:,1),settings.xMinVal,settings.xMaxVal,settings);
[procData.vel(:,2),~,seq(:,2),seqRound(:,2)] = processBallData(rawData(:,2),settings.yMinVal,settings.yMaxVal,settings);

xVoltsPerStep = (settings.xMaxVal - settings.xMinVal)/(settings.numInts - 1);
yVoltsPerStep = (settings.yMaxVal - settings.yMinVal)/(settings.numInts - 1);

zeroVal = -1 + (settings.numInts + 1)/2;
xMidVal = (settings.xMaxVal - settings.xMinVal)/2;
yMidVal = (settings.yMaxVal - settings.yMinVal)/2;

figure;
subplot(2,1,1)
hold on
plot(((rawData(:,1) - xMidVal)./xVoltsPerStep),'b')
plot(seqRound(:,1),'r')
plot(seq(:,1),'g')
subplot(2,1,2)
hold on
plot(((rawData(:,2) - yMidVal)./yVoltsPerStep),'b')
plot(seqRound(:,2),'r')
plot(seq(:,2),'g')





