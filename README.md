CIS581-Final-Project-Logo-Replacement
=====================================

Course Project for CIS 581 Computer Vision and Computational Photography at University of Pennsylvania

Chao Qu, Qiong Wang

---
COMPILING THE SIFT LIBRARY
---
```
$ cd sift_vedaldi
$ make
```
---
DESCRIPTION OF CODES
---
The codes are all in the *code* folder and you can change the following flags to change the mode you want (Note: there are also several other parameters in the codes, you can also try to change that after you folk our codes :))

1. 12 line in **run_script**, the flag to determine whether to show the details
```
verbose = false;
```

2. 20 line in **logo_replace**, the flag to choose the blending method
```
blend = 0;  % 0 -- default(laplacian blending), 1 -- alpha blending
```

3. 31 line in **ransac_tps** in folder *tps*, the iteration number for RANSAC
```
iter = 2000;
```

4. 20 line in **laplacian_blend** in folder *impyr* to change the filter parameters of the mask
```
blurh = fspecial('gauss', 30, 20);
```

---
WORKFLOW
---
1. Process reference image
2. Detect SIFT descriptor
3. Generate codebook for reference image
4. Generate votemap for destination image and estimate tps parameters using RANSAC
5. Get bounding box of reference logo in destination image and carve out the logo and fill in background color
6. Laplacian blending for better visual effect and replace reference logo with our own logo

---
STRENGTH AND WEAKNESS
---
In this project, we have implemented all the basic features of logo replacement and also started the multiple instance detection and replacement. The detection part for multiple instances works well in most of the cases while the traceback for voters codes is still under debugging. We will keep on working on that and update the newest results. Thank you :)

---
ACKNOWLEDGE
---
Thanks a lot to Professor Jianbo Shi, TAs Jihua Huang and Yedong Niu for all your help for this project. Thank you !
