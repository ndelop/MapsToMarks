function [ ] = plot_face( face )
scatter(face(1:2:end), face(2:2:end),'*r');
axis ij
end

