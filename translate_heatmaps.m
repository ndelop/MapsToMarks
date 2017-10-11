function [ newheatmaps ] = translate_heatmaps( heatmaps, d)
%heatmaps x y nlm
for i=1:size(heatmaps,3)
   h = heatmaps(:,:,i);
   n=imtranslate(h,d(end:-1:1),'OutputView','full');
   newheatmaps(:,:,i)=n;
end

end

