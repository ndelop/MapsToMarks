function [ ] = plot_face( face, opt, nums)
%PLOT_FACE plots face landmarks on an inverted coordinate system

if nargin < 3
    nums = true;
end
if nargin < 2
    opt = '*';
end

face=face.';
face=face(:);


scatter(face(1:2:end), face(2:2:end),opt);
if nums
    text(face(1:2:end)+0.5, face(2:2:end),num2str([1:size(face)/2].'));
end
axis ij
end

