function [ newheatmaps ] = rotate_heatmaps( heatmaps, theta )
%ROTATE_HEATMAPS returns heatmaps rotated by the specified angle
%heatmaps dimensions x y nlm
%used for testing only

for i=1:size(heatmaps,3)
   h = heatmaps(:,:,i);
   n=imrotate(h,-theta);
   newheatmaps(:,:,i)=n;
end

end

