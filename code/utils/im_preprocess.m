function Iout = im_preprocess(Iref)
% IM_PREPROCESS() make the white background to be black
%
% Iref -- H x W x 3 0 ~ 255 unit8 reference image with white background 
% Iout -- H x W x 3 0 ~ 255 unit8 reference image with black background

[nr, nc, ~] = size(Iref); 
Iedge       = bwboundaries((im2gray(Iref)));
% imshow(Iedge);
end