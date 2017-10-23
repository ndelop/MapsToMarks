function [x, y, xl, yl] = fit_compl(SM, prediction, wind, GUI, model_constraints ,image_boundary_constraints)
%FIT_COMPL fits the model to a set of images(=sets of heatmaps)  and returns the predictions
%after the first iteration and after all iterations
%See also FIT_TRANSROTATED_MODEL
if nargin < 6
    image_boundary_constraints = false;
end
if nargin < 5
    model_constraints = true;
end
if nargin < 4
    GUI = true;
end
if nargin < 3
    wind = [20 10 5];
end


startTime = tic;
lmn = size(prediction,3);
imgn = size(prediction,4);

x = zeros(lmn,imgn);
y = x;
if GUI bar = waitbar(0, 'First fit'); end;
tic

for k = 1:imgn
    tmp = fit_transrotated_model(SM, prediction(:,:,:,k), model_constraints, image_boundary_constraints);
    x(:,k) = tmp(1:2:end);
    y(:,k) = tmp(2:2:end);
    
    %fprintf([num2str(k),'\n'])
    fps = round(k/toc,1);
    if GUI waitbar(k/imgn, bar, strcat(['First fit ', num2str(fps),'fps'])); end;
end

%Local fit
wind=[40 20 7];
wind = round(wind);
x2=x;
y2=y;
imgszx = size(prediction,1);
imgszy = size(prediction,2);

for iter=1:size(wind,2)
    dxy = wind(iter);
    xtmp = permute(reshape(min(max(cell2mat(arrayfun(@(z) z-dxy:z+dxy,round(x2),'UniformOutput',false)),1),imgszx),[lmn,1+2*dxy,imgn]),[1,3,2]);
    ytmp = permute(reshape(min(max(cell2mat(arrayfun(@(z) z-dxy:z+dxy,round(y2),'UniformOutput',false)),1),imgszy),[lmn,1+2*dxy,imgn]),[1,3,2]);

    selector = false(size(prediction));

    for i = 1:size(x2,1)
       for j = 1:size(y2,2)
           selector(xtmp(i,j,:),ytmp(i,j,:),i,j) = true;%mark weights to keep
       end;
    end;

    if GUI waitbar(0,bar,strcat('Local Fit, dx=',num2str(dxy))); end;
    tic;
    for k = 1:imgn
        predloc = prediction(:,:,:,k);
        predloc(~selector(:,:,:,k)) = 0;    %set all outlier weights to zero
        centroid = face_centroid([x2(:,k), y2(:,k)]);
        tilt = face_tilt([x2(:,k), y2(:,k)]);
        tmp = fit_transrotated_model(SM, predloc, model_constraints, image_boundary_constraints, centroid, tilt);
        x2(:,k) = tmp(1:2:end);
        y2(:,k) = tmp(2:2:end);

        fps = round(k/toc,1);
        if GUI waitbar(k/imgn,bar,strcat(['Local Fit, dx=',num2str(dxy),' ', num2str(fps),'fps'])); end;
    end
end
xl=x2;
yl=y2;

dT = toc(startTime);
if GUI delete(bar); end;
fprintf(strcat([num2str(imgn) ' faces processed in ' num2str(round(dT,2)) 's, ' num2str(round(imgn/dT,2)) 'fps\n']))
end

