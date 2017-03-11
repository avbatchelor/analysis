load('C:\Users\Alex\Documents\Data\ephysData\vPN1\expNum002\flyNum007\cellNum001\cellExpNum011\groupedData.mat')

sampRate1 = StimStruct(1).stimObj.sampleRate;
startInd = 2*sampRate1; 
endInd = 5*sampRate1;
ti1 = startInd:endInd;

sampRate2 = 10e3;
startInd = 2*sampRate2; 
endInd = 5*sampRate2;
ti2 = startInd:endInd;

figure; 
subplot(8,2,1)
plot(GroupStim(1).stimTime(ti1),GroupStim(1).stimulus(ti1))
noXAxisSettings
for i = 1:15
    subplot(8,2,i+1)
    plot(GroupData(1).sampTime(ti2),mean(GroupData(i).voltage(:,ti2)))
    noXAxisSettings
    ylim([-50 -25])
    hold on 
    %line([GroupData(1).sampTime(ti2(1)) GroupData.sampTime(ti2(end))],[-40 -40])
end
    