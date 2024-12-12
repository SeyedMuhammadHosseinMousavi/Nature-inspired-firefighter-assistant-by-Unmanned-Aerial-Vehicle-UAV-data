
%% Nature Inspired Segmentation
% Cleaning and Loading
clear;
img=imread('bbb.jpg');

% Pre-processing
img_gray=rgb2gray(img);
img_gray=imadjust(img_gray);
% img_gray=histeq(img_gray);
img_gray= imsharpen(img_gray,'Radius',2,'Amount',1);
[sharp,pic]=sharppolished(img_gray);
comp = imcomplement(sharp);
canny = edge(img_gray,'canny');
canny=im2double(canny);
% Fuzzy Edges
% Irgb=img; 
% [Ieval]=fuzzyedge(Irgb);
% FuzzyEdge=imcomplement(Ieval);

% Channels
gray=rgb2gray(img);
r = img(:, :, 1);g = img(:, :, 2);b = img(:, :, 3);
h1=imadjust(r);h2=imadjust(g);h3=imadjust(b);
img=cat(3,h1,h2,h3);
sizimg=size(img);
for i=1:sizimg(1,1)
for j=1:sizimg(1,2)
if r(i,j)>180 && g(i,j)>100 && g(i,j)<220 && b(i,j)>40 && b(i,j)<170
fire(i,j)=1;
fire2(i,j)=1;
else
fire(i,j)=gray(i,j);fire2(i,j)=0;
end;end;end;
binfire=imbinarize(fire);

% Median Filter
% img_gray = medfilt2(img_gray,[5 5]);

NS= 5; % Number of segments
itr=100; % Number of iterations
popl=2; % Number of population

%% Nature Inspired Part
% de = Differential Evolution
% fa = FireFly
% sce = Shuffled Complex Evolution
% sfla = Shuffled Frog Leaping Algorithm
% abc = Artificial Bee Colony
% bees = Bees Algorithm
[Cost1,thresh1,variance1] = bees(img_gray, NS, itr, popl);

%% Statistics and Plot

% Nature Inspired
sortT=sort(thresh1);
seg_I = imquantize(img_gray,sortT); 
RGB = label2rgb(seg_I); 
grayrgb=rgb2gray(RGB);

% Otsu
Otsuthresh = multithresh(img_gray,NS);
Otsuseg_I = imquantize(img_gray,Otsuthresh);
OtsuRGB = label2rgb(Otsuseg_I); 
otsugrayrgb=rgb2gray(OtsuRGB);

% Nature Inspired (segmenting segmented) 
[Cost2,thresh2,variance1] = bees(grayrgb, round(NS/2)+1, itr, popl);
sortT2=sort(thresh2);
seg_I2 = imquantize(grayrgb,sortT2); 
segseg = label2rgb(seg_I2); 

% Nature Inspired (segmenting edge detected) 
[Cost3,thresh3,variance1] = bees(comp, NS, itr, popl);
sortT3=sort(thresh3);
seg_I3 = imquantize(comp,sortT3); 
edgeseg = label2rgb(seg_I3); 

% Nature Inspired (segmenting preprocessed) 
[Cost5,thresh5,variance1] = bees(fire, round(NS/2)+1, itr, popl);
sortT5=sort(thresh5);
seg_I5 = imquantize(fire,sortT5); 
preproc = label2rgb(seg_I5); 

% Nature Inspired (Median filter on bio segmented) 
medseg = medfilt2(grayrgb,[3 3]);
[Cost6,thresh6,variance1] = bees(medseg, NS, itr, popl);
sortT6=sort(thresh5);
seg_I6 = imquantize(medseg,sortT6); 
medianseg = label2rgb(seg_I6); 

% kmeans
he = img;
lab_he = rgb2lab(img);
ab = lab_he(:,:,2:3);
ab = im2single(ab);
nColors = NS;
pixel_labels = imsegkmeans(ab,nColors,'NumAttempts',4);
mask1 = pixel_labels==1;cluster1 = he .* uint8(mask1);
mask2 = pixel_labels==2;cluster2 = he .* uint8(mask2);
mask3 = pixel_labels==3;cluster3 = he .* uint8(mask3);


% Boundary 
sizeimg=size(grayrgb);
for i=1:sizeimg(1,1)
for j=1:sizeimg(1,2)
if fire2(i,j)>0
newgray(i,j)=fire2(i,j);
else
newgray(i,j)=0;
end;end;end;
[B,L,N,A] = bwboundaries(newgray);


figure;
subplot(4,4,1);imshow(img); title('Original');
subplot(4,4,2);imshow(img_gray);title('Gray');
subplot(4,4,3);imshow(RGB);title('Nature Inspire Segmented');
subplot(4,4,4);imshow(OtsuRGB);title('Otsu Segmented');
subplot(4,4,5);imshow(grayrgb);title('Gray Segmented');
subplot(4,4,6);imshow(segseg);title('Segmenting Segmented');
subplot(4,4,7);imshow(edgeseg);title('Edge Segmented');
subplot(4,4,8);imshow(preproc,[]);title('Processed');
subplot(4,4,9);imshow(fire2,[]);title('Processed 2');
subplot(4,4,10);imshow(pixel_labels,[]);title('K-Means');
subplot(4,4,11);imshow(medianseg,[]);title('Median on Bio Seg');
% subplot(4,4,12);imshow(FuzzyEdge,[]);title('Fuzzy Edge');
subplot(4,4,13);
imshow(img);hold on;
for k = 1:length(B)
boundary = B{k};plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2);
end;title('Original with Boundaries ');hold off;
subplot(4,4,14);plot(Cost1);title('Cost');

% Performance Metrics

[Accuracy, Sensitivity, Fmeasure, Precision,...
MCC, Dice, Jaccard, Specitivity] = SegPerformanceMetrics(RGB, OtsuRGB);
disp(['Accuracy is : ' num2str(Accuracy) ]);
disp(['Precision is : ' num2str(Precision) ]);
disp(['Recall or Sensitivity is : ' num2str(Sensitivity) ]);
disp(['F-Score or Fmeasure is : ' num2str(Fmeasure) ]);
disp(['Dice is : ' num2str(Dice) ]);
disp(['Jaccard is : ' num2str(Jaccard) ]);
disp(['Specitivity is : ' num2str(Specitivity) ]);
disp(['MCC is : ' num2str(MCC) ]);
disp(['PSNR is : ' num2str(psnr(im2double(rgb2gray(RGB)), im2double(rgb2gray(OtsuRGB)))) ]);
disp(['MSE is : ' num2str(mse(im2double(rgb2gray(RGB)), im2double(rgb2gray(OtsuRGB)))) ]);
disp(['MAE is : ' num2str(mae(im2double(rgb2gray(RGB)), im2double(rgb2gray(OtsuRGB)))) ]);
disp(['SSIM is : ' num2str(ssim(im2double(rgb2gray(RGB)), im2double(rgb2gray(OtsuRGB)))) ]);


