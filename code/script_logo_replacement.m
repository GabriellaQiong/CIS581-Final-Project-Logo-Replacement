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
    [Iall, Iref, Inew] = load_images('../images/sample1/');
end
Iout  = cell(numel(Iall), 1);

% % Generate codebook of HOG descriptor of reference image
% codebook = generate_codebook(Iref);

% Logo Replacement
for imIdx = 1 : 1%numel(Iall)
    fprintf('Processing image %d ... \n', imIdx);
    [frames1, frames2, matches] = logo_detect_SIFT(Iref, Iall{imIdx});
    p1 = [frames1(1,matches(1,:)); frames1(2,matches(1,:))];
    p2 = [frames2(1,matches(2,:)); frames2(2,matches(2,:))];
    [tpsX, tpsY, inlierInd, continueFlag] = ransac_tps(p1(1,:), p1(2,:), p2(1,:), p2(2,:), 5);
    if continueFlag
        fprintf('Descriptors are not enough for image %d \n', imIdx);
        continue;
    end
    if verbose
        ransac_plot(Iref, Iall{imIdx}, p1, p2, inlierInd, matches);
    end
    
    Iout{imIdx} = logo_replace(Iall{imIdx}, Inew, tpsX, tpsY, p1(:, inlierInd), p2(:, inlierInd), verbose);
end