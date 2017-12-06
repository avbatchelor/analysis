function groupPdfs(folder,varargin)

cd('C:\Users\Alex\Documents\ProcessedData\ballData')
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
    allFileStemPart1 = char(regexp(fileNames(1).name,'.*(?=cellExpNum)','match'));
    allFileStemPart2 = char(regexp(fileNames(1).name,'(?<=cellExpNum)\d\d\d','match'));
    allFileStem = [allFileStemPart1,'cellExpNum',allFileStemPart2];
end
%allFileStem = char(regexp(fileNames(1).name,'.*(?=roi)','match'));

groupFileName = [saveFolder,allFileStem,'_summary_fig.pdf'];

%% Determine which pdfs to append
saveFileNameArray = struct2cell(fileNames); 
saveFileName = saveFileNameArray(1,:);
saveFileName = saveFileName';

%% Append pdfs
myAppendPdfs(saveFileName,groupFileName)

