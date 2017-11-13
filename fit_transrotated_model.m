function [landmarks] = fit_transrotated_model(ShapeModel, prediction, model_constraints, image_boundary_constraints, centroid, theta, eps, flip)
%FIT_TRANSROTATED_MODEL returns landmarks after a single constrained model fitting
%the types of constraints to be used can be set
%the face centroid and tilt can be passed as arguments or estimated from the heatmaps
%See also FIT_COMPL, HEATMAP_CENTROID, HEATMAP_TILT

imgszx = size(prediction,1);
imgszy = size(prediction,2);
lmn = size(prediction,3);

if nargin < 8
    flip = false;
end
if ~flip
    prediction = permute(prediction,[4,3,1,2]);
end
prediction = squeeze(prediction); %lmn y x
if nargin < 7
    eps = 0.01;
end
if nargin < 6
    theta = heatmap_tilt(prediction);
end
if nargin < 5
    centroid = heatmap_centroid(prediction,2);
end
if nargin < 4
    image_boundary_constraints = false;
end
if nargin < 3
    model_constraints = true;
end



if numel(size(prediction)) > 3
    error('Currently, only 1 image at a time is supported.');
end
n=ShapeModel.n;

% solve A*x=b, weighted by the heatmap pixel values, using the first n
% components of the model
% higher n means more accurate fitting but more noise as well

% the solution x are the coefficients for best fitting landmark coordinates
% applying the coefficients to the EVs yields the landmarks (x1,y1,...,xN,yN)

% weights:
w = repmat(prediction,[1,1,1,2]);
w = permute(w,[4,1,2,3]); % 2 lmn x y
w = w(:);

%rotation matrix:
ROT = kron(eye(size(prediction,1)),rotmat(theta));


% 2n equations per pixel:
A = repmat(ROT*ShapeModel.EVs(:,1:n),size(prediction,2)*size(prediction,3),1);
A = bsxfun(@times,A,w);
A(w<=eps,:) = [];


center = zeros(size(ShapeModel.avg.'));
center(1:2:end) = centroid(1);
center(2:2:end) = centroid(2);
average = ROT*(ShapeModel.avg.') + center;


% target values
[px,py] = ndgrid(1:size(prediction,2),1:size(prediction,3));
b = bsxfun(@minus,repmat([px(:).';py(:).'],size(prediction,1),1),average);

b = b(:).*w;
b(w<=eps) = [];

%% solve the system:

%See BA write-up for constraints structure
C=[];
d=[];
if model_constraints
    %only use constraints true for all of the training data:
    ShapeModel.C = ShapeModel.C(ShapeModel.diffs>=1, :);%new ShapeModel.C is equivalent to S*C in write-up

    C = ShapeModel.C*ShapeModel.EVs(:,1:n);
    d = -ShapeModel.C*(ShapeModel.avg.');
    %C*x <= d and
end


F=[];
g=[];
if image_boundary_constraints
    %landmarks should be inside the picture (NOT INCLUDED IN WRITE-UP)
    %landmarks >= 0 and landmarks <= [imgszx, imgszy, imgszx, imgszy, ...] 
    bound = repmat([imgszx imgszy].', [lmn 1]);
    %landmarks = center + ROT*(ShapeModel.avg.') + ROT*ShapeModel.EVs(:,1:n)*x;
    %
    %center + ROT*(ShapeModel.avg.') + ROT*ShapeModel.EVs(:,1:n)*x >= 0 
    %and
    %center + ROT*(ShapeModel.avg.') + ROT*ShapeModel.EVs(:,1:n)*x <= bound
    %
    %=>
    %
    %-ROT*ShapeModel.EVs(:,1:n)*x <= center + ROT*(ShapeModel.avg.')
    %and
    %ROT*ShapeModel.EVs(:,1:n)*x <= bound -(center + ROT*(ShapeModel.avg.'))
    %

    F=[-ROT*ShapeModel.EVs(:,1:n); ROT*ShapeModel.EVs(:,1:n)];
    g = [center + ROT*(ShapeModel.avg.'); (bound -(center + ROT*(ShapeModel.avg.')))];
    %F*x <= g
end

CF=[C;F];
dg=[d;g];

%constrained LLSQ fitting
options = optimoptions('lsqlin','Algorithm','interior-point');
[~, x] = evalc('lsqlin(A,b,CF,dg,[],[],[],[],[],options);'); %evalc to supress output


landmarks = center + ROT*(ShapeModel.avg.') + ROT*ShapeModel.EVs(:,1:n)*x;

end
