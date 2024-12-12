% Performance Metrics
clear;
% a=imread('a.jpg');
% a=im2double(a);
% b1 = imnoise(a,'salt & pepper',0.07);
% b1=imbinarize(b1);
% se = strel('disk',2);
% b = imclose(b1,se);
% b=im2double(b);

a=imread('s1.jpg');
% a=im2double(a);
% a=im2bw(a);
b=imread('s2.jpg');
% b=im2bw(b);



[Accuracy, Sensitivity, Fmeasure, Precision,...
MCC, Dice, Jaccard, Specitivity] = SegPerformanceMetrics(a, b);
disp(['Accuracy is : ' num2str(Accuracy) ]);
disp(['Precision is : ' num2str(Precision) ]);
disp(['Recall or Sensitivity is : ' num2str(Sensitivity) ]);
disp(['F-Score or Fmeasure is : ' num2str(Fmeasure) ]);
disp(['IoU or Jaccard is : ' num2str(Jaccard) ]);
disp(['Specitivity is : ' num2str(Specitivity) ]);
disp(['MCC is : ' num2str(MCC) ]);
disp(['PSNR is : ' num2str(psnr(im2double(rgb2gray(a)), im2double(rgb2gray(b)))) ]);
disp(['MSE is : ' num2str(mse(im2double(rgb2gray(a)), im2double(rgb2gray(b)))) ]);

% net = denoisingNetwork('DnCNN');
% aa=imread('tt.jpg');
% aa=rgb2gray(a);
% denoisedI = denoiseImage(aa,net);
% psnr(aa,denoisedI);
