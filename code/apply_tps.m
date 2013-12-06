function [X, Y] = apply_tps(x, y, tps_x, tps_y, x_c, y_c)
% [X, Y] = APPLY_TPS(x, y, tps_x, tps_y, x_c, y_c)
% x,y   - source position 
% X,Y   - destination position
% tps_x,y - tps coefficients
% x_c,y_c - control points
% get coefficients
a1_x = tps_x(1);    a1_y = tps_y(1);
ax_x = tps_x(2);    ax_y = tps_y(2);
ay_x = tps_x(3);    ay_y = tps_y(3);
w_x  = tps_x(4:end); w_y = tps_y(4:end);

% calculate U
D = bsxfun(@minus, x_c', x).^2 + bsxfun(@minus, y_c', y).^2;
U = D .* log(D);
U(isnan(U)) = 0;

% apply_tps
X = a1_x + ax_x*x + ay_x*y + U*w_x;
Y = a1_y + ax_y*x + ay_y*y + U*w_y;

end
