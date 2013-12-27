function [voters, indices] = trace_original(hypoCenter, codebook, frames2, best, imgSz, verbose)
% TRACE_ORIGINAL() traces back the original voters given hypothesis centers

% INPUT
% hypo_center -- Hypothesis center 2 x n vector, n hypothesis centers
% codebook    -- 4 x m vector, m descriptor points
% frames2     -- Descriptor points in destination image
% best        -- Best matches m x 1 cell, m descriptors
% imgSz       -- Image size, [nr, nc] 
% verbose     -- Whether to show details

% OUTPUT
% voters      -- Voters for hypothesis center n x 1 cell, inside cell 2 x m
%                [x_orig; y_orig] 2 x m

% Initialize
if nargin < 5
    verbose = false;
end
centerNum = size(hypoCenter, 2);
descNum   = numel(best);
voters    = cell(centerNum, 1);
indices   = cell(centerNum, 1);
dist      = zeros(1, descNum);
thresh    = 100;

% Function handle
dist_check = @(vote, center) bsxfun(@minus, vote(1, :), center(1)').^2 + bsxfun(@minus, vote(2, :), center(2)').^2;

% Loop
for centerIdx = 1 : centerNum
    count = 0;
    for descIdx = 1 : descNum
        [voteX, voteY]  = vote(frames2(:, descIdx), codebook(:, best{descIdx}));
        okIndices = voteX > imgSz(2) | voteX < 1 | voteY > imgSz(1) | voteY < 1;
        voteX(okIndices) = [];
        voteY(okIndices) = [];
        dist(descIdx) = sum(dist_check([voteX; voteY], hypoCenter(:, centerIdx)) < thresh.^2);
        if dist(descIdx) > 0
            count = count + 1;
            voters{centerIdx}(:, count) = frames2(:, descIdx);
        end
    end
    indices{centerIdx} = dist > 0;
end

if ~verbose
    return;
end

end