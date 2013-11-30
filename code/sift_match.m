function [matches, scores, p1, p2, f1, f2] = sift_match(im1, im2, peak_thresh, edge_thresh)
% [matches, p1, p2, scores] = SIFT_MATCH(im1, im2, peak_thresh, edge_thresh)
% peak_thresh   - obtaining fewer features as peak_thresh is increased.
% edge_thresh   - obtaining more features as edge_thresh is increased
% p1, p2        - 2 x N matrix, positions of matching descriptors in im1 and im2
% f1, f2        - 4 x N matrix, frames of matching descriptor
% matches       - 2 x N matrix, matching indices of descriptors
% scores        - 1 x N matrix, matching score, ascending order

if nargin < 3, peak_thresh = 0; end
if nargin < 4, edge_thresh = 10; end
if peak_thresh < 0 || isempty(peak_thresh), peak_thresh = 0; end
if edge_thresh < 0 || isempty(edge_thresh), edge_thresh = 10; end

% make single
im1 = im2single(im1);
im2 = im2single(im2);

% make gray
if size(im1,3) > 1, im1g = rgb2gray(im1) ; else im1g = im1 ; end
if size(im2,3) > 1, im2g = rgb2gray(im2) ; else im2g = im2 ; end

% vl_sift and vl_ubcmatch
[f1, d1] = vl_sift(im1g, 'PeakThresh', peak_thresh, 'EdgeThresh', edge_thresh) ;
[f2, d2] = vl_sift(im2g, 'PeakThresh', peak_thresh, 'EdgeThresh', edge_thresh) ;
[matches, scores] = vl_ubcmatch(d1, d2);

% sort scores in descending order
[scores, idx] = sort(scores, 'ascend');
matches = matches(:, idx);

% get position and frame of matching descriptors
p1 = f1(1:2, matches(1,:));
p2 = f2(1:2, matches(2,:));
f1 = f1(:, matches(1,:));
f2 = f2(:, matches(2,:));
end