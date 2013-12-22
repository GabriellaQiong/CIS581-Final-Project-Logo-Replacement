% startup.m - adds all library and load all images
close all
clc

%% Make Path
p         = mfilename('fullpath');
scriptDir = fileparts(p);
outputDir = fullfile(scriptDir, './results');
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

%% Add code and lib path
addpath(genpath('code')) 
addpath('./sift_vedaldi/ ') % Vedaldi's lib