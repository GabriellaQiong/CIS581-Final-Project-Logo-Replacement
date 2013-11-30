function [tps_x, tps_y, inlier_ind] = ransac_tps(x1, y1, x2, y2, thresh)

if nargin < 5, thresh = 5; end
y1 = y1(:); x1 = x1(:); y2 = y2(:); x2 = x2(:);
percent_inlier = 0.99;  % stop when x% of the points are inlier
iter = 300;             % ransac max iteration
num_pts = numel(y1);
ind = 1:num_pts;

inlier_ind = [];
% RANSAC
for i = 1:iter
    perm = randperm(num_pts);
    rand_ind = perm(1:5);
    % estimate tps from source(1) to destination(2)
    tps_x = est_tps(x1(rand_ind), y1(rand_ind), x2(rand_ind));
    tps_y = est_tps(x1(rand_ind), y1(rand_ind), y2(rand_ind));
    % apply tps on source(1) to corresponding points in destination(2)
    [x2_est, y2_est] = apply_tps(x1, y1, tps_x, tps_y, x1(rand_ind), y1(rand_ind));
    dist = (x2_est - x2).^2 + (y2_est - y2).^2;
    inlier = ind(dist < thresh^2);
    num_inlier = length(inlier);
    
    if num_inlier > (num_pts * percent_inlier)
        % break if n% of the points are inlier
        inlier_ind = inlier;
        tps_x = est_tps(x1(inlier_ind), y1(inlier_ind), x2(inlier_ind));
        tps_y = est_tps(x1(inlier_ind), y1(inlier_ind), y2(inlier_ind));
        break
    elseif num_inlier > length(inlier_ind)
        % update best inlier
        inlier_ind = inlier;
    end
end
tps_x = est_tps(x1(inlier_ind), y1(inlier_ind), x2(inlier_ind));
tps_y = est_tps(x1(inlier_ind), y1(inlier_ind), y2(inlier_ind));
end
