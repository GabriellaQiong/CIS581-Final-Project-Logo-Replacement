startup
Icmp = Iall{1};
[fa, da] = vl_sift(single(rgb2gray(Iref))) ;
[fb, db] = vl_sift(single(rgb2gray(Icmp)));
[matches, scores] = vl_ubcmatch(da, db) ;

figure()
imshow(Iref)
[scores, idx] = sort(scores);
h1 = vl_plotframe(fa(:, matches(1,idx(1:5)))) ;
% h2 = vl_plotframe(fa) ;
% set(h1,'color','k','linewidth',2) ;


figure()
imshow(Icmp)
h1 = vl_plotframe(fb(:, idx(1:5)));
% h2 = vl_plotframe(fb) ;
% set(h1,'color','k','linewidth',2) ;

