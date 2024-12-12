% Deep learning denoising (DnCNN)
clear;
% Loading 
hh=imread("w.jpg");
% Convert to Gray
hh=rgb2gray(hh);
% Adding Noise
% hh = imnoise(hh,'gaussian',0,0.001);
% Image Resize
hh = imresize(hh,[512 512]);

%% denoising convolutional neural network, DnCNN
net = denoisingNetwork('DnCNN');
denoisedI = denoiseImage(hh,net);

subplot(1,2,1)
subimage(hh); title ('Original');
subplot(1,2,2)
subimage(denoisedI); title ('Denoised');

% Plot deep nn structure 
net
figure;
plot(net)

%% Statistics 
%% 12 IQA metrics would be run on single color image, which are:
% (1) The Peak Signal to Noise Ratio (PSNR)
% (2) The Signal to Noise Ratio (SNR) 
% (3) The Mean-Squared Error (MSE) 
% (4) The R-Mean-Squared Error (RMSE) 
% (5) The Mean Absolute Error (MAE) 
% (6) The Measure of Enhancement or Enhancement (EME) 
% (7) The Structural Similarity (SSIM) 
% (8) The Edge-strength Structural Similarity (ESSIM)
% (9) The Non-Shift Edge Based Ratio (NSER) 
% (10)The Edge Based Image Quality Assessment (EBIQA) 
% (11)The Edge and Pixel-Based Image Quality Assessment (EPIQA) 
% (12)The Correlation Coefficient (CC) 

saltnoise=hh;
img=denoisedI;

%% PSNR and SNR between ref and polluted images
[peaksnr, snr] = psnr(saltnoise, img);
fprintf('\n(1) The (PSNR) value is = %0.4f', peaksnr);
fprintf('\n(2) The (SNR) value is = %0.4f ', snr);

%% MSE and RMSE between ref and polluted images
mseerr = immse(saltnoise, img);
rmseerr=sqrt(mseerr);
maeerror= mae(saltnoise, img);
fprintf('\n(3) The (MSE) value is = %0.4f', mseerr);
fprintf('\n(4) The (RMSE) value is = %0.4f', rmseerr);
fprintf('\n(5) The (MAE) value is = %0.4f\n', maeerror);

%% EME
%% Calling measure of enhance- ment, or measure of improvement (EME)
[M M] = size(img);
L = 8;
EME_original = eme(double(img),M,L);
EME_noisyImage = eme(double(saltnoise),M,L);
fprintf('(6) The (EME) value is  = %5.5f \n', abs(EME_original-EME_noisyImage))

%% SSIM and ESSIM
[ssimval, ssimmap] = ssim(saltnoise,img);
fprintf('(7) The (SSIM) value is = %0.4f.\n',ssimval)
[ESSIM_index] = ESSIM(img, saltnoise);
fprintf('(8) The (ESSIM) value is = %0.4f.\n',ESSIM_index)

%% NSER
% LOG filter
H = fspecial('log',10);
logfilter = imfilter(img,H,'replicate');
logfilternoise = imfilter(saltnoise,H,'replicate');
% Zero crossing edge points
threshzero=[5 90];%it is possible to play with threshold
zerocrossing = edge(logfilter,'zerocross',threshzero);
zerocrossingnoise = edge(logfilternoise,'zerocross',threshzero);
%NSE of two binary images
NSE=zerocrossing & zerocrossingnoise;
% log 10 of final image
logarithmfinal = log10(double(NSE));
%2-D correlation coefficient for final NSER
NSER = corr2(NSE,zerocrossing);
fprintf('(9) The (NSER) value is = %0.4f.\n',NSER)

%% EBIQA
% Resizing image (both images)
org = imresize(img, [256 256]);
noisy = imresize(saltnoise, [256 256]);
% Adding Sobel noise (both images)
org = edge(org,'Sobel');%imshow(org);
noisy = edge(noisy,'Sobel');%imshow(noisy);
% Dividing to 16*16 blocks (both images)
blocksorg=mat2tiles(org,[16,16]);
blocksnoisy=mat2tiles(noisy,[16,16]);
%EOI (Edge Orientation in Image): The number of edges which exists in each block
blocksorgsize=size(blocksorg);
for i=1:blocksorgsize(1,1)
   for j=1:blocksorgsize(1,2)
[labeledImage{i,j}, numberOfEdges{i,j}] = bwlabel(blocksorg{i,j});end;end;
for i=1:blocksorgsize(1,1)
   for j=1:blocksorgsize(1,2)
[labeledImagen{i,j}, numberOfEdgesn{i,j}] = bwlabel(blocksnoisy{i,j});end;end;
%PLE (Primitive Length of Edges): The number of pixels which exists in each block
for i=1:blocksorgsize(1,1)
   for j=1:blocksorgsize(1,2)
numberOfPixels{i,j} = nnz(blocksorg{i,j});end;end;
for i=1:blocksorgsize(1,1)
   for j=1:blocksorgsize(1,2)
numberOfPixelsn{i,j} = nnz(blocksnoisy{i,j});end;end;
%ALE (Average Length of the Edges): Lengths of edges in a block
for i=1:blocksorgsize(1,1)
   for j=1:blocksorgsize(1,2)
lengthOfEdges{i,j} = sum(blocksorg{i,j});end;end;
for i=1:blocksorgsize(1,1)
   for j=1:blocksorgsize(1,2)
lengthOfEdgesn{i,j} = sum(blocksnoisy{i,j});end;end;
% Average Length of the Edges
for i=1:blocksorgsize(1,1)
   for j=1:blocksorgsize(1,2)
averageEdgeLength{i,j} = lengthOfEdges{i,j} / numberOfEdges{i,j};end;end;
for i=1:blocksorgsize(1,1)
   for j=1:blocksorgsize(1,2)
averageEdgeLengthn{i,j} = lengthOfEdgesn{i,j} / numberOfEdgesn{i,j};end;end;
% NEP (Number of Edge Pixels): it is total number of pixels
totalnumberOfPixels= nnz(org);
totalnumberOfPixelsn= nnz(noisy);
% Euclidean distance claculation
for i=1:blocksorgsize(1,1)
   for j=1:blocksorgsize(1,2)
Euclideandiste(i,j) = pdist2(numberOfEdges{i,j},numberOfEdgesn{i,j});
Euclideandistp(i,j) = pdist2(numberOfPixels{i,j},numberOfPixelsn{i,j});
Euclideandistl(i,j) = pdist2(lengthOfEdges{i,j},lengthOfEdgesn{i,j});
Euclideandistt=pdist2(totalnumberOfPixels,totalnumberOfPixelsn);
end;end;
% Final matrix
Euclideandisfinal=[Euclideandiste Euclideandistp Euclideandistl];
% Average of final matrix (lower number shows higher quality)
EBIQA=mean(mean(Euclideandisfinal));
fprintf('(10)The (EBIQA) value is = %0.4f.\n',EBIQA)

%% Edge and Pixel-Based Image Quality Assessment Metric
EPIQA= (peaksnr)+ EBIQA;
fprintf('(11)The (EPIQA) value is = %0.4f.\n',EPIQA)

%% Correlation Coefficient
cc= corr2(saltnoise, img);
fprintf('(12)The (CC) value is = %0.4f\n', cc);
