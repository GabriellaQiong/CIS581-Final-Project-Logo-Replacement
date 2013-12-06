function [ varargout ] = sift_plot(im1, im2, thresh, scores, p1, p2, f1, f2)
% [h] = SIFT_PLOT(im1, im2, thresh, scores, p1, p2, f1, f2)
% thresh    - [0, 1] percentage, (1, inf) number
sift = false;
if nargin < 4, sift = true; end
if nargin == 2, thresh = 1; end

% align two images
h = figure();
dh1 = max(size(im2,1) - size(im1,1), 0) ;
dh2 = max(size(im1,1) - size(im2,1), 0) ;
imagesc([padarray(im1, dh1, 'post'), padarray(im2, dh2, 'post')]) ;
axis image
set(gca,'TickDir','out')

% do sift_match
if sift
    [matches, scores, p1, p2, f1, f2] = sift_match(im1, im2, 0, 1e6);
end
fprintf('Matches: \t%d\n', size(matches, 2))

% convert thresh to number of matches
if thresh <= 1, thresh = ceil(thresh * numel(scores)); end
idx = 1:min(thresh, numel(scores));

% plot lines and descriptors
figure(h)
o = size(im1, 2) ;
line([p1(1,idx); p2(1,idx) + o], ...
     [p1(2,idx); p2(2,idx)], 'Color', 'b')
hold on
plot([1, 1]*size(im1,2), [1, size(im2, 1) + dh2(1)], 'k')
hold off
f2_o = bsxfun(@plus, f2, [o;0;0;0]);
vl_plotframe(f1(:,idx));
vl_plotframe(f2_o(:,idx));

% ransac
[~, ~, inlier_ind ] = ...
    ransac_tps(p1(1,:), p1(2,:), p2(1,:), p2(2,:), 7);
%  [~, inlier_ind ] = ...
%      ransac_homography(p1(1,:), p1(2,:), p2(1,:), p2(2,:), 7);
fprintf('RANSAC: \t%d/%d\n', numel(inlier_ind), size(matches, 2))

line([p1(1,inlier_ind); p2(1,inlier_ind) + o], ...
     [p1(2,inlier_ind); p2(2,inlier_ind)], 'Color', 'r')

if nargout > 0, varargout{1} = h; end

end
