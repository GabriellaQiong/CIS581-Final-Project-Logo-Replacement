function [Im, theta] = myGradient(I, sigma, param)
% MYGRADIENT calculate image gradient

if nargin < 3
    param = 'replicate';
end

% Determine filter size
Gsize = 8*ceil(sigma);
G     = fspecial('gaussian', Gsize, sigma);

[dGx, dGy] = gradient(G);
Ix         = imfilter(I, dGx, 'conv', param);
Iy         = imfilter(I, dGy, 'conv', param);
Im         = hypot(Ix, Iy);
theta      = cart2pol(Iy, Ix); % double check
end