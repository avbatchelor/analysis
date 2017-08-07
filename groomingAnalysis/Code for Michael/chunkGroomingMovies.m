function chunkGroomingMovies(movieFilenames,moviePathname,varargin)
% This function converts movies to a form that can be used by the annotation program ANVIL.
% The function will ask you to select the movies you want to annotate.
% Make sure that these movies are of a section of continuous time.
% The function will convert the codec of these movies to a codec that ANVIL uses and then
% group the movies into a single movie that is ~10mins long.

%% Make sure old files are deleted
path = 'C:\Users\Alex\Documents\Data\flyGroomingVideos\RO1data\';
listFilename = [path,'mylist.txt'];
delete(listFilename)
delete('C:\Users\Alex\Documents\Data\flyGroomingVideos\RO1data\convertedVids\*.mov')

%% choose movie files to append and copy them to the convertedVids folder
if ~exist('movieFilenames','var')
    [movieFilenames,moviePathname] = uigetfile('.avi','Select movies for annotation','MultiSelect','on');
end 

if iscell(movieFilenames)
    numMovies = length(movieFilenames);
else 
    numMovies = 1; 
end 

tempFolder = 'C:\Users\Alex\Documents\Data\flyGroomingVideos\RO1data\temp\';
for n = 1:numMovies
    if numMovies == 1 
        copyfile([moviePathname,movieFilenames],tempFolder)
    else 
        copyfile([moviePathname,movieFilenames{1,n}],tempFolder)
    end
end

%% Convert movie codec 
cd(tempFolder)
system('C:\Users\Alex\Documents\Data\flyGroomingVideos\RO1data\temp\batch.bat')

% clear the temp folder 
delete([tempFolder,'*.avi'])


%% Make movie list file
dirname = 'C:\Users\Alex\Documents\Data\flyGroomingVideos\RO1data\convertedVids';
dirdeets = dir(fullfile(dirname,'/*.mov'));
filelist = {dirdeets.name};

fid = fopen(listFilename, 'w');
for i = 1:numMovies
    fprintf(fid, 'file ''%s\\%s''\r\n', dirname, filelist{:,i});
end
fclose(fid);


%% Concatenate movies 
system('C:\Users\Alex\Documents\GitHub\analysis\groomingAnalysis\concatGroomingMovies.bat')

%     % save the vidsToAnnotate properly
%     vidFolderName = char(regexp(moviePathname,'\d*\d','match'));
%     rat = char(regexp(moviePathname,'\w*(?=\\WebCam)','match'));
%     firstVid = char(regexp(filelist{:,inputMovies(1)},'\w*(?=\.mov)','match'));
%     lastVid = char(regexp(filelist{:,inputMovies(end)},'\w*(?=\.mov)','match'));
%
%     newPathname = ['C:\Users\Alex\vidsToAnnotate\',rat,'\',vidFolderName,'\'];
%     newFilename = [firstVid,'-',lastVid,'.mov'];
%
%     if ~isdir(newPathname)
%         mkdir(newPathname)
%     end
%
%     movefile('C:\Users\Alex\vidsToAnnotate\output.mov',[newPathname,newFilename],'f')


delete(listFilename)

%% Move output file 
if numMovies == 1
    filenameStem = movieFilenames;
else
    filenameStem = movieFilenames{1,1};
end
fileStem = char(regexp(filenameStem,'.*(?=.avi)','match'));
finalFolder = 'C:\Users\Alex\Documents\Data\flyGroomingVideos\RO1data\vidsReadyForAnalysis\';
finalFileName = [finalFolder,fileStem,'converted.avi'];

copyfile('C:\Users\Alex\Documents\Data\flyGroomingVideos\RO1data\outputVids\output.avi',finalFileName)

delete('C:\Users\Alex\Documents\Data\flyGroomingVideos\RO1data\outputVids\output.avi')

% clear the converted vids folder
delete('C:\Users\Alex\Documents\Data\flyGroomingVideos\RO1data\convertedVids\*.mov')

end
