function saveFolder = getSaveFolderName(exptInfo)

[~, path, ~, ~] = getDataFileName(exptInfo);

saveFolderStem = char(regexp(path,'.*(?=cellNum)','match'));
saveFolder = [saveFolderStem,'Figures\','cellNum_',num2str(exptInfo.cellNum),'\',...
    'cellExpNum_',num2str(exptInfo.cellExpNum),'_figs\'];
if ~isdir(saveFolder)
    mkdir(saveFolder);
end

end