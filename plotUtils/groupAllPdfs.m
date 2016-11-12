function groupAllPdfs(folder,varargin)

if nargin == 0 
    folder = uigetdir; 
end
cd(folder) 
subFolderNames = dir('*_figs'); 

for i = 1:length(subFolderNames)
    groupPdfs([folder,'\',subFolderNames(i).name])
end