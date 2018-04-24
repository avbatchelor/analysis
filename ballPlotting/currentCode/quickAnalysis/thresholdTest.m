% Test effect of changing speed threshold for cardinal flies 
speedThreshold = 0:40;
for i = speedThreshold
    filename = ['speedThresholdTest_',num2str(i,'%03d')];
    plotMeanAcrossFliesDisp('Cardinal','y','n','n','y',filename,'y',i)
end