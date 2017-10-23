function [ tilt ] = heatmap_tilt( heatmaps, landmarks )
%HEATMAP_TILT calculates tilt of a face based on its heatmaps
%dimensions of heatmaps: lmn x y
%landmarks should be a list of landmarks that are expected to lie on a
%horizontal line on a non tilted face e.g. pupils of the eyes
%See also FACE_TILT

if nargin < 2
  landmarks = [3, 4, 5, 6];  
end

heatmaps(heatmaps<0)=0;
s = squeeze(sum(heatmaps(landmarks,:,:))).'; %Transpose because heatmap x,y are flipped

props = regionprops(s > mean(mean(s)), {'Orientation'});
tilt = props.Orientation;



end

