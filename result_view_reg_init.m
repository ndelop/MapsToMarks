function [ images, pred, gtx, gty, lmx, lmy ] = result_view_reg_init()

images = evalin('base','eval_img');
pred = evalin('base','pred');

%Red
lmx = evalin('base','xg');
lmy = evalin('base','yg');
% gtx = evalin('base','gtx');
% gty = evalin('base','gty');

%Green
% gtx = zeros(size(lmx));
% gty = zeros(size(lmy));
gtx = evalin('base','xl');
gty = evalin('base','yl');
