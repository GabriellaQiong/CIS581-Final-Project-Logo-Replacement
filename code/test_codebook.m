%
[frames1, frames2, matches] = logo_detect_SIFT(Iref, Iall{1}, 1);
center = 1/2*[size(Iref,2), size(Iref,1)];
codebook = gen_codebook(center, frames1);
figure()
imshow(Iref)
hold on
plot(frames1(1,:), frames1(2,:), 'mo')
plot(center(1), center(2), 'b+', 'LineWidth', 2)
%line(codebook', bsxfun(@times, center', ones(2, length(codebook))), 'Color', 'b')
line([frames1(1,:);frames1(1,:)+codebook(:,1)'], ...
     [frames1(2,:);frames1(2,:)+codebook(:,2)'], 'Color', 'c')
hold off
