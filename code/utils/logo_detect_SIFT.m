function [frames1, frames2, matches] = logo_detect_SIFT(I1, I2, verbose)
% [frames1, frames2, matches] = SIFT_DESC(I1, I2, verbose)

if nargin < 3
   verbose = false; 
end

I1c = im2double(I1);
I2c = im2double(I2);

% Make gray
I1  = im2gray(im2double(I1));
I2  = im2gray(im2double(I2));

% Smooth
I1  = imsmooth(I1,.2) ;
I2  = imsmooth(I2,.2) ;

% Normalize
I1  = I1-min(I1(:)) ;
I1  = I1/max(I1(:)) ;
I2  = I2-min(I2(:)) ;
I2  = I2/max(I2(:)) ;

% SIFT descriptors
S = 2;
fprintf('Computing frames and descriptors.\n') ;
[frames1, descr1, ~, dogss1] = sift( I1, 'Verbosity', 0, 'Threshold', ...
                                     0.005, 'NumLevels', S ) ;
[frames2, descr2, ~, dogss2] = sift( I2, 'Verbosity', 0, 'Threshold', ...
                                     0.005, 'NumLevels', S ) ;
                                 


fprintf('Computing matches.\n') ;
% By passing to integers we greatly enhance the matching speed (we use
% the scale factor 512 as Lowe's, but it could be greater without
% overflow)
descr1  = uint8(512*descr1) ;
descr2  = uint8(512*descr2) ;
tic ;
matches = siftmatch( descr1, descr2 ) ;
fprintf('Found %d matches in %.3f s\n', size(matches,2), toc) ;

if ~verbose
    return;
end
figure() ; clf ; plotss(dogss1) ; colormap gray ;
figure() ; clf ; plotss(dogss2) ; colormap gray ;
drawnow ;

figure() ; clf ;
tightsubplot(1,2,1) ; imagesc(I1) ; colormap gray ; axis image ;
hold on ;
h=plotsiftframe( frames1 ) ; set(h,'LineWidth',2,'Color','g') ;
h=plotsiftframe( frames1 ) ; set(h,'LineWidth',1,'Color','k') ;

tightsubplot(1,2,2) ; imagesc(I2) ; colormap gray ; axis image ;
hold on ;
h=plotsiftframe( frames2 ) ; set(h,'LineWidth',2,'Color','g') ;
h=plotsiftframe( frames2 ) ; set(h,'LineWidth',1,'Color','k') ;

figure() ; clf ;
plotmatches(I1c,I2c,frames1(1:2,:),frames2(1:2,:),matches, 'Stacking','v') ;
drawnow ;
end