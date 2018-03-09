function mySave(filename,figSize,figNum,varargin)

% Save settings 
% set(gcf, 'PaperType', 'usletter');
% orient landscape

if ~exist('figSize','var')
    figSize = [5 3];
end

if ~exist('figNum','var')
    figNum = gcf;
end

% Save pdf 
export_fig(filename,'-pdf','-q50')

% Save svg
set(figNum, 'PaperSize', figSize);
set(figNum,'PaperUnits','inches','PaperPositionMode','manual','PaperPosition',[0 0,figSize]);
% set(gcf,'PaperPositionMode','auto','Unit','inches','Position',[1 1 4 5]);

fileStem = char(regexp(filename,'.*(?=.pdf)','match'));
imageFilename = [fileStem,'_image.eps'];
% print(gcf,'-depsc',imageFilename,'-r50','-painters','-cmyk')
% export_fig(imageFilename,'-eps','-q50')
% epsclean(imageFilename)

% fileStem = char(regexp(filename,'.*(?=.pdf)','match'));
% imageFilename = [fileStem,'_meta_image.emf'];
% print(gcf,'-dmeta',imageFilename,'-r50','-painters','-cmyk')

figFileStem = char(regexp(filename,'.*(?=.pdf)','match'));
figFilename = [figFileStem,'_matFig.fig'];
savefig(figFilename)