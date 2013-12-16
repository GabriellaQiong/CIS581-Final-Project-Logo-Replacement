function [p1, p2] = fix_match(p1, p2)
% Fix multiple-to-one mismatches
p = mode(p2');
ind = bsxfun(@eq, p2', p);
ind = ind(:,1) & ind(:,2);
ind = ~ind;
p1 = p1(:, ind);
p2 = p2(:, ind);
end