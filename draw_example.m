%scripts to produce example images

%%--
i = 1033;
xlocal = xl(:,i);
ylocal = yl(:,i);
xglobal = xg(:,i);
yglobal = yg(:,i);

heatmap = squeeze(pred(:,:,:,i));
image = squeeze(eval_img(i,:,:)./255);

save 'example7.mat' xlocal ylocal xglobal yglobal heatmap image


%%--- 

figure;
i=7;
x=[0 95;0 95];
y=[0 0;95 95];
z=[0 0;0 0];
colormap(gray)
h=surface(x,y,z);
set(h, 'FaceColor','texturemap','EdgeColor','none','Cdata',(image))
h=surface(x,y,z+1);
set(h,'FaceColor','texturemap','EdgeColor','none','Cdata',(heatmap(:,:,i).'/max(max(heatmap(:,:,i)))))
view(3)
grid on
hold on
plot3(xglobal(i),yglobal(i),1,'or')
plot3(xglobal(i),yglobal(i),0,'or')
g1=line([xglobal(i), xglobal(i)], [yglobal(i),yglobal(i)],[0,1],'color','r','linewidth',2)

plot3(xlocal(i),ylocal(i),1,'og')
plot3(xlocal(i),ylocal(i),0,'og')
g2=line([xlocal(i), xlocal(i)], [ylocal(i),ylocal(i)],[0,1],'color','g','linewidth',2)


%---------------
figure
i=7;
x=[0 95;0 95];
y=[0 0;95 95];
z=[0 0;0 0];
colormap(gray)
h=surface(x,y,z);
set(h, 'FaceColor','texturemap','EdgeColor','none','Cdata',(image))

dx=20;
dy=20;
xmin=xglobal(i)-dx;
xmax=xglobal(i)+dx;
ymin=yglobal(i)-dy;
ymax=yglobal(i)+dy;
xr=[xmin xmax;xmin xmax];
yr=[ymin ymin;ymax ymax];

h=surface(xr,yr,z+1);
set(h,'FaceColor','texturemap','EdgeColor','none','Cdata',(heatmap(xmin:xmax,ymin:ymax,i).'/max(max(heatmap(:,:,i)))))
view(3)
grid on
hold on
plot3(xglobal(i),yglobal(i),1,'or')
plot3(xglobal(i),yglobal(i),0,'or')
g1=line([xglobal(i), xglobal(i)], [yglobal(i),yglobal(i)],[0,1],'color','r','linewidth',2)

plot3(xlocal(i),ylocal(i),1,'og')
plot3(xlocal(i),ylocal(i),0,'og')
g2=line([xlocal(i), xlocal(i)], [ylocal(i),ylocal(i)],[0,1],'color','g','linewidth',2)

%-----------
figure
imshow(image)
hold on
scatter(xlocal,ylocal,'go');
scatter(xlocal,ylocal,'g+');

text(xlocal,ylocal+2,num2str([1:15]'),'color','r')


