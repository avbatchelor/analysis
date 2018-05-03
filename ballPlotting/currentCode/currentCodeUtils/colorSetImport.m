function [colorSet1,colorSet2] = colorSetImport 

% Lighter shades
green = [91,209,82]./255;
purple = [178,102,255]./255;
orange = [255,178,102]./255;

% Darker shades
dark_green = [77,162,71]./255;
dark_purple = [102,0,204]./255;
dark_orange = [255,128,0]./255;

% Make color sets
colorSet1 = [green;purple;orange];
colorSet2 = [dark_green;dark_purple;dark_orange];