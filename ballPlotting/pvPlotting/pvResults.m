% Plot particle velocity 

%% Data
freq = [100,140,200,225,300,500,800];
speaker1 = [1.2653,1.2475,1.2699,1.2952,1.2607,1.2549,1.2682];
speaker2 = [1.2506,1.2212,1.2513,1.2593,1.235,1.28,1.2092];
speaker3 = [1.2538,1.2483,1.2242,1.2493,1.2432,1.2037,1.2131];
speaker6 = [1.2808,1.2979,1.3236,1.2651,1.2343,1.257,1.3051];

%% Figure Settings 
colorSet = distinguishable_colors(4,'w');

%% Figure
figure;
hold on 
plot(freq,speaker1,'Marker','*','Color',colorSet(1,:),'Linewidth',2)
plot(freq,speaker2,'Marker','*','Color',colorSet(2,:),'Linewidth',2)
plot(freq,speaker3,'Marker','*','Color',colorSet(3,:),'Linewidth',2)
plot(freq,speaker6,'Marker','*','Color',colorSet(4,:),'Linewidth',2)

ylabel('Particle velocity (mm/s)')
xlabel('Frequency')
ylim([0 1.5])

legend({'speaker 1','speaker 2','speaker 3','speaker 6'},'Location','best')
set(findall(gcf,'-property','FontSize'),'FontSize',30)