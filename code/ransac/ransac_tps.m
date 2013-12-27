function [tps_x, tps_y, inlier_ind, continue_flag] = ransac_tps(x1, y1, x2, y2, thresh)
% RANSAC_TPS() RANSAC of TPS

% INPUT
% x1, y1, x2, y2 ---- 1 x n vector of stored matching points coordinates
% thresh         ---- threshold for RANSAC comparing with the distance

% OUTPUT
% tps_x, tps_y   ---- TPS coefficients
% inlier_ind     ---- inlier indices
% continue_flag  ---- whether to continue when with insufficient num_pts

% Initialize
if nargin < 5, thresh = 1.5; end

% Make column vector
y1 = y1(:); x1 = x1(:); 
y2 = y2(:); x2 = x2(:);

num_pts       = numel(y1);
ind           = 1:num_pts;
tps_x         = [];
tps_y         = [];
inlier_ind    = [];
continue_flag = 0;
num_cpt       = 4;
best_ssd      = Inf;

% Parameters
% percent_inlier = 0.95;  % stop when x% of the points are inlier
iter = 2000;             % ransac max iteration

% Check the num_pts more than 5
if num_pts < 4
   warning('The descriptors are not enough for TPS RANSAC, please check :)'); 
   continue_flag = 1;
   return;
end

% RANSAC
for i = 1:iter
    perm = randperm(num_pts);
    rand_ind = perm(1:num_cpt);
    % estimate tps from source(1) to destination(2)
    tps_x = est_tps_qiong(x1(rand_ind), y1(rand_ind), x2(rand_ind));
    tps_y = est_tps_qiong(x1(rand_ind), y1(rand_ind), y2(rand_ind));
    % apply tps on source(1) to corresponding points in destination(2)
%     [x2_c, y2_c] = apply_tps_qiong(x1(rand_ind), y1(rand_ind), tps_x, tps_y, x1(rand_ind), y1(rand_ind));
%     if size(unique([x2_c, y2_c], 'rows'), 1) < num_cpt
%         tps_x
%         tps_y
%         continue;
%     end
    [x2_est, y2_est] = apply_tps_qiong(x1, y1, tps_x, tps_y, x1(rand_ind), y1(rand_ind));
    dist = (x2_est - x2).^2 + (y2_est - y2).^2;
    current_ssd = sum(dist);
    inlier = ind(dist < thresh^2);
    num_inlier = length(inlier);
    
%     if size(unique([x2(inlier), y2(inlier)], 'rows'), 1) < num_inlier / 2
%         continue;
%     end

    if (num_inlier == length(inlier_ind) && (current_ssd < best_ssd)) || num_inlier > length(inlier_ind)
        % update best inlier
        inlier_ind = inlier;
        best_ssd = current_ssd;
    end
end
tps_x = est_tps_qiong(x1(inlier_ind), y1(inlier_ind), x2(inlier_ind));
tps_y = est_tps_qiong(x1(inlier_ind), y1(inlier_ind), y2(inlier_ind));
end
