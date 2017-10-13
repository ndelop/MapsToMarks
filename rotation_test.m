imageid = 1;
fprintf('-------------------')
p=squeeze(pred_new(:,:,:,imageid));
SM = new_pca_model(train_labels);
lalala = SM;
for i = 8
    n = rotate_heatmaps(p,i);
    img=imrotate(squeeze(eval_img(imageid,:,:)./255), i);

    
    tmp = fit_transrotated_model(SM, n);
    xg=tmp(1:2:end);
    yg=tmp(2:2:end);
    
    ht = heatmap_tilt(permute(n,[3 1 2]))
    ft = face_tilt([xg yg])
    plot_face([xg yg])
    
%     [xg, yg, xl, yl] = fit_compl(SM, n, false);
%     [xm ym] = net_max(n);
% 
     imshow(img)
     
     hold on;
     c = face_centroid([xg yg]);
     scatter(c(1),c(2))
     
     c=heatmap_centroid(permute(n, [3 1 2]),1);
     scatter(c(1),c(2))

     plot_face([xg yg],'g')

     hold off
     pause(0.08)

end
