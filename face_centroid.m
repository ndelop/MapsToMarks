function [centroid] = face_centroid( face )

x = mean(face(1:2:end));
y = mean(face(2:2:end));

centroid = [x y];
end

