clear all 
close all

ball_folder = 'C:\Users\Alex\Documents\Data\flyGroomingVideos\RO1data\vidsReadyForAnalysis\annotationFolder\ball';
offball_folder = 'C:\Users\Alex\Documents\Data\flyGroomingVideos\RO1data\vidsReadyForAnalysis\annotationFolder\offball';

cd(ball_folder)
ball_files = dir('*.txt');

figure
for i = 1:length(ball_files)
    [frame_array, behaviour] = importAnnotationData(ball_files(i).name);
    numFrames(i) = length(frame_array);
    num_grooming_frames(i) = sum(behaviour == 1);
    subplot(6,1,i)
    plot(frame_array,behaviour)
end
    
ball_percentage_grooming = 100*(sum(num_grooming_frames)/sum(numFrames));


%% offball
cd(offball_folder)
offball_files = dir('*.txt');
for i = 1:length(offball_files)
    [frame_array, behaviour] = importAnnotationData(offball_files(i).name);
    numFrames(i) = length(frame_array);
    num_grooming_frames(i) = sum(behaviour == 1);
end
    
offball_percentage_grooming = 100*(sum(num_grooming_frames)/sum(numFrames));

%% Plot of grooming on the ball 
clear all 
close all
ball_folder = 'C:\Users\Alex\Documents\Data\flyGroomingVideos\RO1data\vidsReadyForAnalysis\annotationFolder\ball';
cd(ball_folder)
ball_files = dir('*.txt');

figure
for i = 1:length(ball_files)
    [frame_array{i}, behaviour{i}] = importAnnotationData(ball_files(i).name);
end

%%
set(0,'DefaultAxesFontSize', 12)
set(0,'DefaultFigureColor','w')
set(0,'DefaultAxesBox','off')
close all

behaviour_bin = cell2mat(behaviour'); 
behaviour_bin = behaviour_bin==1;

frameRate = 71.7; 
int = 1/frameRate; 
time = (int.*(1:length(behaviour_bin)))./60;
figure
bar(time,behaviour_bin,1)
xlabel('Time (minutes)')
set(gca,'Box','off','TickDir','out','YTick',[],'YColor','white')
title('Ethogram of antennal grooming for a fly on the ball')
axis tight

mySave('C:\Users\Alex\Documents\Data\flyGroomingVideos\RO1data\ball_grooming_example.pdf',[5,1])


%% Plot of grooming on the ball 
close all
offball_folder = 'C:\Users\Alex\Documents\Data\flyGroomingVideos\RO1data\vidsReadyForAnalysis\annotationFolder\offball';
cd(offball_folder)
offball_files = dir('*.txt');

figure
for i = 1:length(offball_files)
    [frame_array2{i}, behaviour2{i}] = importAnnotationData(offball_files(i).name);
end

%%
set(0,'DefaultAxesFontSize', 12)
set(0,'DefaultFigureColor','w')
set(0,'DefaultAxesBox','off')
close all

behaviour_bin2 = cell2mat(behaviour2'); 
behaviour_bin2 = behaviour_bin2==1;

frameRate = 71.7; 
int = 1/frameRate; 
time = (int.*(1:length(behaviour_bin2)))./60;
figure
bar(time,behaviour_bin2,1,'r')
xlabel('Time (minutes)')
set(gca,'Box','off','TickDir','out','YTick',[],'YColor','white')
title('Ethogram of antennal grooming for a fly off the ball')
axis tight

mySave('C:\Users\Alex\Documents\Data\flyGroomingVideos\RO1data\offball_grooming_example.pdf',[5,1])


