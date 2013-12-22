function [x_vote, y_vote] = vote(frame2, codebook)
% VOTE - 
% frame2    -- current frame
% codebook  -- matching entries in codebook

x = codebook(1,:);
y = codebook(2,:);
n = numel(x);
scale1  = codebook(3,:);
orient1 = codebook(4,:);
x_des   = frame2(1);
y_des   = frame2(2);
scale2  = frame2(3);
orient2 = frame2(4);

x_vote = zeros(1,n); 
y_vote = zeros(1,n); 
ratio  = scale2 ./ scale1;
theta  = orient2 - orient1; 

for i = 1:n
    [x_vote(i), y_vote(i)] = rot2d(x(i), y(i), theta(i));
end

x_vote = round(x_vote .* ratio + x_des);
y_vote = round(y_vote .* ratio + y_des);

end
