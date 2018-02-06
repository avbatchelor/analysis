function goFigure(figNum,varargin)

    if exist('figNum','var')
        figure(figNum)
    else
        figure()
    end
        
    set(0,'DefaultFigureWindowStyle','normal')
    set(0,'DefaultFigureColor','w')
    setCurrentFigurePosition(1);

