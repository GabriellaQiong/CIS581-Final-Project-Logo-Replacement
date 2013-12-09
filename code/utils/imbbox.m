function [ul_corner, width, im_box] = imbbox(im, level, verbose)
% IMBBOX Calculate bounding box 
% Usage
% [ul_corner, width, im_box] = imbbox(im, level, verbose)
% ul_corner - [x, y]
% width     - [x_width, y_width]
% im_box    - cropped image
% level     - luminance level for im2bw, default 0.8
% verbose   - for debugging set to true

% Check inputs
if nargin == 1 || isempty(level), level = 0.8; end
if nargin < 3, verbose = false; end
offset = 10;
% Convert image to bw
img = im2gray(im);
bw = ~im2bw(im2gray(img), level);
% Calculate bounding box
[r, c] = find(bw);
ul_corner = [min(c), min(r)];
lr_corner = [max(c), max(r)];
width = lr_corner - ul_corner + 1;
% Add offest
ul_corner = ul_corner - offset;
lr_corner = lr_corner + offset;
width = width + 2*offset;
% Extract image
im_box = im(ul_corner(2):lr_corner(2), ul_corner(1):lr_corner(1), :);
if ~verbose
    return
end

% Visualization
figure()
subplot(2,2,1)
imshow(im)
title('Original image')
subplot(2,2,2)
imshow(bw)
title('Black white image')
subplot(2,2,3)
imshow(img)
plot_bbox(ul_corner, width);
title('Image with bounding box')
subplot(2,2,4)
imshow(im_box)
title('Image in bounding box')
xlabel(num2str(width(1)))
ylabel(num2str(width(2)))
end
