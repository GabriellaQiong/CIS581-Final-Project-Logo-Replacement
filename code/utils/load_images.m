function [I, Iref, Inew]= load_images(path, visualize)
if nargin < 2, visualize = false; end
if nargin < 1, path = '../images/'; end

imHeight = 700;
imagePath = path;
imageExtension = {'.jpg', '.jpeg', '.png', '.tiff', '.bmp'};
fileListing = dir(imagePath);
numFile = length(fileListing);
I = cell(1, numFile);
Icount = 0;
for i = 1:numFile
    [~, fileName, fileExtension] = fileparts(fileListing(i).name);
    % check if file is image
    if any(strcmp(fileExtension, imageExtension))
        im = imread([imagePath fileListing(i).name]);
        
        if size(im, 2) > imHeight
            im = imresize(im, imHeight/size(im,2));
        end
        
        if strcmp(fileName, 'ref')
            Iref = im;
            continue;
        end
        
        if strcmp(fileName, 'logo')
            Inew = im;
            continue;
        end
        
        Icount = Icount + 1;
        I{Icount} = im;
        
        if visualize
            figure();
            imshow(I{Icount})
            drawnow
            title(fileListing(i).name)
        end
        
        fprintf([fileListing(i).name, '\n'])
    end
end

% Handle different size of logos
[rRef, cRef, ~] = size(Iref);
[rNew, cNew, ~] = size(Inew);
if rRef < rNew || cRef < cNew
    Inew = imresize(Inew, [rRef / rNew /1.2, cRef / cNew / 1.2]);
end
Inew = padarray(Inew, floor([(rRef-rNew) / 2, (cRef - cNew) / 2]), 'both', 'replicate');

I = I(1 : Icount);
fprintf('Load %d images. \n', Icount);
close all
end
