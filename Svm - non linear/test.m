function [err] = test(testSet,d,gamma,alpha,X,Y,b)
%TEST
    [XV, YV] = generateDataset(testSet,d);
%     YP = b*ones(testSet,1);
%     for i = 1:testSet
%        for j = 1:size(X,1)
%             YP(i) =  + YP(i) + alpha(j)*Y(j)*kernel(X(j),XV(i),gamma);
%        end
%     end
%     YP = (kernel(XV,X,gamma)*(Y.*alpha)) + b*ones(size(XV,1),1);
    YP = kernel(XV,X, gamma)*diag(Y)*alpha+b;

    YP = sign(YP(:,1));
    
    err = sum(YV ~= YP);
end
