function [centroid] = face_centroid( face )
%FACE_CENTROID detects centroid of a face using its landmarks
%See also HEATMAP_CENTROID

face=face.';
face=face(:);

x = mean(face(1:2:end));
y = mean(face(2:2:end));

centroid = [x y];
end

