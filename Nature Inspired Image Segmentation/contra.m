
function result= contra(x,B);

bins=16;
[h d]=histeq(B,bins);
ps1=psnr(B,h);

if ps1 > 20
    res=d;
else
%     bins=bins*2;
    res=d;
end

result=res;
end

