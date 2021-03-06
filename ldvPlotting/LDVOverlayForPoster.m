function LDVOverlayForPoster(expNum,flyNum)

close all

%% Open files and create folders 
expNum = num2str(expNum,'%03d');
flyNum = num2str(flyNum,'%03d');

exptNums =[2,1];

rootFolder = ['C:\Users\Alex\Documents\Data\ldvData\expNum',expNum,'\flyNum',flyNum,'\'];
saveFolder = [rootFolder,'Figures\'];
imageFolder = [rootFolder,'Figures\Images\'];

if ~isdir(saveFolder)
    mkdir(saveFolder)
end
if ~isdir(imageFolder)
    mkdir(imageFolder)
end

%% Colour setup
gray = [192 192 192]./255;
colours = {'r','b'};

%% Make figure
figCount = 0;
count2 = 0;
for n = exptNums
    count2 = count2+1;
    filename = ['C:\Users\Alex\Documents\Data\ldvData\expNum001\flyNum003\ldv_expNum001_flyNum003_flyExpNum',num2str(n,'%03d')];
    load(filename);
    
    clear velocity displacement
    count = 0;
    for i = 1:length(data)
        if max(abs(data(i).velocity)) < 5
            count = count + 1;
            velocity(count,:) = data(i).velocity;
            displacement(count,:) = data(i).displacement - mean(data(i).displacement(9000:10000));
        end
    end
    
    set(0,'DefaultFigureColor','w')
    set(0,'DefaultAxesBox','off')
    set(0,'defaultAxesFontName','Calibri')
    set(0,'defaultAxesFontSize',14)
    
    figure(1);
    set(gcf,'PaperPositionMode','auto','Unit','inches','Position',[1 1 4 5]);
    
    h(1) = subplot(2,1,1);
    stimTime = [1/Stim(1).sampleRate:1/Stim(1).sampleRate:Stim(1).totalDur]';
    plot(stimTime,Stim(1).stimulus,'k','lineWidth',2);
    ylabel('Stimulus (V)');
    set(gca,'Box','off','TickDir','out','XTickLabel','')
    ylim([-1.1 1.1])
    set(gca,'xtick',[])
    set(gca,'XColor','white')
    
    h(2) = subplot(2,1,2);
    hold on 
    sampTime = [1/settings.sampRate.in:1/settings.sampRate.in:Stim(1).totalDur]';
    stdVel = std(velocity,1);
    ph(count2) = plot(sampTime,mean(velocity),colours{count2},'LineWidth',3);
    plot(sampTime,mean(velocity)+stdVel,colours{count2},'LineWidth',0.5);
    plot(sampTime,mean(velocity)-stdVel,colours{count2},'LineWidth',0.5);
%     lineProps.col = {colours{count2}};
%     mseb(sampTime',mean(velocity),stdVel,lineProps)
    hold on
    ylabel('Velocity (mm/s)');
    set(gca,'Box','off','TickDir','out')
    axis tight
    xlabel('Time (seconds)');
    ylim([-1.1 1.1])
    
    linkaxes(h,'x')
    
    spaceplots
    

end

legend(ph,{'Probe on','Probe off'})
legend(h(2),'boxoff')
set(gca,'Fontsize',14)
set(gca,'FontName','Calibri')
xlim([0.995 1.025])
figCount = figCount + 1;
saveFilename= [saveFolder,'overlay_zoom_3.pdf'];
mySave(saveFilename)
