function [h] = ImplayWithMap(frames, fps, limits)
%ImplayWithMap Calls the implay function and adjust the color map
% Call it with 3 parameters:
% ImplayWithMap(frames, fps, limits)
% frames - 4D arrray of images
% fps - frame rate
% limits - an array of 2 elements, specifying the lower / upper
% of the liearly mapped colormap
% Returns a nadle to the player
%
% example: 
% h = ImplayWithMap(MyFrames, 30, [10 50])

h = implay(frames, fps);
h.Visual.ColorMap.UserRangeMin = limits(1);
h.Visual.ColorMap.UserRangeMax = limits(2);
h.Visual.ColorMap.UserRange = 1;

p = get(0,'MonitorPositions');
set(findall(0,'tag','spcui_scope_framework'),'position',p(1,:));

