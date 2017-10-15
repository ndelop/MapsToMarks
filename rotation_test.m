imageid = 1;
fprintf('-------------------')
p=squeeze(pred_new(:,:,:,imageid));
SM = new_pca_model(train_labels);
lalala = SM;
for i = -45
    n = rotate_heatmaps(p,i);
    size(n)
    img=imrotate(squeeze(eval_img(imageid,:,:)./255), i);
    ROT = kron(eye(15),rotmat(i));
    imshow(img)
    hold on
    
    ht = heatmap_tilt(permute(n,[3 1 2]))
    
%     tmp = fit_transrotated_model(SM, n);
%     xg=tmp(1:2:end);
%     yg=tmp(2:2:end);
    
    [xg, yg, xl, yl] = fit_compl(SM, n, false);
    [xm ym] = net_max(n);
    
    ht = heatmap_tilt(permute(n,[3 1 2]));
    ft = face_tilt([xl yl]);
    plot_face([xl yl])
    

     imshow(img)
     
     hold on;
     c = face_centroid([xl yl]);
     scatter(c(1),c(2))
     
     c=heatmap_centroid(permute(n, [3 1 2]),1);
     scatter(c(1),c(2))

     plot_face([xl yl],'g')

     hold off
     pause(0.1)

end
