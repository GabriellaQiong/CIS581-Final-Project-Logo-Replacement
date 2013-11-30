function [matchedPts1, matchedPts2, indexPairs] = logo_detect_MSER(imRef, imCmp,  verbose, surf)
% FEAT_DESC extracts feature descriptor

% INPUT
% imRef, imCmp = uint8 HxW array with values in the range 0-255. 
% verbose      = flag whether to show details

% OUTPUT
% matchedPts1, matchedPts2  = matched pair points
% indexPairs                = the indices of matched pairs

% Written by Qiong Wang at University of Pennsylvania
% Nov. 28th, 2013 ------ the Lonely Thanks Giving Day :(

% % Initialize
% if nargin < 4
%     surf    = false;
% end
% if nargin < 3
%     verbose = false;
% end
% 
% I1 = rgb2gray(imRef);
% I2 = rgb2gray(imCmp);
% 
% % MSER find features
% pts1 = detectMSERFeatures(I1);
% pts2 = detectMSERFeatures(I2); 
% 
% if surf
%     % Find the SURF features.
%     pts1 = detectSURFFeatures(I1);
%     pts2 = detectSURFFeatures(I2);
% end
% 
% % Extract the features.
% [f1, vpts1] = extractFeatures(I1, pts1);
% [f2, vpts2] = extractFeatures(I2, pts2);
% 
% % Retrieve the locations of matched points. The SURF featurevectors are already normalized.
% indexPairs = matchFeatures(f1, f2, 'Prenormalized', true) ;
% matchedPts1 = vpts1(indexPairs(:, 1));
% matchedPts2 = vpts2(indexPairs(:, 2));
% 
% if ~verbose
%     return;
% end
% 
% figure(); 
% showMatchedFeatures(I1,I2,matchedPts1,matchedPts2,'montage');
% legend('matched points 1','matched points 2');

% end

Ia = uint8(rgb2gray(Iref)) ;
Ib = uint8(rgb2gray(Icmp)) ;

[ra,fa] = vl_mser(I,'MinDiversity',0.7,'MaxVariation',0.2,'Delta',10) ;
[rb,fb] = vl_mser(I,'MinDiversity',0.7,'MaxVariation',0.2,'Delta',10) ;

[matches, scores] = vl_ubcmatch(fa, fb);

figure(1) ; clf ;
imagesc(cat(2, Ia, Ib));
axis image off ;
vl_demo_print('mser_match_1', 1);

figure(2) ; clf ;
imagesc(cat(2, Ia, Ib));

xa = ra(1, matches(1,:));
xb = rb(1, matches(2,:)) + size(Ia,2);
ya = ra(2, matches(1,:));
yb = rb(2,matches(2,:));

hold on ;
h = line([xa ; xb], [ya ; yb]);
set(h, 'linewidth', 1, 'color', 'b');

vl_plotframe(ra(:,matches(1,:)));
rb(1,:) = fb(1,:) + size(Ia,2);
vl_plotframe(rb(:,mathces(2,:)));
axis image off ;