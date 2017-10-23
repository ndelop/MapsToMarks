function [ x, y ] = net_max( pred )
%NET_MAX returns landmark locations using only heatmap maxima

x=zeros(size(pred,3),size(pred, 4));
y=x;
for i=1:size(pred, 4)
    for l = 1:size(pred,3)
        p = squeeze(pred(:,:,l,i));
        [maxval, maxpos] = max(p(:));
        [xmax, ymax] = ind2sub(size(p), maxpos);
        x(l,i)=xmax;
        y(l,i)=ymax;
    end
end


end

