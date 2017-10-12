imageid = 1557;
fprintf('-------------------')
p=squeeze(pred_new(:,:,:,imageid));
SM = new_pca_model(train_labels);

for i = 1:60
    n = rotate_heatmaps(p,i);
    img=imrotate(squeeze(eval_img(imageid,:,:)./255), i);
    %[xg, yg] = fit_compl(SM, n, false);
    
%     tmp = fit_rotated_model(SM, n);
%     xg=tmp(1:2:end);
%     yg=tmp(2:2:end);

    [xg, yg, xl, yl] = fit_compl(SM, n, false);
    i
    ht = heatmap_tilt(permute(n,[3 1 2]))
    ft = face_tilt([xg yg])
    plot_face(tmp)
    
%     [xg, yg, xl, yl] = fit_compl(SM, n, false);
%     [xm ym] = net_max(n);
% 
     imshow(img)
     
     hold on;
     plot_face([xg yg],'g')
%     plot_face([xm ym],'r')
% 
     hold off
     pause(0.08)

end