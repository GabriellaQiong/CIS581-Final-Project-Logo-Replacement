function  tps = est_tps_qiong(x, y, target_val, lambda)
% EST_TPS estimates parameters for thin-plate_spline model
% [tps] = EST_TPS(x, y, target)
% x,y    - position in source image n x 1
% target - x or y in target image  n x 1
% tps    - [a1; ax; ay; aw];
% lambda - margin value for inverse

% Initialize
pts_num = length(x);
pts     = [x, y];
if nargin < 4
    lambda  = 0.01;
end

% Function handles
mat_diff = @(vector) repmat(vector, 1, pts_num) - transpose(repmat(vector, 1, pts_num));
U        = @(r_sqr) r_sqr.* log(r_sqr);

% Matrices and vectors
P = [ones(pts_num, 1), pts];
K = U(mat_diff(pts(:,1)).^2 + mat_diff(pts(:,2)).^2 + eps);
A = [K + lambda*eye(pts_num), P; P', zeros(3)];
v = [target_val; zeros(3,1)];

% Compute and output results
coef = A \ v;
tps  = coef([end - 2, end - 1, end, 1 : end - 3]);
end