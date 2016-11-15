function titleString = getTitleString(exptInfo)

dateNumber = datenum(exptInfo.dNum,'yymmdd');
dateAsString = datestr(dateNumber,'mm-dd-yy');

stampString = getCodeStamp(mfilename('fullpath'));

titleString = [dateAsString,', ',exptInfo.prefixCode,', ','ExpNum ',num2str(exptInfo.expNum),...
    ', FlyNum ',num2str(exptInfo.flyNum),', CellNum ',num2str(exptInfo.cellNum),...
    ', CellExpNum ',num2str(exptInfo.cellExpNum),', ',stampString];
