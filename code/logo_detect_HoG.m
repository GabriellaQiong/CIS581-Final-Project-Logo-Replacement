function [matchedPts1, matchedPts2, indexPairs] = logo_detect_HoG(imRef, imCmp,  verbose)
% LOGO_DETECT_HOG extracts feature descriptor

% INPUT
% imRef, imCmp = uint8 HxW array with values in the range 0-255. 
% verbose      = flag whether to show details

% OUTPUT
% matchedPts1, matchedPts2  = matched pair points
% indexPairs                = the indices of matched pairs

% Written by Qiong Wang at University of Pennsylvania
% Dec.3rd, 2013

% Initialize
if nargin < 3
    verbose = false;
end

% Parameters
cellSize = 8;
figure();
hog = vl_hog(single(imRef), cellSize, 'verbose') ;
imhog = vl_hog('render', hog, 'verbose') ;
imagesc(imhog); colormap gray;
figure();
hog = vl_hog(single(imRef), cellSize, 'verbose','variant', 'dalaltriggs') ;
imhog = vl_hog('render', hog, 'verbose','variant', 'dalaltriggs') ;
imagesc(imhog); colormap gray;
end