function Iout = logo_replacement_wrapper(Iall, Iref, Inew, outputDir, indices, verbose)
% LOGO_REPLACEMENT_WRAPPER wraps logo replacement.

% INPUT
% Iall    -- Test dataset cell images
% Iref    -- Reference image
% Inew    -- New logo to replace the reference
% indices -- Indices row array (empty to show all)
% verbose -- Whether to show details

% OUTPUT
% Iout    -- Output cell images 

if nargin < 5
    verbose = false;
end

if nargin < 4 || isempty(indices)
    indices = 1 : numel(Iall);
end

if length(indices) == 1
    indices = indices : indices;
end

% Initialize and add black background to reference image
Iout      = cell(numel(Iall), 1);
center    = 1/2*[size(Iref,2), size(Iref,1)];
IrefBlack = improc(Iref);         
traceFlag = false;

for imIdx = indices
    fprintf('Processing image %d ... \n', imIdx);    
    % Detect sift descriptor
    [frames1, frames2, desc1, desc2, matches] = logo_detect_SIFT(IrefBlack, Iall{imIdx});
    
    % Generate codebook for reference image
    codebook = gen_codebook(center, frames1, Iref);
    % Create votemap for multiple instance detection
    [hypoCenter, voters, inds] = gen_votemap(codebook, 3, frames2, desc1, desc2, Iall{imIdx}, verbose);
    
    for centerIdx = 1 : size(hypoCenter, 2) * (traceFlag) + ~traceFlag
        if traceFlag
            % Use the matching points traced back
            frames2 = voters{centerIdx};
            matches = siftmatch(desc1, desc2(:, inds{centerIdx}));
        end
        
        % Extract matching points
        p1 = [frames1(1,matches(1,:)); frames1(2,matches(1,:))];
        p2 = [frames2(1,matches(2,:)); frames2(2,matches(2,:))];
        [p1, p2] = fix_match(p1, p2);
        % Estimate TPS via RANSAC
        thresh = 1.2; % RANSAC tps threshhold
        [tpsX, tpsY, inlierInd, continueFlag] = ransac_tps(p1(1,:), p1(2,:), p2(1,:), p2(2,:), thresh);
        
        if continueFlag
            fprintf('Descriptors are not enough for image %d \n', imIdx);
            continue;
        end
        
        if verbose
            ransac_plot(IrefBlack, Iall{imIdx}, p1, p2, inlierInd, matches);
        end
        
        try
            % Replace logo
            [Iout{imIdx}, h2] = logo_replace(Iall{imIdx}, Iref, Inew, tpsX, tpsY, p1(:, inlierInd), p2(:, inlierInd), verbose);
            fig_save(h2, fullfile(outputDir, sprintf('upenn_%02d', imIdx)), 'png');
        catch
            warning('Something wrong')
            continue
        end
    end
end