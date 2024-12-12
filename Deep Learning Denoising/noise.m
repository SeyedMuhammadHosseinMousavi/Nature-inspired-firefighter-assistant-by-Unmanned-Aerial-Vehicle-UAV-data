% Noise
clear;
% Loading 
im=imread("noise.jpg");
% im=rgb2gray(im);
% Adding noise
gauss= imnoise(im,'gaussian',0,0.05);
salt = imnoise(im,'salt & pepper',0.1);
% Median filter
r=gauss(:,:,1);g=gauss(:,:,2);b=gauss(:,:,3);
r2=salt(:,:,1);g2=salt(:,:,2);b2=salt(:,:,3);
%
filt=[3 3];
gaussmed1=medfilt2(r,filt);
gaussmed2=medfilt2(g,filt);
gaussmed3=medfilt2(b,filt);
gaussmed = cat(3, gaussmed1, gaussmed2, gaussmed3);
%
saltmed1=medfilt2(r2,filt);
saltmed2=medfilt2(g2,filt);
saltmed3=medfilt2(b2,filt);
saltmed = cat(3, saltmed1, saltmed2, saltmed3);
% DnCNN filter
net = denoisingNetwork('DnCNN');
deep1 = denoiseImage(r,net);
deep2 = denoiseImage(g,net);
deep3 = denoiseImage(b,net);
gaussdeep = cat(3, deep1, deep2, deep3);
%
deep4 = denoiseImage(r2,net);
deep5 = denoiseImage(g2,net);
deep6 = denoiseImage(b2,net);
saltdeep = cat(3, deep4, deep5, deep6);
% Plot
subplot(2,3,1)
imshow(gauss);title('Gaussian Noise');
subplot(2,3,2)
imshow(gaussmed);title('Median on Gaussian Noise');
subplot(2,3,3)
imshow(gaussdeep);title('DnCNN on Gaussian Noise');
subplot(2,3,4)
imshow(salt);title('Impulse Noise');
subplot(2,3,5)
imshow(saltmed);title('Median on Impulse Noise');
subplot(2,3,6)
imshow(saltdeep);title('DnCNN on Impulse Noise');
% Statistics
[GaussMed, snr] = psnr(gaussmed, im);
fprintf('\n(1) The (PSNR) value is = %0.4f', GaussMed);
[SaltMed, snr] = psnr(saltmed, im);
fprintf('\n(1) The (PSNR) value is = %0.4f', SaltMed);

[GaussDeep, snr] = psnr(gaussdeep, im);
fprintf('\n(1) The (PSNR) value is = %0.4f', GaussDeep);
[SaltDeep, snr] = psnr(saltdeep, im);
fprintf('\n(1) The (PSNR) value is = %0.4f', SaltDeep);
