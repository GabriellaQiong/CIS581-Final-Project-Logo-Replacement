function [hypoCenter, voters, inds] = gen_votemap(codebook, K, frames2, desc1, desc2, Ides, verbose)
% GEN_HEATMAP generates heatmap and find the hypothesis centers

% INPUT
% codebook      -- Codebook of the reference image
% K             -- Number of K nearest neighbors
% frame1/2      -- Frame in the destination image
% desc1/2       -- Corresponding descriptors for input frames (1--ref, 2--des)
% Iref/des      -- Reference and destination images
% verbose       -- Whether to show details

% OUTPUT
% hypoCenter    -- Hypothesis centers 2 x n [x; y]1 x n
% voters        -- Traced back voters for hypoCenter
% inds          -- Indices of descriptors for different hypocenters, m x 1 cell

% Initialize
if nargin < 7
    verbose = false;
end
numDesc     = size(frames2, 2);
[nr, nc, ~] = size(Ides);
votemap     = zeros(nr, nc);
best        = cell(numDesc, 1);
trace       = false;

for descIdx = 1 : numDesc
    % Find best K matches
    [matches, dist] = siftmatch(desc1, desc2(:, descIdx));
    [~, idx]        = sort(dist);
    best{descIdx}   = matches(1, idx(1:K));
    
    % Vote the best K matches
    [voteX, voteY]  = vote(frames2(:, descIdx), codebook(:, best{descIdx}));
    voteX(voteX > nc | voteX < 1) = [];
    voteY(voteY > nr | voteY < 1) = [];
    votemap(voteY, voteX)  = votemap(voteY, voteX) + 1;
end

blurh   = fspecial('gauss', 30, 5); % feather the border
votemap = imfilter(votemap, blurh,'replicate');
votemap = votemap / max(votemap(:));

% Display original votemap
figure(); colormap('jet'); imagesc(votemap); colorbar;
axis image; axis ij; title('Votemap');

% Process votemap to get hypocenter
votemap(votemap < 0.5) = 0;             % Set votemap threshhold
votemapBin = imregionalmax(votemap, 4); % Get a binary map with centers
[r, c]     = find(votemapBin);
hypoCenter = [r(:)'; c(:)'];
voters     = {};
inds       = [];
if trace
    % Trace back the voters for the hypocenter
    [voters, inds] = trace_original(hypoCenter, codebook, frames2, best, [nr, nc], verbose);
end

if ~ verbose
    return;
end

% Display markers on Ides to indicate detected logo
figure(); imagesc(Ides); hold on; axis image;
plot(c, r, 'r+', 'MarkerSize', 10, 'LineWidth' ,3)
hold off; title(sprintf('Detection results: %d instances found.', length(r)))
fprintf('Detection results: %d instances found.\n', length(r))
end
