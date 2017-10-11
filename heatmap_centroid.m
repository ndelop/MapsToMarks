function [centroid] = heatmap_centroid(heatmaps, method)
%detects centroid of face weighted by heatmap values
%dimensions of heatmaps: lmn x y

if method==1 %Use weighted average of sum of all heatmaps

    heatmaps(heatmaps<0)=0;
    s = squeeze(sum(heatmaps, 1));

    props = regionprops(true(size(s)), s, {'WeightedCentroid'});

    x=props.WeightedCentroid(1);
    y=props.WeightedCentroid(2);

    %to remain consistent:
    tmp=x;
    x=y;
    y=tmp;
    
elseif method==2 %Use weighted average of maximum of each heatmap
    sumofweights=0;
    x=0;
    y=0;
    for i=1:size(heatmaps,1)
        w = squeeze(heatmaps(i,:,:));
        [maxval, maxpos] = max(w(:));
        [xmax ymax] = ind2sub(size(w), maxpos);

        x = x + xmax*maxval;
        y = y + ymax*maxval;
        sumofweights = sumofweights + maxval;
    end;
    x = x/sumofweights;
    y = y/sumofweights;
    
    
end;

centroid = [x y];
end

