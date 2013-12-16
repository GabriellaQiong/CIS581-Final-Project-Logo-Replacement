function [Iout, h] = logo_replace(Ides, Iref, Inew, tpsX, tpsY, p1In, p2In, verbose)
% TPS_REPLACE replaces the reference logo with the new one

% INPUT
% Ides       --- Image with reference logo to be replaced uint8 HxWx3 , 0-255.
% Inew       --- New logo image uint8 HxWx3, 0-255. 
% tpsX, tpsY --- TPS coefficients

% OUTPUT
% Iout       --- Output image uint8 HxWx3 array with reference logo replaced

% Initialize
if nargin < 7
    verbose = false;
end
p1New = mapcpt(Iref, Inew, p1In);
p1New = p1New';
p1In  = p1In';
p2In  = p2In';
blend = 0;        %  0 -- pyramid, 1 -- alpha 
frac  = 0;

% Handle the bounds
[yDes, xDes, ~]    = size(Ides);
[yRef, xRef, ~]    = size(Iref);
[yNew, xNew, ~]    = size(Inew);

xBorder = [transpose(1 : xRef); ones(yRef, 1) * xRef; transpose(1 : xRef); ones(yRef, 1)];
yBorder = [ones(xRef, 1); transpose(1 : yRef); ones(xRef, 1) * yRef; transpose(1 : yRef)];
[xBound, yBound]   = apply_tps(xBorder, yBorder, tpsX, tpsY, p1In(:, 1), p1In(:, 2));

minBound           = round(min([xBound, yBound], [], 1));
maxBound           = round(max([xBound, yBound], [], 1));

[xMatrix, yMatrix] = meshgrid(minBound(1) : maxBound(1), minBound(2) : maxBound(2));
xArray             = reshape(xMatrix, [numel(xMatrix), 1]);
yArray             = reshape(yMatrix, [numel(yMatrix), 1]);
tpsXinv            = est_tps(p2In(:, 1), p2In(:, 2), p1New(:, 1));
tpsYinv            = est_tps(p2In(:, 1), p2In(:, 2), p1New(:, 2));
[xRefArr, yRefArr] = apply_tps(xArray, yArray, tpsXinv, tpsYinv, p2In(:, 1), p2In(:, 2));
xRefArr            = round(xRefArr);
yRefArr            = round(yRefArr);

% Handle bounds for stitched image
% minMosaic   = min([minBound; [1 1]], [], 1);
% maxMosaic   = max([maxBound; [xDes, yDes]], [], 1);
% rangeMosaic = maxMosaic - minMosaic + 1;
% Iout        = uint8(zeros(rangeMosaic(2), rangeMosaic(1), 3));
% minDes      = 1 - (minMosaic ~= 1) .* minMosaic;
% Iout(minDes(2) : (minDes(2) + yDes - 1), minDes(1) : (minDes(1) + xDes - 1), :) = Ides;

% minMosaic   = [1 1];
% maxMosaic   = [xDes, yDes];
% rangeMosaic = maxMosaic - minMosaic + 1;
% Iout        = uint8(zeros(rangeMosaic(2), rangeMosaic(1), 3));
% minDes      = 1 - (minMosaic ~= 1) .* minMosaic;
% Iout(minDes(2) : (minDes(2) + yDes - 1), minDes(1) : (minDes(1) + xDes - 1), :) = Ides;

minMosaic = [1 1];
Iout      = Ides;
Imask     = zeros(yDes, xDes, 3);

% Remove non-effective pixels
effectIdx = xRefArr >= 1 & xRefArr <= xNew & yRefArr >= 1 & yRefArr <= yNew;
xArray    = xArray(effectIdx);
yArray    = yArray(effectIdx);
xRefArr   = xRefArr(effectIdx);
yRefArr   = yRefArr(effectIdx);

