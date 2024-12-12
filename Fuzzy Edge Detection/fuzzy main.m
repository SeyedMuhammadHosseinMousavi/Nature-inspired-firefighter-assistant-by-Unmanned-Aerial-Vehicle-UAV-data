%% Fuzzy Edge Detection
clc;
clear;
Irgb=imread('cc.jpg'); 
[Ieval]=fuzzyedge(Irgb);
FuzzyEdge=imcomplement(Ieval);

