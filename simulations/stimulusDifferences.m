figure; 
axis = polaraxes; 
set(gca,'ThetaTick',0:45:360,'ThetaTickLabel',{'90','45','0','315','270','225','180','135'},'RTickMode','manual','RGrid','off')
set(gca,'Fontsize',25)

%% Amplitude difference
figure;
inputAngle = 0:0.01:2*pi;
amplitudeDiff = sin(2*inputAngle); 

plot(inputAngle,amplitudeDiff)
set(gca,'XTick',[0:pi/4:2*pi],'XTickLabel',{'0','45','90','135','180','225','270','315','360'})
xlabel('Input angle (degrees)')
ylabel('Amplitude Difference (a.u.)')

bottomAxisSettings


%% Phase difference 
figure;
inputAngle = 0:0.01:2*pi;
amplitudeDiff = abs((sin(inputAngle+(pi/2)))); 

plot(inputAngle,amplitudeDiff)
set(gca,'XTick',[0:pi/4:2*pi],'XTickLabel',{'0','45','90','135','180','225','270','315','360'})
set(gca,'YTick',[0:0.25:1],'YTickLabel',{'0','45','90','135','180'})
xlabel('Input angle (degrees)')
ylabel('Phase Difference (Degrees)')

bottomAxisSettings


%% Absolute phase 
figure;
hold on 
inputAngle = 0:0.01:2*pi;
rightAntenna = 1-sin(inputAngle-pi/4); 
leftAntenna = 1+sin(inputAngle+(-3*pi/4)); 


plot(inputAngle,rightAntenna,'r')
plot(inputAngle,leftAntenna,'b')
set(gca,'XTick',[0:pi/4:2*pi],'XTickLabel',{'0','45','90','135','180','225','270','315','360'})
set(gca,'YTick',[0:0.5:2],'YTickLabel',{'0','\pi/2','\pi','3\pi/2','2\pi'})
xlabel('Input angle (degrees)')
ylabel('Phase')

bottomAxisSettings

legend({'Right antenna','Left antenna'},'Box','off','Location','SouthEast')