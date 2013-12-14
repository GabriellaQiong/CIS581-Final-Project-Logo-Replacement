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
InewG = im2gray(Inew);
p1In  = p1In';
p2In  = p2In';
blendFrac = 0;

% Handle the bounds
[yDes, xDes, ~]    = size(Ides);
[yRef, xRef, ~]    = size(Iref);
[yNew, xNew, ~]    = size(Inew);

xBorder = [transpose(1 : xRef); ones(yRef, 1) * xRef; transpose(1 : xRef); ones(yRef, 1)];
yBorder = [ones(xRef, 1); transpose(1 : yRef); ones(xRef, 1) * yRef; transpose(1 : yRef)];
[xBound, yBound]   = apply_tps(xBorder, yBorder, tpsX, tpsY, p1In(:, 1), p1In(:, 2));

figure();imagesc(Ides);hold on;
plot(xBound, yBound,'r.');

minBound           = round(min([xBound, yBound], [], 1));
maxBound           = round(max([xBound, yBound], [], 1));

plot([minBound(1) minBound(1) maxBound(1) maxBound(1) minBound(1)],...
[minBound(2) maxBound(2) maxBound(2) minBound(2) minBound(2)],'b', 'LineWidth' ,2)

[xMatrix, yMatrix] = meshgrid(minBound(1) : maxBound(1), minBound(2) : maxBound(2));
xArray             = reshape(xMatrix, [numel(xMatrix), 1]);
yArray             = reshape(yMatrix, [numel(yMatrix), 1]);
tpsXinv            = est_tps(p2In(:, 1), p2In(:, 2), p1In(:, 1));
tpsYinv            = est_tps(p2In(:, 1), p2In(:, 2), p1In(:, 2));
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

minMosaic   = [1 1];
maxMosaic   = [xDes, yDes];
rangeMosaic = maxMosaic - minMosaic + 1;
Iout        = uint8(zeros(rangeMosaic(2), rangeMosaic(1), 3));
minDes      = 1 - (minMosaic ~= 1) .* minMosaic;
Iout(minDes(2) : (minDes(2) + yDes - 1), minDes(1) : (minDes(1) + xDes - 1), :) = Ides;

% Remove non-effective pixels
effectIdx = xRefArr >= 1 & xRefArr <= xNew & yRefArr >= 1 & yRefArr <= yNew;
xArray    = xArray(effectIdx);
yArray    = yArray(effectIdx);
xRefArr   = xRefArr(effectIdx);
yRefArr   = yRefArr(effectIdx);

for i = 1 : length(xArray)
    % Skip the white background
    if InewG(yRefArr(i), xRefArr(i)) >= 240
       continue; 
    end
    
    % Alpha Blending
    Iout(yArray(i) - minMosaic(2) + 1, xArray(i) - minMosaic(1) + 1, :) = ...
        blendFrac * Iout(yArray(i) - minMosaic(2) + 1, xArray(i) - minMosaic(1) + 1, :) ...
        + (1 - blendFrac) * Inew(yRefArr(i), xRefArr(i), :);
end
Iout = im2uint8(Iout);

if ~verbose
   return; 
end

h = figure(44); clf;
imagesc(Iout); axis image; title('Result after replacement');

end