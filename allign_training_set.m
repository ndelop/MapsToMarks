function [ new_labels ] = allign_training_set( train_labels )
%positions centroid of each face on 0,0

new_labels = zeros(size(train_labels));
size(train_labels)
for l=1:size(train_labels,1)
    t = train_labels(l,:);
    t=t(:);
    
%     c = face_centroid(t);
%     t(1:2:end)=t(1:2:end)-c(1);
%     t(2:2:end)=t(2:2:end)-c(2);
%     
%     theta = face_tilt(t);
%     R = kron(eye(size(t,1)/2), rotmat(theta));
%     t = R*t;
%     face_tilt(t);

    
    c = face_centroid(t);
    t(1:2:end)=t(1:2:end)-c(1);
    t(2:2:end)=t(2:2:end)-c(2);
    
    new_labels(l,1:2:end)=t(1:2:end);
    new_labels(l,2:2:end)=t(2:2:end);
    
end;



end
