function varargout = mapcpt(Iref, Inew, cpt1, verbose)
% varargout = MAPCPT(im1, im2, cpt1)
% im1, im2 - original images
% cpt1     - 2 x n control points in referene image

if nargin < 4
    verbose = false;
end

[r1, c1, ~] = size(Iref);
[r2, c2, ~] = size(Inew);

S    = [c2/c1 0; 0 r2/r1];
cpt2 = S * cpt1;

% Output
if nargout == 2
    varargout{1} = cpt2(1, :);
    varargout{2} = cpt2(2, :); 
elseif nargout == 1
    varargout{1} = cpt2;
end

if ~verbose
    return
end

figure();
subplot(1,2,1);
imshow(Iref);
hold on;
h_cpt1 = plot(cpt1(1,:), cpt1(2,:), '+');
set(h_cpt1, 'Color', 'b', 'MarkerSize', 5, 'LineWidth', 2);
hold off;
subplot(1,2,2);
imshow(Inew);
hold on;
h_cpt2 = plot(cpt2(1,:), cpt2(2,:), '+');
set(h_cpt2, 'Color', 'r', 'MarkerSize', 5, 'LineWidth', 2);
hold off;

end
