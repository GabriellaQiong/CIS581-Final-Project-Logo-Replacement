function [frame, desc] = my_sift(im, varargin)
% [frame, desc] = MY_SIFT(im, varargin)
% peak_thresh   - obtaining fewer features as peak_thresh is increased.
% edge_thresh   - obtaining more features as edge_thresh is increased
% frame         - center f(1:2), scale f(3) and orientation f(4)
defaults.peak_thresh = 0;
defaults.edge_thresh = 10;
defaults.visual = false;
defaults.num_desc = 0;
options = propval(varargin, defaults);

% make gray
if size(im,3) > 1, img = rgb2gray(im) ; else img = im ; end

% make single
img = single(img);
% img = vl_imsmooth(single(img),0.1);

% use vl_sift
[frame, desc] = vl_sift(img, ...
    'PeakThresh', options.peak_thresh, ...
    'EdgeThresh', options.edge_thresh) ;

% visualize
if options.visual
    figure();
    imshow(im);
    h_frame = vl_plotframe(frame) ;
    set(h_frame, 'Color', 'm', 'LineWidth', 2) ;
    if options.num_desc > 0
        perm = randperm(size(desc, 2));
        sel = perm(1:min(options.num_desc, size(desc,2)));
        h_desc = vl_plotsiftdescriptor(desc(:,sel), frame(:,sel));
        set(h_desc, 'Color', 'g', 'LineWidth', 2) ;
    end
end

end