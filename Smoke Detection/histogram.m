% Loading 
clear;
warning('off');
img=imread('q2.jpg');
[he tr]= histeq(img);
subplot(2,3,1)
imshow(img);title('Original','FontSize', 17);
subplot(2,3,2)
imshow(he);title('Histogram Equalized','FontSize', 17);
subplot(2,3,3)

[counts2, grayLevels2]=imhist(img,128);
bar(grayLevels2, counts2,'g','BarWidth', 1);title('Original Histogram','FontSize', 17);
set(gca,'Color','k',FontSize = 17);

subplot(2,3,4)

[counts, grayLevels]=imhist(he,128);
bar(grayLevels, counts,'g','BarWidth', 1);title('HE Histogram','FontSize', 17);
set(gca,'Color','k',FontSize = 17);

subplot(2,3,5)
plot(tr,'-g','linewidth',2);title('Transformation Curve','FontSize', 17);
set(gca,'Color','k');
ax = gca; 
ax.FontSize = 17; 
