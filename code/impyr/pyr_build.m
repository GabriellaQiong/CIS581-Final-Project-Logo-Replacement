function limgo = pyr_build(limga, limgb, maska, maskb, level)
if nargin < 5, level = 5; end
limgo = cell(1,level); % the blended pyramid
for p = 1:level
	[Mp, Np, ~] = size(limga{p});
	maskap = imresize(maska,[Mp Np]);
	maskbp = imresize(maskb,[Mp Np]);
	limgo{p} = limga{p}.*maskap + limgb{p}.*maskbp;
end
end