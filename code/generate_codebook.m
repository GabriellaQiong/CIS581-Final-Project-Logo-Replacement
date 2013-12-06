function codebook = generate_codebook(Iref, verbose)
% GENERATE_CODEBOOK generate the codebook of HoG descriptors of given
% reference image.

% INPUT
% Iref    = uint8 HxW array with values in the range 0-255. 
% verbose = flag whether to show details

% OUTPUT
% codebook = struct containing

% Written by Qiong Wang at University of Pennsylvania
% Dec.4th, 2013

% Initialize
if nargin < 2
    verbose = false;
end

% Preprocessing of reference image
if size(Iref, 3) == 3
    Ig = rgb2gray(Iref);
else
    Ig = Iref;
end
Iin = single(Ig);

% Initialize the centroid
centerX = ceil(size(Iin, 1)/2);
centerY = ceil(size(Iin, 2)/2);

% Generate SIFT descriptors
[f, d] = my_sift(Iin);

% Find the arrows for each descriptors with orientation and scale.

% Save variables in a struct
codebook.HoG       = HoG;
codebook.weights   = weights;
codebook.samplePos = samplePos;
codebook.offset    = offset;

% Show details
if ~verbose
    return;
end

end