
load('votemap.mat')
blurh   = fspecial('gauss', 20, 5); % feather the border
votemap = imfilter(votemap, blurh,'replicate');
votemap = votemap / max(votemap(:));
binmap = imregionalmax(votemap);
votemap(votemap < 0.55) = 0;
figure(); colormap('jet'); imagesc(votemap); colorbar;
axis image; axis ij; title('Votemap');