function [ ] = kagglify( x, y , filename)
%KAGGLIFY produces and stores a Kaggle submission .csv file

if nargin <3
    filename = 'KaggleSub.csv';
end

load('KaggleCSV.mat')%FNs
imgn = size(x, 2);

F=repmat(FNs(1:30),[imgn 1]);

finx = x(:);
finy= y(:);
fin=[finx finy]';
fin=fin(:);
sum(fin<0)
sum(fin>96)
fin(fin<0)=0;
fin(fin>96)=96;
res=[];
i=1;
for j=1:size(fin,1)
    if(strcmp(F(j), FNs(i)))
        res(i)=fin(j);
        i=i+1;
    end
end
res=res.';
res=[[1:size(res,1)]' res];
f = fopen(filename,'w');
fprintf(f,'RowId,Location\n');
fclose(f);

dlmwrite(filename,res,'delimiter',',','-append');


end

