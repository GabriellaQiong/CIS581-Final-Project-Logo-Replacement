function h = ransac_plot(im1, im2, p1, p2, inlier_ind, matches)
% RANSAC_PLOT() plots the result after ransac

h = figure(); clf;
o = size(im1, 2) ;
dh1 = max(size(im2,1) - size(im1,1), 0) ;
dh2 = max(size(im1,1) - size(im2,1), 0) ;
imagesc([padarray(im1, dh1, 'post'), padarray(im2, dh2, 'post')]) ;
axis image
fprintf('RANSAC: \t%d/%d\n', numel(inlier_ind), size(matches, 2))
hold on
% Plot matching lines
line([p1(1,:); p2(1,:) + o], [p1(2,:); p2(2,:)], 'Color', 'g')
line([p1(1,inlier_ind); p2(1,inlier_ind) + o], ...
     [p1(2,inlier_ind); p2(2,inlier_ind)], 'Color', 'm')
% Plot matching points
plot(p1(1,inlier_ind), p1(2,inlier_ind), 'r.')
plot(p2(1,inlier_ind) + o, p2(2,inlier_ind), 'r.')
hold off
title('Result after TPS RANSAC');
end