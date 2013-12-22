% Run Script of CIS 581 Final Project Logo Replacement
% Written by Chao Qu, Qiong Wang at University of Pennsylvania
% Nov.28th, 2013

% Parameters
option    = 1;             % 0 -- option 1, 1 -- option 2(default)
verbose   = true;         % Whether show stitching details

%% Load test images
if ~exist('Iall', 'var')
    [Iall, Iref, Inew] = load_images('./images/upenn/');
end

%% Logo Replacement
Iout = logo_replacement_wrapper(Iall, Iref, Inew, outputDir, 19, verbose);