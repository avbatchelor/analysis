function groupPdfs(folder,varargin)

if nargin == 0 
    folder = uigetdir; 
end
if ~isdir(folder) 
    mkdir(folder) 
end
cd(folder) 
fileNames = dir('*.pdf'); 

%% Determine folder to save summary figure
figureFolder = char(regexp(folder,'.*(?=cell)','match'));
saveFolder = [figureFolder,'SummaryFigs\'];
if ~isdir(saveFolder) 
    mkdir(saveFolder) 
end

%% Determine summary figure file name
allFileStem = char(regexp(fileNames(1).name,'.*(?=_stim)','match'));
if isempty(allFileStem)
    allFileStem = char(regexp(fileNames(1).name,'.*(?=_zero)','match'));
end

%allFileStem = char(regexp(fileNames(1).name,'.*(?=roi)','match'));

groupFileName = [saveFolder,allFileStem,'_summary_fig.pdf'];

%% Determine which pdfs to append
saveFileNameArray = struct2cell(fileNames); 
saveFileName = saveFileNameArray(1,:);
saveFileName = saveFileName';

%% Append pdfs
myAppendPdfs(saveFileName,groupFileName)

