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
    [Iall, Iref, Inew] = load_images('../images/sample1/');
end
Iout  = cell(numel(Iall), 1);

% Compute the transform from reference image to new image
[ulPtRef, widthRef, ~] = imbbox(Iref, []);
[ulPtNew, widthNew, ~] = imbbox(Inew, []);

Tf = [[diag(widthNew ./ widthRef); 0, 0], [ulPtNew' - ulPtRef'; 1]];


% Logo Replacement
for imIdx = 1 : numel(Iall)
    fprintf('Processing image %d ... \n', imIdx);
    [frames1, frames2, matches] = logo_detect_SIFT(Iref, Iall{imIdx});
    p1 = [frames1(1,matches(1,:)); frames1(2,matches(1,:))];
    p2 = [frames2(1,matches(2,:)); frames2(2,matches(2,:))];
    [tpsX, tpsY, inlierInd, continueFlag] = ransac_tps(p1(1,:), p1(2,:), p2(1,:), p2(2,:), 3);
    if continueFlag
        fprintf('Descriptors are not enough for image %d \n', imIdx);
        continue;
    end
    
    if verbose
        h1 = ransac_plot(Iref, Iall{imIdx}, p1, p2, inlierInd, matches);
        fig_save(h1, fullfile(outputDir, sprintf('bb_ransac_img%02d', imIdx)), 'png');
    end
    
    p1New = mapcpt(Iref, Inew, p1, verbose);
    [Iout{imIdx}, h2] = logo_replace(Iall{imIdx}, Inew, tpsX, tpsY, p1New(:, inlierInd), p2(:, inlierInd), verbose);
    fig_save(h2, fullfile(outputDir, sprintf('bb_replace_img%02d', imIdx)), 'png');
end