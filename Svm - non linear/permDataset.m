function [X,Y, XT, YT] = permDataset(X_start,Y_start, percentageDivision)
%PERMDATASET Summary of this function goes here
%   Detailed explanation goes here
while percentageDivision >= 1
   percentageDivision = percentageDivision / 100; 
end

n = size(X_start,1);
rndIdx = randperm(n);
il = rndIdx(1:round(n*percentageDivision));
it = rndIdx(1 + round(n*percentageDivision):end);
X = X_start(il,:);
Y = Y_start(il,:);
XT = X_start(it,:);
YT = Y_start(it,:);
end

