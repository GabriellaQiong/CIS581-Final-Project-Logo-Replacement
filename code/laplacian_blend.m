function Iblend = laplacian_blend(Ivex, Icave, Imask, verbose)
% LAPLACIAN_BLEND()

% INPUT
% Ivex    -- Image with logo shape, average color of background
% Icave   -- Image with original background carved logo out
% verbose -- Whether to show details

% OUTPUT
% Iblend -- output blend image

if nargin < 4
    verbose  =  false;
end

% Parameters
level = 5;
maska = Imask;
maskb = 1 - maska;
blurh = fspecial('gauss', 30, 20); % feather the border
maska = imfilter(maska, blurh,'replicate');
maskb = imfilter(maskb, blurh,'replicate');
figure,imshow(maska);
figure,imshow(maskb);
% Generate pyramid
limga = pyr_gen(Ivex, 'lap',level); % the Laplacian pyramid
limgb = pyr_gen(Icave,'lap',level);

% Build and reconstruct pyramid
limgo  = pyr_build(limga, limgb, maska, maskb, level);
Iblend = im2uint8(pyr_recon(limgo));

if ~verbose
    return;
end

figure,imshow(Iblend) % blend by pyramid

end