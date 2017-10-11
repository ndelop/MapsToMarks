function [landmarks] = fit_translated_model(ShapeModel, prediction, centroid, eps, flip)
imgsz = size(prediction,1);

if nargin < 5
    flip = false;
end
if ~flip
    prediction = permute(prediction,[4,3,1,2]);
end
prediction = squeeze(prediction); %lmn x y

if nargin < 4
    eps = 0.01;
end
if nargin < 3
    centroid = heatmap_centroid(prediction,2)
end



if numel(size(prediction)) > 3
    error('Currently, only 1 image at a time is supported.');
end
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

% 2N equations per pixel
A = repmat(ShapeModel.EVs(:,1:n),size(prediction,2)*size(prediction,3),1);
A = bsxfun(@times,A,w);
A(w<=eps,:) = [];


average = ShapeModel.avg.';
average(1:2:end) = average(1:2:end)+centroid(1);
average(2:2:end) = average(2:2:end)+centroid(2);

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
C = ShapeModel.C*ShapeModel.EVs(:,1:n);
d = -ShapeModel.C*average;


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



options = optimoptions('lsqlin','Algorithm','interior-point');
[~, x] = evalc('lsqlin(A,b,CF,dg,[],[],[],[],[],options);'); %evalc to supress output


landmarks = average + ShapeModel.EVs(:,1:n)*x;


end
