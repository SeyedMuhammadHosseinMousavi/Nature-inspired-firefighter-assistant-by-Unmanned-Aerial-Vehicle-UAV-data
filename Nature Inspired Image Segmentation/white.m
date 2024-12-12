
clear;
img=imread('white.jpg');
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
if r(i,j)>252 && g(i,j)>252 && b(i,j)252
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
[Cost1,thresh1,variance1] = bees(gray, NS, itr, popl);
% Nature Inspired
sortT=sort(thresh1);
seg_I = imquantize(gray,sortT); 
RGB = label2rgb(seg_I); 
grayrgb=rgb2gray(RGB);

% Nature Inspired (segmenting preprocessed) 
[Cost5,thresh5,variance1] = bees(fire, round(NS/2)+1, itr, popl);
sortT5=sort(thresh5);
seg_I5 = imquantize(fire,sortT5); 
preproc = label2rgb(seg_I5); 

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

% Closing Morphology
base=imbinarize(L);
se = strel('disk',5);
closeBW = imclose(base,se);
% figure, imshow(closeBW);

% Boundary 2
sizeimg=size(closeBW);
for i=1:sizeimg(1,1)
for j=1:sizeimg(1,2)
if closeBW(i,j)>0
newgray2(i,j)=closeBW(i,j);
else
newgray2(i,j)=0;
end;end;end;
[B2,L2,N2,A2] = bwboundaries(newgray2);

% Morphology second step
base2=imbinarize(L2);
se = strel('diamond',10);
closeBW2 = imclose(base2,se);
%% Bees segmented
morph = label2rgb(closeBW2); 

% Plot
subplot(2,3,1);imshow(org); title('Original','FontSize', 17);
subplot(2,3,2);imshow(img);title('CSO Intensity Adjusted','FontSize', 17);
subplot(2,3,3);imshow(sharped);title('Unsharp Masked','FontSize', 17);
subplot(2,3,4);imshow(denoised);title('Denoised CNN','FontSize', 17);
subplot(2,3,5);imshow(morph,[]);title('Bees Segmented','FontSize', 17);
subplot(2,3,6);
imshow(denoised);hold on;
for k = 1:length(B2)
boundary = B2{k};plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2);
end;title('Closing Morphology Boundaries','FontSize', 17);hold off;

%% Fire intensity and direction

% image regions properties 
center = regionprops(closeBW2,'centroid');
area = regionprops(closeBW2,'Area');
Orientation=regionprops(closeBW2,'Orientation');
majoraxis=regionprops(closeBW2,'MajorAxisLength');
minoraxis=regionprops(closeBW2,'MinorAxisLength');
EquivDiameter=regionprops(closeBW2,'EquivDiameter');
Perimeter=regionprops(closeBW2,'Perimeter');
Solidity=regionprops(closeBW2,'Solidity');
Extent=regionprops(closeBW2,'Extent');

% Converting struct to matrix
a=struct2cell(center);
raduis=struct2cell(minoraxis); 
angles=struct2cell(Orientation);

% angle = abs(angles-360);
% Plot fire intensity
sizecent=size(a);sizecent=sizecent(1,2);
rad2=cell2mat(raduis); 
rankrad=rescale (rad2, 1,sizecent*2);
rankrad=round(rankrad); % fire circle size
figure;

% Annotation
ang2=cell2mat(angles);
rad3=cell2mat(angles);

area2=cell2mat(struct2cell(area));
for i=1:sizecent
names(i)={['Intensity and Direction are = ' num2str(area2(i)) ' and ' num2str(rad3(i))]};
tm=a{i};
position(i,1:4) = [tm(1,1), tm(1,2)+60 3 3];
end
tasvir = insertObjectAnnotation(im2double(closeBW2),'rectangle',position,names,...
    'TextBoxOpacity',0.9,'FontSize',20);
% imshow(tasvir);
% hold on;

imshow(tasvir);
for i=1:sizecent
tm=a{i};
rad=raduis{i};
angle = abs(angles{i}-360);
lineLength = raduis{i}+10;
viscircles([tm(1,1), tm(1,2)], rad+10,'linewidth',rankrad(i)+1);
x(1) = tm(1,1);
y(1) = tm(1,2);
x(2) = x(1) + lineLength * cosd(angle);
y(2) = y(1) + lineLength * sind(angle);
hold on;  
plot(x, y,'--b','linewidth',2);
title('Fire Intensity and Direction','FontSize', 17);
end
hold off;

% Statistics
disp(['Area is : ' num2str(area.Area)]);
disp(['Orientation is : ' num2str(Orientation.Orientation)]);
disp(['Major Axis Length is : ' num2str(majoraxis.MajorAxisLength)]);
disp(['Minor Axis Length is : ' num2str(minoraxis.MinorAxisLength)]);
disp(['Equal Diameter is : ' num2str(EquivDiameter.EquivDiameter)]);
disp(['Perimeter is : ' num2str(Perimeter.Perimeter)]);
disp(['Solidity is : ' num2str(Solidity.Solidity)]);
disp(['Extent is : ' num2str(Extent.Extent)]);



