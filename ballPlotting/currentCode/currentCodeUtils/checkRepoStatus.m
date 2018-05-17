function statusStr = checkRepoStatus

[~,shortHash,currentFlag] = getCodeStamp(mfilename('fullpath'));

if strcmp(currentFlag,'*')
    warning('Changes still to commit');
    commitStr = 'uncommitted_changes';
else
    commitStr = '';
end

statusStr = [datestr(now,'mmddyy'),'_',shortHash,'_',commitStr];