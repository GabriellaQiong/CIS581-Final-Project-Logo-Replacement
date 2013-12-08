function [ img ] = im2gray( im )
%IM2GRAY Convert image to grayscale from rgb

if size(im, 3) == 3
    img = rgb2gray(im);
elseif size(im, 3) == 1;
    img = im;
else
    error('Wrong image dimension.')
end

end

