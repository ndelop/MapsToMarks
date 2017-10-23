function [] = comp_res( x1, y1, x2, y2 )
%COMP_RES plots distances of predictions, used only for evaluation

d=sum( ((x1-x1).^2 + (y1-y2).^2).^(1/2)/96 );
scatter(1:length(d),d);


end

