function [ newheatmaps ] = rotate_heatmaps( heatmaps, theta )
%heatmaps x y nlm

for i=1:size(heatmaps,3)
   h = heatmaps(:,:,i);
   n=imrotate(h,-theta);
   newheatmaps(:,:,i)=n;
end

end

