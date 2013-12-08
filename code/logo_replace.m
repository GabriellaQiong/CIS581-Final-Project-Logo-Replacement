function Iout = logo_replace(Ides, Inew, tpsX, tpsY, p1In, p2In, verbose)
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
InewG = rgb2gray(Inew);

% Handle the bounds
[yDes, xDes, ~]    = size(Ides);
[ySrc, xSrc, ~]    = size(Inew);
[xBound, yBound]   = apply_tps([1; 1; xSrc; xSrc], [1; ySrc; 1; ySrc], tpsX, tpsY, p1In(1, :), p1In(2, :));
minBound           = round(min([xBound, yBound], [], 1));
maxBound           = round(max([xBound, yBound], [], 1));
[xMatrix, yMatrix] = meshgrid(minBound(1) : maxBound(1), minBound(2) : maxBound(2));
xArray             = reshape(xMatrix, [numel(xMatrix), 1]);
yArray             = reshape(yMatrix, [numel(yMatrix), 1]);
tpsXinv            = est_tps(p2In(1, :), p2In(2, :), p1In(1, :));
tpsYinv            = est_tps(p2In(1, :), p2In(2, :), p1In(2, :));
[xSrcArr, ySrcArr] = apply_tps(xArray, yArray, tpsXinv, tpsYinv, p2In(1, :), p2In(2, :));
xSrcArr            = round(xSrcArr);
ySrcArr            = round(ySrcArr);

% Handle bounds for stitched image
minMosaic   = min([minBound; [1 1]], [], 1);
maxMosaic   = max([maxBound; [xDes, yDes]], [], 1);
rangeMosaic = maxMosaic - minMosaic + 1;
Iout        = uint8(zeros(rangeMosaic(2), rangeMosaic(1), 3));
minDes      = 1 - (minMosaic ~= 1) .* minMosaic;
Iout(minDes(2) : (minDes(2) + yDes - 1), minDes(1) : (minDes(1) + xDes - 1), :) = Ides;

% Remove non-effective pixels
effectIdx = xSrcArr >= 1 & xSrcArr <= xSrc & ySrcArr >= 1 & ySrcArr <= ySrc;
xArray    = xArray(effectIdx);
yArray    = yArray(effectIdx);
xSrcArr   = xSrcArr(effectIdx);
ySrcArr   = ySrcArr(effectIdx);

for i = 1 : length(xArray)
    % Skip the white background
    if InewG(ySrcArr(i), xSrcArr(i)) >= 240
       continue; 
    end
    
    % Blending
    if all(Iout(yArray(i) - minMosaic(2) + 1, xArray(i) - minMosaic(1) + 1, :) == 0)
        Iout(yArray(i) - minMosaic(2) + 1, xArray(i) - minMosaic(1) + 1, :) = Inew(ySrcArr(i), xSrcArr(i), :);
    else
        Iout(yArray(i) - minMosaic(2) + 1, xArray(i) - minMosaic(1) + 1, :) = blendFrac * Iout(yArray(i) - minMosaic(2) + 1, xArray(i) - minMosaic(1) + 1, :) ...
                                              + (1 - blendFrac) * Inew(ySrcArr(i), xSrcArr(i), :);
    end
end
Iout = im2uint8(Iout);

if verbose
   return; 
end

figure(44); clf;
imagesc(Iout); axis image; title('Result after replacement');

end