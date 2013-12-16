function [Iout, boundPt, If] = improc(Iref, verbose, dilate)
% IM_PREPROCESS() make the white background to be black

% INPUT
% Iref    -- H x W x 3, 0 ~ 255 unit8 reference image with white background 
% Iout    -- H x W x 3, 0 ~ 255 unit8 reference image with black background
% dilate  -- Whether to dilate the image
% verbose -- Whether to show details, verbose == 2 show convex hull points

% OUTPUT
% boundPt -- n x 2 boundary points of convex hull

if nargin < 3
    dilate  = 0;
end

if nargin < 2
    verbose = false;
end

Ig   = rgb2gray(Iref);
Ib   = ~ im2bw(Ig, 0.9);
If   = imfill(Ib, 'holes'); 
if dilate
    If   = imdilate(If, ones(dilate));
end
Ibin = uint8(cat(3, If, If, If));
Iout = Ibin .* Iref;

% Convex hull
[y, x]  = ind2sub(size(Ig), find(If));
k       = convhull(x, y, 'simplify', true);
boundPt = [x(k), y(k)];

if ~verbose
    return
end

figure();
subplot(1, 3, 1); imshow(Iref); axis image;
title('Image with white background');
subplot(1, 3, 2); imshow(Iout); axis image;
title('Image with black background');
subplot(1, 3, 3); imshow(If); axis image;
title('Image mask');

% Convex hull display
if verbose ~= 2
    return; 
end
subplot(1, 3, 2);
hold on;
plot(boundPt(:, 1), boundPt(:, 2), 'r.'); 
plot(boundPt(:, 1), boundPt(:, 2), 'r-', 'LineWidth', 2);
hold off
end