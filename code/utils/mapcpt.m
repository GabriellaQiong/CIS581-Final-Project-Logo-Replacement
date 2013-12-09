function varargout = mapcpt(Iref, Inew, cpt1, verbose)
% varargout = MAPCPT(im1, im2, cpt1)
% im1, im2 - original images
% cpt1     - 1 x n control points in referene image

if nargin < 4
    verbose = false;
end

% Compute the transform from reference image to new image
[ulPtRef, widthRef, ~] = imbbox(Iref, []);
[ulPtNew, widthNew, ~] = imbbox(Inew, []);
homo_coord = @(pt, width) ...
    [bsxfun(@plus, pt', bsxfun(@times, width', [0 1 1; 0 0 1])); 1 1 1];
newPts = homo_coord(ulPtNew, widthNew);
refPts = homo_coord(ulPtRef, widthRef);
Tf     = newPts / refPts;
cpt2 = Tf * [cpt1; ones(1, size(cpt1, 2))];

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
set(h_cpt1, 'MarkerSize', 5, 'LineWidth', 2);
hold off;
subplot(1,2,2);
imshow(Inew);
hold on;
h_cpt2 = plot(cpt2(1,:), cpt2(2,:), '+');
set(h_cpt2, 'MarkerSize', 5, 'LineWidth', 2);
hold off;

end
