% Run Script of CIS 581 Final Project Logo Replacement
% Written by Chao Qu, Qiong Wang at University of Pennsylvania
% Nov.28th, 2013

% Clear up
clc;
close all;

% Parameters
option    = 1;            % 0 -- option 1, 1 -- option 2(default)
verbose   = true;         % Whether show stitching details
toolbox   = 3;            % 1--vlfeat, 2--Lowe's lib, 3--Vedaldi's lib

% Path
p         = mfilename('fullpath');
scriptDir = fileparts(p);
outputDir = fullfile(scriptDir, '/results');
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end
addpath ./utils
addpath ./plot

% Toolbox
if toolbox == 1
    vlfeatDir = fullfile(scriptDir, '../vlfeat/toolbox');
    addpath(vlfeatDir);
    cd(vlfeatDir); vl_setup; cd(scriptDir);
elseif toolbox == 2
    addpath ../sift_lowe/
else
    addpath ../sift_vedaldi/
end

% Load and Intialize Images
if ~exist('Iall', 'var')
    [Iall, Iref, Inew] = load_images('../images/upenn/');
end

% Logo Replacement
Iout = logo_replacement_wrapper(Iall, Iref, Inew, outputDir, 13, verbose);