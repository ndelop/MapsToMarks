function [ newheatmaps ] = translate_heatmaps( heatmaps, d)
%TRANSLATE_HEATMAPS returns heatmaps translated to the specified center
%heatmaps dimensions x y nlm
%used for testing only

for i=1:size(heatmaps,3)
   h = heatmaps(:,:,i);
   n=imtranslate(h,d(end:-1:1),'OutputView','full');
   newheatmaps(:,:,i)=n;
end

end

