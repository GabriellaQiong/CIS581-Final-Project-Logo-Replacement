function [X, Y] = apply_tps_qiong(x, y, tps_x, tps_y, x_c, y_c)
% [X, Y] = APPLY_TPS(x, y, tps_x, tps_y, x_c, y_c)
% x,y     - source position n x 1
% X,Y     - destination position n x 1
% tps_x,y - tps coefficients n x 1
% x_c,y_c - control points

% get coefficients
a1_x = tps_x(1);      a1_y = tps_y(1);
ax_x = tps_x(2);      ax_y = tps_y(2);
ay_x = tps_x(3);      ay_y = tps_y(3);
w_x  = tps_x(4:end);  w_y = tps_y(4:end);

% calculate U
pts_num     = size(x_c, 1);
mat_diff    = @(vector, ctrl_pts_col) bsxfun(@minus, ctrl_pts_col, repmat(vector', pts_num, 1));
r_sqr       = mat_diff(x, x_c).^2 + mat_diff(y, y_c).^2 + eps;
U           = r_sqr.* log(r_sqr);


% apply_tps
X  = bsxfun(@plus, a1_x, [x, y] * [ax_x; ay_x] + U' * w_x);
Y  = bsxfun(@plus, a1_y, [x, y] * [ax_y; ay_y] + U' * w_y);
end