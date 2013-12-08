% test_imbbox
subplot(1,2,1)
imshow(Iref)
[ul_corner, width, im_box] = imbbox(Iref);
plot_bbox(ul_corner, width)

subplot(1,2,2)
imshow(Inew)
[ul_corner, width, im_box] = imbbox(Inew);
plot_bbox(ul_corner, width)