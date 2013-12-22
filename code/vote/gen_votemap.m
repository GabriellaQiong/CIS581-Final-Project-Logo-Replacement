function [hypoCenter, voters, votemap] = gen_votemap(codebook, K, frames2, desc1, desc2, Ides, verbose)
% GEN_HEATMAP generates heatmap and find the hypothesis centers

% INPUT
% codebook -- Codebook of the reference image
% K        -- Number of K nearest neighbors
% frame1/2 -- Frame in the destination image
% desc1/2  -- Corresponding descriptors for input frames (1--ref, 2--des)
% Iref/des -- Reference and destination images
% verbose  -- Whether to show details

% OUTPUT
% hypoCenter -- Hypothesis centers 2 x n [x; y]1 x n
% voters     -- Traced back voters for hypoCenter
% votemap    -- Vote map

% Initialize
if nargin < 7
    verbose = false;
end
numDesc     = size(frames2, 2);
[nr, nc, ~] = size(Ides);
votemap     = zeros(nr, nc);

for descIdx = 1 : numDesc
    % Find best K matches
    [matches, dist] = siftmatch(desc1, desc2(:, descIdx));
    [~, idx]        = sort(dist);
    best            = matches(:, idx(1:K));
    
    % Vote the best K matches
    [voteX, voteY]  = vote(frames2(:, descIdx), codebook(:, best));
    voteX(voteX > nc | voteX < 1) = [];
    voteY(voteY > nr | voteY < 1) = [];
    votemap(voteY, voteX)  = votemap(voteY, voteX) + 1;
end

hypoCenter = 1;
voters     = 1;

% votemap(votemap < 0.2) = 0;

save('votemap.mat', 'votemap')
blurh   = fspecial('gauss', 10, 5); % feather the border
votemap = imfilter(votemap, blurh,'replicate');
votemap = votemap / max(votemap(:));
% votemap(votemap < 0.2) = 0;
if ~ verbose
    return;
end
figure(55); colormap('jet'); imagesc(votemap); colorbar;
axis image; axis ij; title('Votemap');

end
