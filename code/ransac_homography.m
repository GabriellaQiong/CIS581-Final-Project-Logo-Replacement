function [H, inlier_ind] = ransac_homography(x1, y1, x2, y2, thresh)
if nargin < 5, thresh = 5; end
y1 = y1(:); x1 = x1(:); y2 = y2(:); x2 = x2(:);
percent_inlier = 0.99; % stop when x% of the points are inlier
iter = 300; % ransac max iteration
num_pts = numel(y1);
ind = 1:num_pts;

inlier_ind = [];
% RANSAC
for i = 1:iter
    perm = randperm(num_pts);
    rand_ind = perm(1:4);
    % estimate homography from source(2) to destination(1)
    Hest = est_homography(x1(rand_ind), y1(rand_ind), x2(rand_ind), y2(rand_ind));
    % apply homography on source(2) to corresponding points in destination(1)
    [x1_est, y1_est] = apply_homography(Hest, x2, y2);
    dist = (x1_est - x1).^2 + (y1_est - y1).^2;
    inlier = ind(dist < thresh^2);
    num_inlier = length(inlier);

    if num_inlier > (num_pts * percent_inlier)
        % break if n% of the points are inlier
        inlier_ind = inlier;
        H = est_homography(x1(inlier_ind), y1(inlier_ind), x2(inlier_ind), y2(inlier_ind));
        break
    elseif num_inlier > length(inlier_ind)
        % update best inlier
        inlier_ind = inlier;
    end
end
H = est_homography(x1(inlier_ind), y1(inlier_ind), x2(inlier_ind), y2(inlier_ind));

end

