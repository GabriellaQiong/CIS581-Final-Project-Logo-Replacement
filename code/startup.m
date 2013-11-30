clearvars -except Iall Inew Iref
close all
clc
%% Add vl_toolbox
run('../vlfeat/toolbox/vl_setup.m')
addpath('utils')
addpath('plot')
%% Load images
if ~exist('Iall', 'var')
    [Iall, Iref, Inew] = load_images('../images/sample1/');
end

