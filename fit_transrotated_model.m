function [landmarks] = fit_transrotated_model(ShapeModel, prediction, centroid, theta, eps, flip)
imgsz = size(prediction,1);

if nargin < 6
    flip = false;
end
if ~flip
    prediction = permute(prediction,[4,3,1,2]);
end
prediction = squeeze(prediction); %lmn x y

if nargin < 5
    eps = 0.01;
end

if nargin < 4
    theta = heatmap_tilt(prediction);
end

if nargin < 3
    centroid = heatmap_centroid(prediction,2);
end



if numel(size(prediction)) > 3
    error('Currently, only 1 image at a time is supported.');
end
oldSM = ShapeModel;
n=ShapeModel.n;
lagr_eps = 1;
% solve A*x=b, weighted by the heatmap pixel values, using the first n
% components of the model
% higher n means more accurate fitting but more noise as well

% the solution x are the coefficients for best fitting landmark coordinates
% applying the coefficients to the EVs yields the landmarks (x1,y1,...,xN,yN)

% weights
    
w = repmat(prediction,[1,1,1,2]);
w = permute(w,[4,1,2,3]); % 2 lmn x y
w = w(:);


ROT = kron(eye(15),rotmat(theta));
ShapeModel.avg = (ROT*(ShapeModel.avg.')).';
ShapeModel.EVs = ROT*ShapeModel.EVs;

% 2N equations per pixel
A = repmat(ShapeModel.EVs(:,1:n),size(prediction,2)*size(prediction,3),1);
A = bsxfun(@times,A,w);
A(w<=eps,:) = [];


center = zeros(size(ShapeModel.avg.'));

center(1:2:end) = centroid(1);
center(2:2:end) = centroid(2);
average = ShapeModel.avg.' + center;


% target values
[px,py] = ndgrid(1:size(prediction,2),1:size(prediction,3));
b = bsxfun(@minus,repmat([px(:).';py(:).'],size(prediction,1),1),average);

b = b(:).*w;
b(w<=eps) = [];

%% solve the system:

%ShapeModel.C*landmarks < 0
%ShapeModel.C*(ShapeModel.avg.' + ShapeModel.EVs(:,1:n)*x)<0
%ShapeModel.C*ShapeModel.EVs(:,1:n)*x < -ShapeModel.C*ShapeModel.avg.'
%so C = ShapeModel.C*ShapeModel.EVs(:,1:n)
%and d = -ShapeModel.C*ShapeModel.avg.'

%only use constraints true for more than lagr_eps of the training data
ShapeModel.C = ShapeModel.C(ShapeModel.diffs>=lagr_eps, :);

% C = ShapeModel.C*ShapeModel.EVs(:,1:n);
% d = -ShapeModel.C*average;

oldSM.C = oldSM.C(oldSM.diffs>=lagr_eps, :);

C = oldSM.C*ROT*ROT*oldSM.EVs(:,1:n);
d = -oldSM.C*ROT*ROT*(oldSM.avg.');


%landmarks should also be inside the picture
%landmarks >= 0 and landmarks <= imgsz
%landmarks = ShapeModel.avg.' + ShapeModel.EVs(:,1:n)*x
%ShapeModel.avg.' + ShapeModel.EVs(:,1:n)*x > 0 
%and ShapeModel.avg.' + ShapeModel.EVs(:,1:n)*x < imgsz
%=>
% -ShapeModel.EVs(:,1:n)*x < ShapeModel.avg.'
%and ShapeModel.EVs(:,1:n)*x < imgsz - ShapeModel.avg.'

F=[-ShapeModel.EVs(:,1:n); ShapeModel.EVs(:,1:n)];
g = [average ; (imgsz - average)];

%solve the system A*x=b subject to inequality constraints
%C*x <= d and
%F*x <= g

CF=[C;F];
dg=[d;g];

C=[];
d=[];

options = optimoptions('lsqlin','Algorithm','interior-point');
[~, x] = evalc('lsqlin(A,b,C,d,[],[],[],[],[],options);'); %evalc to supress output



landmarks = average + ShapeModel.EVs(:,1:n)*x;
%landmarks = center + ROT*(ShapeModel.EVs(:,1:n)*x + ShapeModel.avg.');
end
