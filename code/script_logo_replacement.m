% Run Script of CIS 581 Final Project Logo Replacement
% Written by Chao Qu, Qiong Wang at University of Pennsylvania
% Nov.28th, 2013

% Clear up
clc;
close all;

% Parameters
option    = 1;            % 0 -- option 1, 1 -- option 2(default)
verbose   = true;         % Whether show stitching details

% Path
p         = mfilename('fullpath');
scriptDir = fileparts(p);
vlfeatDir = fullfile(scriptDir, '../vlfeat/toolbox');
addpath(vlfeatDir); 
cd(vlfeatDir); vl_setup; cd(scriptDir);
outputDir = fullfile(scriptDir, '/results');
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end
addpath ./utils

% Load Images
if ~exist('Iall', 'var')
    [Iall, Iref, Inew] = load_images('../images/sample1/');
end

% Generate codebook of HOG descriptor of reference image
codebook = generate_codebook(Iref);

% Logo Replacement
for imIdx = 1 : numel(Iall)
   fprintf('Processing image %d ... \n', imIdx);
   [matchedPts1, matchedPts2, indexPairs] = logo_detect_HoG(Iref, Iall{imIdx}, verbose);
%    [matchedPts1, matchedPts2, indexPairs] = logo_detect_MSER(Iref, Iall{imIdx}, verbose);
end