function plotTemperature

rootDir = 'D:\ManuscriptData\rawData';
cd(rootDir)

dirList = dir('**/**/**/*flyData.mat');

pathList = {};

for i = 1:length(dirList)
    pathList{i} = fullfile(dirList(i).folder,dirList(i).name);
end

uniquePathList = unique(pathList');

for j = 1:length(uniquePathList)
    load(char(uniquePathList(j)))
    temp(j) = str2num(cell2mat(FlyData.temperature));
end

plot(temp)
disp(min(temp))
disp(max(temp))
