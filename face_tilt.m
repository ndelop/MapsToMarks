function [ tilt ] = face_tilt( face, landmarks )
%FACE_TILT calculates tilt of a face based on its landmarks
%landmarks should be a list of landmarks that are expected to lie on a
%horizontal line on a non tilted face e.g. pupils of the eyes
%See also HEATMAP_TILT

if nargin < 2
  landmarks = [3, 4, 5, 6]; %default for Kaggle dataset
end

face=face.';
face=face(:);

x=face(1:2:end);
y=face(2:2:end);

x=x(landmarks);
y=y(landmarks);

%fit y = a*x + b on landmarks
A= [x, ones(size(x))];
b = y;

param = A\b;

tilt=-atand(param(1));

end

