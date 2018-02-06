function groupBallDataAllExpts(prefixCode,expNum,flyNum)

exptInfo.prefixCode     = prefixCode;
exptInfo.expNum         = expNum;
exptInfo.flyNum         = flyNum;
exptInfo.flyExpNum      = 1;
[~, path, ~, ~] = getDataFileNameBall(exptInfo);
fileStem = char(regexp(path,'.*(?=flyExpNum)','match'));
cd(fileStem); 
expNumList = dir('flyExp*');
for i = 1:length(expNumList)
    flyExpNum = str2num(char(regexp(expNumList(i).name,'(?<=flyExpNum).*','match')));
    if strcmp(prefixCode,'rotRep') && expNum <= 9
        groupBallDataPostHoc(prefixCode,expNum,flyNum,flyExpNum)
    else 
        groupBallDataDiffStim(prefixCode,expNum,flyNum,flyExpNum)
    end
end