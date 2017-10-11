function [ mat ] = rotmat( theta )
%returns a rotation matrix for 2d vectors
c = cosd(theta);
s = sind(theta);
mat = [c -s; s c];
end

