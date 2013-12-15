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

Iout  = cell(numel(Iall), 1);

for imIdx = indices
    fprintf('Processing image %d ... \n', imIdx);
    IrefBlack = improc(Iref);
%     IrefBlack = Iref;
    [frames1, frames2, matches] = logo_detect_SIFT(IrefBlack, Iall{imIdx});
    p1 = [frames1(1,matches(1,:)); frames1(2,matches(1,:))];
    p2 = [frames2(1,matches(2,:)); frames2(2,matches(2,:))];
    thresh = 1;
    [tpsX, tpsY, inlierInd, continueFlag] = ransac_tps(p1(1,:), p1(2,:), p2(1,:), p2(2,:), thresh);
    if continueFlag
        fprintf('Descriptors are not enough for image %d \n', imIdx);
        continue;
    end
    
    if verbose
        h1 = ransac_plot(IrefBlack, Iall{imIdx}, p1, p2, inlierInd, matches);     
        fig_save(h1, fullfile(outputDir, sprintf('ransac_img%02d', imIdx)), 'png');
    end
    
    try
        [Iout{imIdx}, h2] = logo_replace(Iall{imIdx}, Iref, Inew, tpsX, tpsY, p1(:, inlierInd), p2(:, inlierInd), verbose);
        fig_save(h2, fullfile(outputDir, sprintf('replace_img%02d', imIdx)), 'png');
    catch
        warning('Something wrong')
        continue
    end
end