% Debugging
figure();imagesc(Ides);axis image; hold on;
plot(xBound, yBound,'r.');
plot([minBound(1) minBound(1) maxBound(1) maxBound(1) minBound(1)],...
[minBound(2) maxBound(2) maxBound(2) minBound(2) minBound(2)],'b', 'LineWidth' ,2)
[~, boundPtRef, ~]  = improc(Iref);
[~, boundPtRefBig, ~] = improc(Iref, 0, 10);
[~, ~, ImaskNew]  = improc(Inew);
[xBoundPtSrc, yBoundPtSrc] =  apply_tps(boundPtRef(:,1), boundPtRef(:,2), tpsX, tpsY, p1In(:, 1), p1In(:, 2));
[xBoundPtBigSrc, yBoundPtBigSrc] =  apply_tps(boundPtRefBig(:,1), boundPtRefBig(:,2), tpsX, tpsY, p1In(:, 1), p1In(:, 2));
plot(xBoundPtSrc, yBoundPtSrc, 'm.'); 
plot(xBoundPtSrc, yBoundPtSrc, 'm-', 'LineWidth', 2);
plot(xBoundPtBigSrc, yBoundPtBigSrc, 'g.'); 
plot(xBoundPtBigSrc, yBoundPtBigSrc, 'g-', 'LineWidth', 2);
hold off

% Carve out ref logo
[X, Y] = meshgrid(1:xDes, 1:yDes);
% Get average background pixel
k = convhull(xBound, yBound, 'simplify', true);
xBoundConv = xBound(k);
yBoundConv = yBound(k);
% IN_box = inpolygon(X, Y, xBoundConv, yBoundConv);
IN_logo = inpolygon(X, Y, xBoundPtSrc, yBoundPtSrc);
IN_box = inpolygon(X, Y, xBoundPtBigSrc, yBoundPtBigSrc);
% pixelVal = [0;0;0];
pixelValR = [];
pixelValG = [];
pixelValB = [];
n = 0;
for i = 1:numel(IN_box)
    if ~IN_logo(i) && IN_box(i)
        n = n + 1;
%         pixelVal = pixelVal + double(squeeze(Ides(Y(i), X(i), :)));
        pixelValR(end+1) = double(squeeze(Ides(Y(i), X(i), 1)));
        pixelValG(end+1) = double(squeeze(Ides(Y(i), X(i), 2)));
        pixelValB(end+1) = double(squeeze(Ides(Y(i), X(i), 3)));
    end
end
% pixelVal = uint8(pixelVal/n);
pixelVal = [median(pixelValR), median(pixelValG), median(pixelValB)];
Ivex     = uint8(cat(3, pixelVal(1) * ones(yDes, xDes), pixelVal(2) * ones(yDes, xDes), pixelVal(3) * ones(yDes, xDes)));

% Carve out ref logo
for i = 1:numel(IN_box)
    if IN_box(i)
        Iout(Y(i), X(i), :) = pixelVal;
        Imask(Y(i), X(i), :) = 1;
    end
end

% figure()
% imshow(Iout)

if ~blend
    Iout = laplacian_blend(Ivex, Iout, Imask);
    figure(); imshow(Iout);
    % figure(); imshow(Ivex);
end

for i = 1 : length(xArray)
    % Skip the white background
    if ~ImaskNew(yRefArr(i), xRefArr(i))
       continue; 
    end

    if blend
        % Alpha Blending
        Iout(yArray(i) - minMosaic(2) + 1, xArray(i) - minMosaic(1) + 1, :) = ...
            frac * Iout(yArray(i) - minMosaic(2) + 1, xArray(i) - minMosaic(1) + 1, :) ...
            + (1 - frac) * Inew(yRefArr(i), xRefArr(i), :);
    else
        % Pyramid Blending
        Iout(yArray(i) - minMosaic(2) + 1, xArray(i) - minMosaic(1) + 1, :) = ...
            Inew(yRefArr(i), xRefArr(i), :);
    end
end
Iout = im2uint8(Iout);

if ~verbose
   return; 
end

h = figure(44); clf;
imagesc(Iout); axis image; title('Result after replacement');

end
