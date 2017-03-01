function zoomFig

%% Load figure 
[filename,path] = uigetfile;
open(fullfile(path,filename));
fullFilename = fullfile(path,filename);

%% Creat matlab icon to press
[img,map] = imread(fullfile(matlabroot,...
            'toolbox','matlab','icons','matlabicon.gif'));
icon = ind2rgb(img,map);

%% Create toolbar
t = uitoolbar(gcf);

%% Create push button 
p = uipushtool(t,'TooltipString','Toolbar push button',...
                 'ClickedCallback',{@save_pushbutton_callback,fullFilename});
             
%% Set the button icon
p.CData = icon;

% %% Close figure
% close all

end
             
             