function [err] = testNew(gamma,alpha,b,X,Y,XT,YT)
%TEST
    YP = kernel(XT,X, gamma)*diag(Y)*alpha+b;

    YP = sign(YP(:,1));
    
    err = sum(YT ~= YP);
end
