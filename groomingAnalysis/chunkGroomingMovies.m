function chunkGroomingMovies
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
[movieFilenames,moviePathname] = uigetfile('.avi','Select movies for annotation','MultiSelect','on');

for n = 1:length(movieFilenames)
    copyfile([moviePathname,movieFilenames{1,n}],'C:\Users\Alex\Documents\Data\flyGroomingVideos\RO1data\convertedVids')
end

%% Make movie list file
dirname = 'C:\Users\Alex\Documents\Data\flyGroomingVideos\RO1data\convertedVids';
dirdeets = dir(fullfile(dirname,'/*.avi'));
filelist = {dirdeets.name};

numMovies = length(filelist);

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


% clear the converted vids folder
delete('C:\Users\Alex\Documents\Data\flyGroomingVideos\RO1data\convertedVids\*.mov')

end
