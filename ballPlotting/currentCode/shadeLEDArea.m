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
