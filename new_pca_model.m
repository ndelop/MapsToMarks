function [ ShapeModel ] = new_pca_model( train_labels, centering, tilting )
%NEW_PCA_MODEL returns a ShapeModel struct
%ShapeModel.avg is the mean face
%ShapeModel.C is the landmark coordinate difference generating matrix
%ShapeModel.diffs contains the percentage of negative results for each of the coordinate differences
%ShapeModel.EVs contains all PCA principal componets
%ShapeModel.S contains the corresponding eigenvalues
%ShapeModel.n contains the suggested number of principal components to be retained
%See also ALLIGN_TRAINING_SET

if nargin < 3
    tilting = true;
end
if nargin < 2
    centering = true;
end

train_labels(any(any(train_labels==-1000,2),3),:,:) = []; %cleanup, remove partially labelled data
train_labels = permute(train_labels,[1,3,2]); %reorder
train_labels = reshape(train_labels,size(train_labels,1),size(train_labels,2)*size(train_labels,3)); %from x y to face vectors
%rows of train_labels: [x1 y1 x2 y2 ... xN yN]
train_labels = allign_training_set(train_labels,centering,tilting); 

ShapeModel.avg = mean(train_labels,1); %calc shape average

lmn = size(train_labels, 2)/2;
d = diff_matrix(lmn);
D = [d, zeros(size(d)); zeros(size(d)), d];

e = eye(2*lmn);
perm = [1:2:2*lmn 2:2:2*lmn];
E = e(perm,:);

C=D*E;
C=[C;-C];
ShapeModel.C = C;
%C*face_vector results in a vector with all the landmark coordinate differences for each axis
%[x1-x2; x1-x3; x1-x4;...;yN-1 - yN ...
% x2-x1; x3-x1; x4-x1;...;yN- yN-1]

%%matrix of landmark coord differences
ShapeModel.diffs = zeros(size(C,1), 1);
for i=1:size(train_labels,1)
    v=train_labels(i,:).';
    d=C*v;
    ShapeModel.diffs = ShapeModel.diffs + (d<0);
end
ShapeModel.diffs = ShapeModel.diffs/size(train_labels,1);
ShapeModel.constrained = true;


%%PCA via SVD
train_labels = bsxfun(@minus,train_labels,ShapeModel.avg).';%center data

[U, S, V] = svd(train_labels,'econ');

ShapeModel.EVs = U*S;
ShapeModel.Coeffs = V.';
ShapeModel.S = diag(S);

%Scree plot for PC retention decision
%two line segments are fitted on the eigenvalue plot
v= ShapeModel.S;
N=size(v,1);
optcost = inf;
opti=1;
for i=2:N-1
    %slopes
    m1=(v(i)-v(1))/(i-1);
    m2=(v(N)-v(i))/(N-i);
    
    x1=[2:i-1].';
    x2=[i+1:N-1].';
    
    cost = sum(abs(m1*(x1 -1) + v(1))) + sum(abs(m2*(x2 -N) + v(N)));

    if cost<optcost
        optcost=cost;
        opti=i;
        optm(1)=m1;
        optm(2)=m2;
    end
    
end
ShapeModel.n = opti;

end

