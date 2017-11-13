%START HERE


%% READING DATA or load pred_init.mat instead
imgsz = 96;
lmn   = 15;
imgn  = 1783;
% f = fopen('W:\7_Output\mer\Debug_kaggle_reg.labels','r');
% lab = reshape(fscanf(f,'%f'),[imgsz,imgsz,lmn,imgn]);
% fclose(f);
%f = fopen('C:\Users\N\Documents\6. Sem\BA\Data_Nikos\Eval_kaggle_reg.365.o1','r');
tic
f = fopen('C:\Users\N\Documents\6. Sem\BA\Eval_kaggle_reg.44.o2','r');
toc
pred_init = reshape(fscanf(f,'%f'),[imgsz,imgsz,lmn,imgn]);
toc
fclose(f);

%% PREPROCESSING
kernel = build_kernel([5,15,25,35,45],[1,3,5,7,9]);
pred = convn(pred_init,kernel,'same');
pred(pred<0) = 0;
pred_max = floor(bsxfun(@rdivide,pred,max(max(pred))));
pred_max(isnan(pred_max)) = 0;

%% or load pred.mat instead
load('pred.mat');

%% or load new data: pred_new.mat
load('pred_new.mat');
pred_new(pred_new<0)=0;
%% Load training data
load('kaggle.mat')

%% Net maximum
[x, y] = net_max(pred_new);


%% Setup and model fitting
%For best kaggle scores centroid and tilt estimation and handling should be disabled
translation_handling = false;
rotation_handling = false;

%For other applications
% translation_handling = true;
% rotation_handling = true;

SM = new_pca_model(train_labels, translation_handling, rotation_handling)%train model
SM.n = 30 %experiment with different model orders

GUI = true; %completion percentage bar
window_sizes = [20 7]; %local fit window sizes, empty vector to disable local fitting
model_constraints = true; %constraints described in write-up
image_boundary_constraints = true; % constraints not described in write-up,
%only activate under the assumption all landmarks lie inside the picture

[xg, yg, xl, yl] = fit_compl(SM, permute(h,[2,1,3])*1000000, window_sizes, GUI, model_constraints, image_boundary_constraints,translation_handling,rotation_handling);



%% Store in CSV for Kaggle evaluation
kagglify(xl, yl);