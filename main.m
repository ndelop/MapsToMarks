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

%% PREPROCESSING or load pred.mat and pred_max.mat instead
kernel = build_kernel([5,15,25,35,45],[1,3,5,7,9]);
pred = convn(pred_init,kernel,'same');
pred(pred<0) = 0;
pred_max = floor(bsxfun(@rdivide,pred,max(max(pred))));
pred_max(isnan(pred_max)) = 0;


%% Load training data
load('kaggle.mat')

%% Net maximum
[x, y] = net_max(pred_new);


%%
SM = new_pca_model(train_labels);
SM.n=14;
[xg, yg, xl, yl] = fit_compl(SM, pred_new);
%[xg, yg] = fit_compl(SM, pred_new);

%% Store in CSV for Kaggle evaluation
kagglify(xl, yl);