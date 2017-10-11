function [ new_labels ] = allign_training_set( train_labels )
%positions centroid of each face on 0,0

new_labels = zeros(size(train_labels));

for l=1:size(train_labels,1)
    t = train_labels(l,:);
    c = face_centroid(t);
    
    new_labels(l,1:2:end)=train_labels(l,1:2:end)-c(1);
    new_labels(l,2:2:end)=train_labels(l,2:2:end)-c(2);
end;

end
