function [ ] = plot_face( face, opt)

if nargin < 2
    opt = '*';
end

scatter(face(1:2:end), face(2:2:end),opt);
axis ij
end

