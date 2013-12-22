function codebook = gen_codebook(center, frames, Iref, verbose)

if nargin < 4
   verbose  = false; 
end

% initialize codebook
codebook = frames;

codebook(1:2,:) = bsxfun(@minus, center(:), frames(1:2,:));

if ~verbose
    return
end

figure()
imshow(Iref)
hold on
plot(frames(1,:), frames(2,:), 'mo')
plot(center(1), center(2), 'b+', 'LineWidth', 2)
%line(codebook', bsxfun(@times, center', ones(2, length(codebook))), 'Color', 'b')
line([frames(1,:);frames(1,:)+codebook(:,1)'], ...
    [frames(2,:);frames(2,:)+codebook(:,2)'], 'Color', 'c')
hold off

end
