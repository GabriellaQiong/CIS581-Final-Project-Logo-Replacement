function [tps] = est_tps(x, y, target)
% [tps] = EST_TPS(x, y, target)
% x,y   - position in source image
% target - x or y in target image
% tps   - [a1; ax; ay; aw];

n = size(x,1);

% Calculate tps coefficients
lambda = 0.1;
D = bsxfun(@minus, x, x').^2 + bsxfun(@minus, y, y').^2;
K = D .* log(D);
K(isnan(K)) = 0;
P = [x, y, ones(size(x))];
A = [K + lambda*eye(n), P; P', zeros(3)];
B = [target; zeros(3,1)];
X = inv(A) * B;

% Extract coefficients
w  = X(1:n);
ax = X(n+1);
ay = X(n+2);
a1 = X(n+3);
tps = [a1; ax; ay; w];
end
