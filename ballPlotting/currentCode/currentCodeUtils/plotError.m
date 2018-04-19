function eh = plotError(x,y,error)

gray = [.95 .95 .95];
eh = fill([x-error;flipud(x+error)],[y;flipud(y)],gray,'linestyle','none');