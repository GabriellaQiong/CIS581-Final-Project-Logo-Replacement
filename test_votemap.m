
load('votemap.mat')
blurh   = fspecial('gauss', 30, 5); % feather the border
votemap = imfilter(votemap, blurh,'replicate');
votemap = votemap / max(votemap(:));
binmap = imregionalmax(votemap);
votemap(votemap < 0.5) = 0;
votemap_bin = imregionalmax(votemap);
[r, c] = find(votemap_bin);
figure(); imagesc(votemap_bin);colormap('gray');
axis image; axis ij; title('Votemap');
figure(); colormap('jet'); imagesc(votemap); colorbar;
figure(); imshow(Iall{19})
hold on; plot(c, r, 'r+', 'MarkerSize', 10, 'LineWidth' ,3)