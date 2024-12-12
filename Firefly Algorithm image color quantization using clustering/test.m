
clear;
img=imread('gree.jpg');
org=img;
% Channels intensity adjustment 
r = img(:, :, 1);g = img(:, :, 2);b = img(:, :, 3);
h1=imadjust(r);h2=imadjust(g);h3=imadjust(b);
% Sharp
sharp1= imsharpen(h1,'Radius',2,'Amount',1);
sharp2= imsharpen(h2,'Radius',2,'Amount',1);
sharp3= imsharpen(h3,'Radius',2,'Amount',1);
sharped=cat(3,sharp1,sharp2,sharp3);
% Denoise
denoise1 = medfilt2(sharp1,[3 3]);
denoise2 = medfilt2(sharp2,[3 3]);
denoise3 = medfilt2(sharp3,[3 3]);
denoised=cat(3,denoise1,denoise2,denoise3);

img=cat(3,h1,h2,h3);
gray=rgb2gray(img);
gray = medfilt2(gray,[3 3]);
% Pre-processing
sizimg=size(img);
for i=1:sizimg(1,1)
for j=1:sizimg(1,2)
if r(i,j)>180 && g(i,j)>100 && g(i,j)<220 && b(i,j)>40 && b(i,j)<170
fire(i,j)=1;
fire2(i,j)=1;
else
fire(i,j)=gray(i,j);
fire2(i,j)=0;
end;end;end;
binfire=imbinarize(fire);
% 

%% Nature Inspired Part
NS= 5; % Number of segments
itr=100; % Number of iterations
popl=2; % Number of population
% Nature Inspired Segmentation
[Cost1,thresh1,variance1] = bees(gray, NS, itr, 2);
%
[Cost2,thresh2,variance2] = bees(gray, 2, itr, 4);

%
figure;
plot(a,'-oc','linewidth',1,'MarkerSize',6,'MarkerFaceColor',[0.2,0.9,0.2]);
title(' Train','FontSize', 17);
xlabel(' Iteration Number','FontSize', 17);
ylabel(' Best Cost Value','FontSize', 17);
xlim([0 inf])
hold on;
plot(b,'-og','linewidth',1,'MarkerSize',6,'MarkerFaceColor',[0.9,0.2,0.2]);
title(' Train','FontSize', 17);
xlabel(' Iteration Number','FontSize', 17);
ylabel(' Best Cost Value','FontSize', 17);
xlim([0 inf])
ax = gca; 
ax.FontSize = 17; 
set(gca,'Color','k')
legend({'Thermal','Color'},'FontSize',12,'TextColor','yellow');
