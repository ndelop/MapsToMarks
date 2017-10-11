function [ ] = plot_face( face, opt)

face=face.';
face=face(:);
if nargin < 2
    opt = '*';
end

scatter(face(1:2:end), face(2:2:end),opt);
text(face(1:2:end), face(2:2:end),num2str([1:size(face)/2].'));
axis ij
end

