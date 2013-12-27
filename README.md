CIS581-Final-Project-Logo-Replacement
=====================================

Course Project for CIS 581 Computer Vision and Computational Photography at University of Pennsylvania

---
COMPILING THE SIFT LIBRARY
---
```
$ cd sift_vedaldi
$ make
```
---
WORKFLOW
---
process reference image -> detect SIFT descriptor -> generate codebook for reference image
-> generate votemap for destination image -> estimate tps parameters using RANSAC
-> get bounding box of reference logo in destination image -> carve out the logo and fill in background color
-> laplacian blending for better visual effect -> replace reference logo with our own logo

---
STRENGTH AND WEAKNESS
---

