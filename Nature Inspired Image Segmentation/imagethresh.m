
function result= imagethresh(x,B);
global H Index;

% Converting the 2d matrix to 1d matrix.
V=reshape(B,[],1);

%The histogram of the values from 0 to 255 is stored.
%For instance, G(1) contains the number of occurrence of the value zero in
%the image.
G=hist(V,0:255);
H=reshape(G,[],1);
% 'index' is a 1 dimensional matrix ranging between 0 and 255
Ind=0:255;
Index=reshape(Ind,[],1);
result=zeros(size([1 256]));

%To avoid many for loops I used only 1 for loop and a function to calculate the weight, mean and %variance.
%Let me explain the foreground and the background for a value of ‘i’.
%if ‘i’ value is 5 then the foreground values will be 0,1,2,3,4,5
%and the background values will be 6 to 255.

if(x(1)<0)
x(1)=0;
elseif(x(1)>255)
x(1)=254;
end
[wbk,varbk]=calculate(1,round(x(1)),H,Index);
[wfg,varfg]=calculate(round(x(1))+1,255,H,Index);
%After calculating the weights and the variance, the final computation is stored in the array %‘result’.
result=(wbk*varbk)+(wfg*varfg);
end

function [weight,var]=calculate(m,n,H,Index);
%Weight Calculation
weight=sum(H(m:n))/sum(H);

%Mean Calculation
value=H(m:n).*Index(m:n);
total=sum(value);
mean=total/sum(H(m:n));
if(isnan(mean)==1)
mean=0;
end
%Variance calculation.
value2=(Index(m:n)-mean).^2;
numer=sum(value2.*H(m:n));
var=numer/sum(H(m:n));
if(isnan(var)==1)
var=0;
end
end