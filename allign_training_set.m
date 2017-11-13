function [ new_labels ] = allign_training_set( train_labels, centering, tilting )
%ALLIGN_TRAINING_SET centers and cancels tilt of each face of the training set

if nargin < 3
    tilting = true;
end
if nargin < 2
    centering = true;
end

if tilting & ~centering
    warning('rotating faces without centering them, also translates them');
end

new_labels = zeros(size(train_labels));

for l=1:size(train_labels,1)
    t = train_labels(l,:);
    t=t(:);
    
    if centering
        c = face_centroid(t);
        t(1:2:end)=t(1:2:end)-c(1);
        t(2:2:end)=t(2:2:end)-c(2);
    end
    
    if tilting
        theta = face_tilt(t);
        R = kron(eye(size(t,1)/2), rotmat(-theta));
        t = R*t;
    end
    new_labels(l,1:2:end)=t(1:2:end);
    new_labels(l,2:2:end)=t(2:2:end);
    
end;



end
