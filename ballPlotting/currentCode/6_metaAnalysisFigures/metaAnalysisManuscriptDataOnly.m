clear all

prefixCodes = {'Freq';'Males';'a2Glued';'a3Glued';'ShamGlued-45';...
     'RightGlued';'LeftGlued';'Diag';'Cardinal';'Cardinal-0'};

% prefixCodes = {'Freq';'Males';'Diag';'Cardinal';'Cardinal-0'};
%  
% prefixCodes = {'a2Glued';'a3Glued';'ShamGlued-45';...
%     'RightGlued';'LeftGlued'};

% prefixCodes = {'Freq';'Diag';'Cardinal';'ShamGlued-45'};
 
dataIdx = 0;
for i = 1:size(prefixCodes,1)
    
    prefixCode = prefixCodes{i};
    flies = getFlyExpts(prefixCode);
    
    for j = 1:size(flies,1)
        dataIdx = dataIdx + 1;
        [prefixCode,expNum,flyNum,flyExpNum] = flies{j,:};
        exptInfo = exptInfoStruct(prefixCode,expNum,flyNum,flyExpNum);
        
        % Get paths
        [~, path, fileNamePreamble] = getDataFileNameBall(exptInfo);
        
        % Fly data paths 
        flyPath = char(regexp(path,'.*(?=flyExpNum)','match'));
        flyPreamble = char(regexp(fileNamePreamble,'.*(?=flyExpNum)','match'));
        filename = [flyPath,flyPreamble,'flyData.mat'];
        
        % Load and process fly data 
        load(filename)
        temp(dataIdx) = str2num(cell2mat(FlyData.temperature));
        humidity(dataIdx) = str2num(cell2mat(FlyData.humidity));
        eclosionDate{dataIdx} = datenum(FlyData.eclosionDate);
        gluingDate{dataIdx} = datenum(FlyData.antennaGluingDate);
        
        % Expt data paths 
        filename = [path,fileNamePreamble,'exptData.mat'];
        load(filename)
        
        % Load and process expt data 
        exptDate{dataIdx} = datenum(exptInfo.dNum,'yymmdd');
        exptTime{dataIdx} = exptInfo.exptStartTime;
        exptHour{dataIdx} = str2num(char(regexp(exptInfo.exptStartTime,'.*(?=:\d\d:)','match')));
        flyAge(dataIdx) = exptDate{dataIdx} - eclosionDate{dataIdx};
        glueDay(dataIdx) = gluingDate{dataIdx} - eclosionDate{dataIdx};
    end
end

disp(['Mean temp = ',num2str(mean(temp))])
disp(['Min temp = ',num2str(min(temp))])
disp(['Max temp = ',num2str(max(temp))])

disp(['Mean humidity = ',num2str(mean(humidity))])
disp(['Min humidity = ',num2str(min(humidity))])
disp(['Max humidity = ',num2str(max(humidity))])

disp(['Min age = ',num2str(min(flyAge))])
disp(['Max age = ',num2str(max(flyAge))])
