function groupAllPdfs

folder = uigetdir; 
cd(folder) 
subFolderNames = dir('*_figs'); 

for i = 1:length(subFolderNames)
    groupPdfs([folder,'\',subFolderNames(i).name])
end