function [x, y, xl, yl] = fit_compl(SM, prediction)

if ~SM.constrained
    fprintf('SM has no constraints')
end
startTime = tic;
lmn = size(prediction,3);
imgn = size(prediction,4);

x = zeros(lmn,imgn);
y = x;
bar = waitbar(0, 'First fit');
tic

for k = 1:imgn
    tmp = fit_translated_model(SM,prediction(:,:,:,k));
    
    x(:,k) = tmp(1:2:end);
    y(:,k) = tmp(2:2:end);
    
    %fprintf([num2str(k),'\n'])
    fps = round(k/toc,1);
    waitbar(k/imgn, bar, strcat(['First fit ', num2str(fps),'fps']));
end

%Local fit
if nargout > 2
    wid=[20 7];
    wid = round(wid);
    x2=x;
    y2=y;
    imgszx = size(prediction,1);
    imgszy = size(prediction,2);
    for iter=1:size(wid,2)
        dxy = wid(iter);

        
        xtmp = permute(reshape(min(max(cell2mat(arrayfun(@(z) z-dxy:z+dxy,round(x2),'UniformOutput',false)),1),imgszx),[lmn,1+2*dxy,imgn]),[1,3,2]);
        ytmp = permute(reshape(min(max(cell2mat(arrayfun(@(z) z-dxy:z+dxy,round(y2),'UniformOutput',false)),1),imgszy),[lmn,1+2*dxy,imgn]),[1,3,2]);

        selector = false(size(prediction));

        for i = 1:size(x2,1)
           for j = 1:size(y2,2)
               selector(xtmp(i,j,:),ytmp(i,j,:),i,j) = true;
           end;
        end;

        waitbar(0,bar,strcat('Local Fit, dx=',num2str(dxy)));
        tic;
        for k = 1:imgn
            predloc = prediction(:,:,:,k);
            predloc(~selector(:,:,:,k)) = 0;    %set all outlier weights to zero
            tmp = fit_translated_model(SM,predloc,[mean(x2(:,k)) mean(y2(:,k))]);
            x2(:,k) = tmp(1:2:end);
            y2(:,k) = tmp(2:2:end);

            fps = round(k/toc,1);
            waitbar(k/imgn,bar,strcat(['Local Fit, dx=',num2str(dxy),' ', num2str(fps),'fps']))
        end


    end
    xl=x2;
    yl=y2;
end

dT = toc(startTime);

fprintf(strcat([num2str(imgn) ' faces processed in ' num2str(round(dT,2)) 's, ' num2str(round(imgn/dT,2)) 'fps\n']))
end

