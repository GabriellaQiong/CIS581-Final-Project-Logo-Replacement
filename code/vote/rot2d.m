function varargout = rot2d(x, y, theta)
% ROT2D rotate x,y conter-clockwise by angle theta
% x -- row vector
% y -- row vector


R   = [cos(theta) -sin(theta); sin(theta) cos(theta)];
vec = R*[x;y];

if nargout == 1
    varargout{1} = vec;
elseif nargout == 2
    varargout{1} = vec(1,:);
    varargout{2} = vec(2,:);
end

end
