%% Smoke Detection
% Loading 
clear;
warning('off');
img=imread('d.jpg');
%
orgg=img;
rrr=img(:,:,1);
ggg=img(:,:,2);
bbb=img(:,:,3);
%
HSV2 = rgb2hsv(orgg);
hhh=imadjust(HSV2(:,:,1));
sss=imadjust(HSV2(:,:,2));
vvv=imadjust(HSV2(:,:,3));
%
YCBCR2 = rgb2ycbcr(orgg);
yyy=imadjust(YCBCR2(:,:,1));
cb2=imadjust(YCBCR2(:,:,2));
cr2=imadjust(YCBCR2(:,:,3));
%
lab2 = rgb2lab(orgg);
lll=imadjust(lab2(:,:,1));
aaa=imadjust(lab2(:,:,2));
bbbb=imadjust(lab2(:,:,3));
% Seperating rgb color channels and adjust the intensity
r=imadjust(img(:,:,1));
g=imadjust(img(:,:,2));
b=imadjust(img(:,:,3));
adj = cat(3, r, g, b);
%
filt=[3 3];
r=medfilt2(r,filt);
g=medfilt2(g,filt);
b=medfilt2(b,filt);
% Bringing back rgb channels as a single rgb color image
rgb = cat(3, r, g, b);
r=imadjust(rgb(:,:,1));
g=imadjust(rgb(:,:,2));
B=imadjust(rgb(:,:,3));
% rgb = medfilt2(rgb,[3 3])
% Converting to HSV color space and seperating channels 
HSV = rgb2hsv(rgb);
h=imadjust(HSV(:,:,1));
s=imadjust(HSV(:,:,2));
v=imadjust(HSV(:,:,3));
% Converting to YCbCr color space
YCBCR = rgb2ycbcr(rgb);
y=imadjust(YCBCR(:,:,1));
cb=imadjust(YCBCR(:,:,2));
cr=imadjust(YCBCR(:,:,3));
% Converting to Lab color space
lab = rgb2lab(rgb);
l=imadjust(lab(:,:,1));
a=imadjust(lab(:,:,2));
b=imadjust(lab(:,:,3));
% Converting to xyz
XYZ = rgb2xyz(rgb);
X=imadjust(XYZ(:,:,1));
Y=imadjust(XYZ(:,:,2));
Z=imadjust(XYZ(:,:,3));
% CAT Red from rgb, H from hsv, and A from Lab 
RHA = cat(3, h, cb, a);
R1=imadjust(RHA(:,:,1)); R1=im2bw(R1);
G1=imadjust(RHA(:,:,2)); G1=im2bw(G1);
B1=imadjust(RHA(:,:,3)); B1=im2bw(B1);
% Closing Morphology
se = strel('disk',6);
closeBW1 = imopen(R1,se);
closeBW2 = imopen(G1,se);
closeBW3 = imopen(B1,se);
% Boundary 
sizeimg=size(closeBW3);
for i=1:sizeimg(1,1)
for j=1:sizeimg(1,2)
if closeBW3(i,j)>0
newgray2(i,j)=closeBW3(i,j);
else
newgray2(i,j)=0;
end;end;end;
[B2,L2,N2,A2] = bwboundaries(newgray2);

subplot(2,5,1);imshow(adj,[]);title('R + G + B (Histogram Equalized)');
subplot(2,5,2);imshow(rgb,[]);title('R + G + B (Median Filter)');
subplot(2,5,3);imshow(RHA,[]);title('H - Cb - a');
subplot(2,5,4);imshow(R1);title('BW H');
subplot(2,5,5);imshow(G1);title('BW Cb');
subplot(2,5,6);imshow(B1);title('BW a');
subplot(2,5,7);imshow(closeBW1);title('Close BW H');
subplot(2,5,8);imshow(closeBW2);title('Close BW Cb');
subplot(2,5,9);imshow(closeBW3);title('Close BW a');
subplot(2,5,10);
imshow(rgb);title('Smoke');
hold on;
for k = 1:length(B2)
boundary = B2{k};plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2);
end;title('Smoke');hold off;

% Plots
figure;
subplot(4,4,1);imshow(r);title('R');
subplot(4,4,2);imshow(g);title('G');
subplot(4,4,3);imshow(B);title('B');
subplot(4,4,4);imshow(rgb);title('RGB');
subplot(4,4,5);imshow(h);title('H');
subplot(4,4,6);imshow(s);title('S');
subplot(4,4,7);imshow(v);title('V');
subplot(4,4,8);imshow(HSV);title('HSV');
subplot(4,4,9);imshow(y);title('Y');
subplot(4,4,10);imshow(cb);title('Cb');
subplot(4,4,11);imshow(cr);title('Cr');
subplot(4,4,12);imshow(YCBCR);title('YCbCr');
subplot(4,4,13);imshow(l);title('L');
subplot(4,4,14);imshow(a);title('a');
subplot(4,4,15);imshow(b);title('b');
subplot(4,4,16);imshow(lab);title('Lab');

% Raw plots
% imshow(orgg);title('RGB');
% imshow(rrr);title('R');
% imshow(ggg);title('G');
% imshow(bbb);title('B');
% imshow(HSV2);title('HSV');
% imshow(hhh);title('H');
% imshow(sss);title('S');
% imshow(vvv);title('V');
% imshow(YCBCR2);title('YCbCr');
% imshow(yyy);title('Y');
% imshow(cb2);title('Cb');
% imshow(cb2);title('Cr');
% imshow(lab2);title('Lab');
% imshow(lll,[]);title('L');
% imshow(aaa);title('a');
% imshow(bbbb);title('b');

