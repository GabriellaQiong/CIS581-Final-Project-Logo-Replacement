function varargout = plot_bbox(ul_corner, width, im)
% PLOT_BBOX Plot bounding box object in image
if nargin < 3, hold on; end
if nargin == 3,
    imshow(im); hold on;
end

% Create bounding box
x = [ul_corner(1), ul_corner(1), ul_corner(1) + width(1), ul_corner(1) + width(1), ul_corner(1)];
y = [ul_corner(2), ul_corner(2) + width(2), ul_corner(2) + width(2), ul_corner(2), ul_corner(2)];
h_bbox = plot(x, y);
set(h_bbox, 'LineWidth' ,2, 'Color', 'm')
x_c = ul_corner(1) + ceil(width(1)/2);
y_c = ul_corner(2) + ceil(width(2)/2);
h_center = plot(x_c, y_c, '+');
set(h_center, 'LineWidth', 2, 'MarkerSize', 10, 'Color', 'c')
hold off
if nargout < 3, varargout{2} = h_center; end
if nargout < 2, varargout{1} = h_bbox; end
end